import { NextResponse, type NextRequest } from "next/server";
import { z } from "zod";
import { authenticateRequest } from "@/lib/supabase/server";
import { XP_BY_DIFFICULTY, type QuestDifficulty } from "@/lib/types";

const AcceptTemplateSchema = z.object({
  template_id: z.string().uuid(),
  action: z.enum(["accept", "remove"]).default("accept"),
});

const CustomQuestSchema = z.object({
  is_custom: z.literal(true),
  title: z.string().min(1).max(200),
  description: z.string().max(2000).optional(),
  frequency: z.enum(["daily", "weekly", "monthly", "one_time"]),
  difficulty: z.enum(["trivial", "easy", "medium", "hard", "deadly", "legendary"]),
});

const BodySchema = z.union([AcceptTemplateSchema, CustomQuestSchema]);

// GET /api/village/[npcId]/quests
// Returns NPC details, templates with acceptance status, and user's custom quests for this NPC.
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ npcId: string }> }
) {
  const { npcId } = await params;
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const [npcRes, templatesRes, userQuestsRes, connectionRes] = await Promise.all([
    supabase.from("npc_quest_givers").select("*").eq("id", npcId).single(),
    supabase.from("npc_quest_templates").select("*").eq("npc_id", npcId).order("sort_order"),
    supabase.from("quests").select("*").eq("user_id", user.id).eq("npc_quest_giver_id", npcId).eq("status", "active"),
    supabase.from("user_npc_connections").select("id").eq("user_id", user.id).eq("npc_id", npcId).maybeSingle(),
  ]);

  if (npcRes.error) return NextResponse.json({ error: npcRes.error.message }, { status: 404 });

  // Map templates to include the accepted quest id if this user has accepted them
  const acceptedByTemplate: Record<string, string> = {};
  for (const q of userQuestsRes.data ?? []) {
    const quest = q as { npc_template_id: string | null; id: string };
    if (quest.npc_template_id) acceptedByTemplate[quest.npc_template_id] = quest.id;
  }

  const templates = (templatesRes.data ?? []).map((t: Record<string, unknown>) => ({
    ...t,
    accepted_quest_id: acceptedByTemplate[t.id as string] ?? null,
  }));

  // Custom quests = active quests for this NPC with no template linkage
  const customQuests = (userQuestsRes.data ?? []).filter(
    (q: Record<string, unknown>) => q.npc_template_id === null
  );

  return NextResponse.json({
    npc: npcRes.data,
    is_connected: connectionRes.data !== null,
    templates,
    custom_quests: customQuests,
  });
}

// POST /api/village/[npcId]/quests
// Accept a template quest, remove an accepted quest, or create a custom quest.
export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ npcId: string }> }
) {
  const { npcId } = await params;
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const body = await request.json().catch(() => null);
  const parsed = BodySchema.safeParse(body);
  if (!parsed.success) return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 });

  // --- Custom quest ---
  if ("is_custom" in parsed.data) {
    const { frequency, difficulty, title, description } = parsed.data;
    const questType = frequency === "daily" ? "daily" : "side";
    const recurrenceRule = frequency === "weekly" ? "weekly" : frequency === "monthly" ? "monthly" : null;
    const xpReward = XP_BY_DIFFICULTY[difficulty as QuestDifficulty];

    const { data, error } = await supabase
      .from("quests")
      .insert({
        user_id: user.id,
        npc_quest_giver_id: npcId,
        title,
        description: description ?? null,
        quest_type: questType,
        difficulty,
        xp_reward: xpReward,
        recurrence_rule: recurrenceRule,
      })
      .select()
      .single();

    if (error) return NextResponse.json({ error: error.message }, { status: 500 });
    return NextResponse.json({ quest: data }, { status: 201 });
  }

  // --- Accept or remove template ---
  const { template_id, action } = parsed.data;

  if (action === "remove") {
    // Archive the quest linked to this template
    const { error } = await supabase
      .from("quests")
      .update({ status: "archived" })
      .eq("user_id", user.id)
      .eq("npc_quest_giver_id", npcId)
      .eq("npc_template_id", template_id)
      .eq("status", "active");

    if (error) return NextResponse.json({ error: error.message }, { status: 500 });
    return NextResponse.json({ ok: true });
  }

  // Accept: look up template then create quest
  const { data: template, error: tErr } = await supabase
    .from("npc_quest_templates")
    .select("*")
    .eq("id", template_id)
    .eq("npc_id", npcId)
    .single();

  if (tErr || !template) return NextResponse.json({ error: "Template not found" }, { status: 404 });

  const t = template as {
    frequency: string;
    difficulty: string;
    xp_reward: number;
    title: string;
    description: string | null;
  };

  const questType = t.frequency === "daily" ? "daily" : "side";
  const recurrenceRule =
    t.frequency === "weekly" ? "weekly" : t.frequency === "monthly" ? "monthly" : null;

  const { data: quest, error: qErr } = await supabase
    .from("quests")
    .insert({
      user_id: user.id,
      npc_quest_giver_id: npcId,
      npc_template_id: template_id,
      title: t.title,
      description: t.description ?? null,
      quest_type: questType,
      difficulty: t.difficulty,
      xp_reward: t.xp_reward,
      recurrence_rule: recurrenceRule,
    })
    .select()
    .single();

  if (qErr) return NextResponse.json({ error: qErr.message }, { status: 500 });
  return NextResponse.json({ quest }, { status: 201 });
}
