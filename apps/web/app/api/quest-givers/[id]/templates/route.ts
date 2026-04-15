import { NextResponse, type NextRequest } from "next/server";
import { z } from "zod";
import { authenticateRequest } from "@/lib/supabase/server";
import { XP_BY_DIFFICULTY, type QuestDifficulty } from "@/lib/types";

// Adventurer accepts or removes a template subscription
const SubscribeSchema = z.object({
  template_id: z.string().uuid(),
  action: z.enum(["accept", "remove"]).default("accept"),
});

// Giver creates a new template
const CreateTemplateSchema = z.object({
  is_create: z.literal(true),
  title: z.string().min(1).max(200),
  description: z.string().max(2000).optional(),
  frequency: z.enum(["daily", "weekly", "monthly", "one_time"]),
  difficulty: z.enum(["trivial", "easy", "medium", "hard", "deadly", "legendary"]),
  sort_order: z.number().int().optional(),
});

// Giver deletes a template (archives linked active quests first)
const DeleteTemplateSchema = z.object({
  is_delete: z.literal(true),
  template_id: z.string().uuid(),
});

const BodySchema = z.union([SubscribeSchema, CreateTemplateSchema, DeleteTemplateSchema]);

// GET /api/quest-givers/[id]/templates
// Returns the relationship details, templates with accepted_quest_id, and accepted quests.
// Works for both the adventurer (user_id) and the giver (giver_user_id).
export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  // Fetch the relationship — caller must be adventurer or giver
  const { data: relationship, error: relError } = await supabase
    .from("quest_givers")
    .select("*")
    .eq("id", id)
    .eq("status", "accepted")
    .or(`user_id.eq.${user.id},giver_user_id.eq.${user.id}`)
    .single();

  if (relError || !relationship) {
    return NextResponse.json({ error: "Relationship not found or not accepted" }, { status: 403 });
  }

  const isGiver = user.id === relationship.giver_user_id;

  const [templatesRes, acceptedQuestsRes, giverProfileRes, adventurerProfileRes] = await Promise.all([
    supabase
      .from("giver_quest_templates")
      .select("*")
      .eq("quest_giver_id", id)
      .order("sort_order")
      .order("created_at"),
    // Active quests the adventurer has subscribed to from this relationship
    supabase
      .from("quests")
      .select("*")
      .eq("user_id", relationship.user_id)
      .eq("quest_giver_relationship_id", id)
      .eq("status", "active"),
    // Giver profile
    supabase
      .from("profiles")
      .select("username, display_name")
      .eq("id", relationship.giver_user_id)
      .single(),
    // Adventurer profile
    supabase
      .from("profiles")
      .select("username, display_name")
      .eq("id", relationship.user_id)
      .single(),
  ]);

  // Map template_id → accepted quest_id for quick lookup
  const acceptedByTemplate: Record<string, string> = {};
  for (const q of acceptedQuestsRes.data ?? []) {
    const quest = q as { giver_template_id: string | null; id: string };
    if (quest.giver_template_id) acceptedByTemplate[quest.giver_template_id] = quest.id;
  }

  const templates = (templatesRes.data ?? []).map((t: Record<string, unknown>) => ({
    ...t,
    accepted_quest_id: acceptedByTemplate[t.id as string] ?? null,
  }));

  return NextResponse.json({
    relationship,
    is_giver: isGiver,
    giver_profile: giverProfileRes.data ?? null,
    adventurer_profile: adventurerProfileRes.data ?? null,
    templates,
    accepted_quests: acceptedQuestsRes.data ?? [],
  });
}

// POST /api/quest-givers/[id]/templates
// Subscribe/unsubscribe to a template (adventurer), or create/delete a template (giver).
export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  // Fetch and validate the relationship
  const { data: relationship, error: relError } = await supabase
    .from("quest_givers")
    .select("*")
    .eq("id", id)
    .eq("status", "accepted")
    .or(`user_id.eq.${user.id},giver_user_id.eq.${user.id}`)
    .single();

  if (relError || !relationship) {
    return NextResponse.json({ error: "Relationship not found or not accepted" }, { status: 403 });
  }

  const isGiver = user.id === relationship.giver_user_id;

  const body = await request.json().catch(() => null);
  const parsed = BodySchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 });
  }

  // --- Giver: create template ---
  if ("is_create" in parsed.data) {
    if (!isGiver) {
      return NextResponse.json({ error: "Only the quest giver can create templates" }, { status: 403 });
    }
    const { title, description, frequency, difficulty, sort_order } = parsed.data;
    const xpReward = XP_BY_DIFFICULTY[difficulty as QuestDifficulty];

    const { data, error } = await supabase
      .from("giver_quest_templates")
      .insert({
        quest_giver_id: id,
        title,
        description: description ?? null,
        frequency,
        difficulty,
        xp_reward: xpReward,
        sort_order: sort_order ?? 0,
      })
      .select()
      .single();

    if (error) return NextResponse.json({ error: error.message }, { status: 500 });
    return NextResponse.json({ template: data }, { status: 201 });
  }

  // --- Giver: delete template ---
  if ("is_delete" in parsed.data) {
    if (!isGiver) {
      return NextResponse.json({ error: "Only the quest giver can delete templates" }, { status: 403 });
    }
    const { template_id } = parsed.data;

    // Archive linked active quests so the adventurer isn't left with orphaned quests
    await supabase
      .from("quests")
      .update({ status: "archived" })
      .eq("user_id", relationship.user_id)
      .eq("quest_giver_relationship_id", id)
      .eq("giver_template_id", template_id)
      .eq("status", "active");

    const { error } = await supabase
      .from("giver_quest_templates")
      .delete()
      .eq("id", template_id)
      .eq("quest_giver_id", id);

    if (error) return NextResponse.json({ error: error.message }, { status: 500 });
    return NextResponse.json({ ok: true });
  }

  // --- Adventurer: accept or remove subscription ---
  if (isGiver) {
    return NextResponse.json({ error: "Quest givers cannot subscribe to their own templates" }, { status: 403 });
  }

  const { template_id, action } = parsed.data;

  if (action === "remove") {
    const { error } = await supabase
      .from("quests")
      .update({ status: "archived" })
      .eq("user_id", relationship.user_id)
      .eq("quest_giver_relationship_id", id)
      .eq("giver_template_id", template_id)
      .eq("status", "active");

    if (error) return NextResponse.json({ error: error.message }, { status: 500 });
    return NextResponse.json({ ok: true });
  }

  // Accept: look up template and create a quest instance
  const { data: template, error: tErr } = await supabase
    .from("giver_quest_templates")
    .select("*")
    .eq("id", template_id)
    .eq("quest_giver_id", id)
    .single();

  if (tErr || !template) {
    return NextResponse.json({ error: "Template not found" }, { status: 404 });
  }

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
      user_id: relationship.user_id,
      quest_giver_relationship_id: id,
      giver_template_id: template_id,
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
