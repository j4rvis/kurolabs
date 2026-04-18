import { createSupabaseServerClient } from "@/lib/supabase/server";
import QuestBoard from "@/components/quests/QuestBoard";

export default async function QuestsPage() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: quests } = await supabase
    .from("quests")
    .select("*, npc_quest_givers(name, image_filename)")
    .eq("user_id", user!.id)
    .eq("status", "active")
    .order("quest_type")
    .order("created_at", { ascending: false });

  return <QuestBoard quests={quests ?? []} />;
}
