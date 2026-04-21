import { createSupabaseServerClient } from "@/lib/supabase/server";
import { OmoiDashboard } from "@omoi/web/components/thoughts/OmoiDashboard";

export default async function OmoiDashboardPage() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const [thoughtsResult, statsResult] = await Promise.all([
    supabase
      .from("thoughts")
      .select("*", { count: "exact" })
      .eq("user_id", user!.id)
      .order("created_at", { ascending: false })
      .range(0, 19),
    supabase
      .from("thoughts")
      .select("tags")
      .eq("user_id", user!.id),
  ]);

  const todayStart = new Date();
  todayStart.setHours(0, 0, 0, 0);
  const { count: todayCount } = await supabase
    .from("thoughts")
    .select("id", { count: "exact", head: true })
    .eq("user_id", user!.id)
    .gte("created_at", todayStart.toISOString());

  const { count: connectionsCount } = await supabase
    .from("thought_connections")
    .select("thought_id_a", { count: "exact", head: true });

  const tagCounts: Record<string, number> = {};
  for (const row of statsResult.data ?? []) {
    for (const tag of row.tags ?? []) {
      tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
    }
  }
  const topTags = Object.entries(tagCounts)
    .sort((a, b) => b[1] - a[1])
    .slice(0, 10)
    .map(([tag, count]) => ({ tag, count }));

  return (
    <OmoiDashboard
      initialThoughts={thoughtsResult.data ?? []}
      initialTotal={thoughtsResult.count ?? 0}
      initialStats={{
        total: thoughtsResult.count ?? 0,
        today: todayCount ?? 0,
        connections: connectionsCount ?? 0,
        top_tags: topTags,
      }}
    />
  );
}
