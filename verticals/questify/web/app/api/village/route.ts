import { NextResponse, type NextRequest } from "next/server";
import { authenticateRequest } from "@/lib/supabase/server";

// GET /api/village
// Returns all NPC quest givers with connection status and accepted quest count for the user.
export async function GET(request: NextRequest) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  // Fetch all NPCs
  const { data: npcs, error: npcError } = await supabase
    .from("npc_quest_givers")
    .select("*")
    .order("sort_order", { ascending: true });

  if (npcError) return NextResponse.json({ error: npcError.message }, { status: 500 });

  // Fetch user's connections
  const { data: connections } = await supabase
    .from("user_npc_connections")
    .select("npc_id")
    .eq("user_id", user.id);

  const connectedIds = new Set((connections ?? []).map((c: { npc_id: string }) => c.npc_id));

  // Count accepted quests per NPC for this user
  const { data: questCounts } = await supabase
    .from("quests")
    .select("npc_quest_giver_id")
    .eq("user_id", user.id)
    .eq("status", "active")
    .not("npc_quest_giver_id", "is", null);

  const countMap: Record<string, number> = {};
  for (const q of questCounts ?? []) {
    const id = (q as { npc_quest_giver_id: string }).npc_quest_giver_id;
    countMap[id] = (countMap[id] ?? 0) + 1;
  }

  const enriched = (npcs ?? []).map((npc: Record<string, unknown>) => ({
    ...npc,
    is_connected: connectedIds.has(npc.id as string),
    accepted_quest_count: countMap[npc.id as string] ?? 0,
  }));

  // Sort: highest quest count first, then connected before unconnected
  enriched.sort((a, b) => {
    if (b.accepted_quest_count !== a.accepted_quest_count) {
      return (b.accepted_quest_count as number) - (a.accepted_quest_count as number);
    }
    if (a.is_connected !== b.is_connected) return a.is_connected ? -1 : 1;
    return ((a as Record<string, unknown>).sort_order as number) - ((b as Record<string, unknown>).sort_order as number);
  });

  return NextResponse.json({ npcs: enriched });
}
