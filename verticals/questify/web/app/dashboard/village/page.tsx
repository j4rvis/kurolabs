import { createSupabaseServerClient } from "@/lib/supabase/server";
import NpcCard from "@/components/village/NpcCard";
import type { NpcQuestGiver } from "@/lib/types";

type NpcWithConnection = NpcQuestGiver & { is_connected: boolean };

export default async function VillagePage() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const [npcsRes, connectionsRes] = await Promise.all([
    supabase.from("npc_quest_givers").select("*").order("sort_order"),
    supabase
      .from("user_npc_connections")
      .select("npc_id")
      .eq("user_id", user!.id),
  ]);

  const connectedIds = new Set(
    (connectionsRes.data ?? []).map((c) => c.npc_id)
  );

  const npcs: NpcWithConnection[] = (npcsRes.data ?? []).map((npc) => ({
    ...npc,
    is_connected: connectedIds.has(npc.id),
  }));

  const connected = npcs.filter((n) => n.is_connected);
  const unconnected = npcs.filter((n) => !n.is_connected);

  return (
    <div>
      <div className="mb-8">
        <h1 className="font-display text-2xl text-gold tracking-wide mb-1">
          The Village
        </h1>
        <p className="text-parchment-muted text-sm">
          Meet the villagers and accept their quests
        </p>
      </div>

      {connected.length > 0 && (
        <section className="mb-10">
          <h2 className="font-display text-sm text-parchment-muted tracking-widest uppercase mb-4">
            Your Quest Givers
          </h2>
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
            {connected.map((npc) => (
              <NpcCard key={npc.id} npc={npc} />
            ))}
          </div>
        </section>
      )}

      <section>
        <h2 className="font-display text-sm text-parchment-muted tracking-widest uppercase mb-4">
          {connected.length > 0 ? "Other Villagers" : "All Villagers"}
        </h2>
        <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
          {unconnected.map((npc) => (
            <NpcCard key={npc.id} npc={npc} />
          ))}
        </div>
      </section>
    </div>
  );
}
