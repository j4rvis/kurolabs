import { NextResponse, type NextRequest } from "next/server";
import { authenticateRequest } from "@/lib/supabase/server";
import type { Character, XpThreshold } from "@/lib/types";

export async function GET(request: NextRequest) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const [characterResult, profileResult, thresholdsResult, recentResult] = await Promise.all([
    supabase.from("characters").select("*").eq("user_id", user.id).single(),
    supabase.from("profiles").select("*").eq("id", user.id).single(),
    supabase.from("xp_thresholds").select("*").order("level"),
    supabase
      .from("quest_completions")
      .select("*, quests(title, difficulty, epics(name, color_hex, ability_score))")
      .eq("user_id", user.id)
      .order("completed_at", { ascending: false })
      .limit(10),
  ]);

  if (characterResult.error) {
    return NextResponse.json({ error: characterResult.error.message }, { status: 500 });
  }

  const character = characterResult.data as unknown as Character;
  const thresholds = (thresholdsResult.data ?? []) as unknown as XpThreshold[];
  const currentThreshold = thresholds.find((t) => t.level === character.level);
  const nextThreshold = thresholds.find((t) => t.level === character.level + 1);

  return NextResponse.json({
    character,
    profile: profileResult.data,
    current_title: currentThreshold?.title,
    next_level_xp: nextThreshold?.xp_needed ?? null,
    recent_completions: recentResult.data ?? [],
  });
}

