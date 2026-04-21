import { NextResponse, type NextRequest } from "next/server";
import { authenticateRequest } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);

  const [totalResult, todayResult, connectionsResult, allTagsResult] = await Promise.all([
    supabase
      .from("thoughts")
      .select("id", { count: "exact", head: true })
      .eq("user_id", user.id),
    supabase
      .from("thoughts")
      .select("id", { count: "exact", head: true })
      .eq("user_id", user.id)
      .gte("created_at", todayStart.toISOString()),
    supabase
      .from("thought_connections")
      .select("thought_id_a", { count: "exact", head: true }),
    supabase.from("thoughts").select("tags").eq("user_id", user.id),
  ]);

  const tagCounts: Record<string, number> = {};
  for (const row of allTagsResult.data ?? []) {
    for (const tag of row.tags ?? []) {
      tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
    }
  }
  const topTags = Object.entries(tagCounts)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 10)
    .map(([tag, count]) => ({ tag, count }));

  return NextResponse.json({
    total: totalResult.count ?? 0,
    today: todayResult.count ?? 0,
    connections: connectionsResult.count ?? 0,
    top_tags: topTags,
  });
}
