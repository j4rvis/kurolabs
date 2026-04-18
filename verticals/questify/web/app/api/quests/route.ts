import { NextResponse, type NextRequest } from "next/server";
import { z } from "zod";
import { authenticateRequest } from "@/lib/supabase/server";
import { XP_BY_DIFFICULTY, type QuestDifficulty } from "@/lib/types";

const CreateQuestSchema = z.object({
  title: z.string().min(1).max(200),
  description: z.string().max(2000).optional(),
  quest_type: z.enum(["daily", "side", "epic"]),
  difficulty: z.enum(["trivial", "easy", "medium", "hard", "deadly", "legendary"]),
  epic_id: z.string().uuid().optional(),
  quest_giver_id: z.string().uuid().optional(),
  due_date: z.string().date().optional(),
  recurrence_rule: z.string().optional(),
});

export async function GET(request: NextRequest) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { searchParams } = new URL(request.url);
  const type = searchParams.get("type");
  const status = searchParams.get("status") ?? "active";

  let query = supabase
    .from("quests")
    .select("*, epics(*)")
    .eq("user_id", user.id)
    .order("created_at", { ascending: false });

  if (type) query = query.eq("quest_type", type);
  if (status !== "all") query = query.eq("status", status);

  const { data, error } = await query;
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ quests: data });
}

export async function POST(request: NextRequest) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const body = await request.json().catch(() => null);
  const parsed = CreateQuestSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 });
  }

  const { difficulty, ...rest } = parsed.data;
  const xp_reward = XP_BY_DIFFICULTY[difficulty as QuestDifficulty];

  const { data, error } = await supabase
    .from("quests")
    .insert({ ...rest, difficulty, xp_reward, user_id: user.id })
    .select()
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ quest: data }, { status: 201 });
}
