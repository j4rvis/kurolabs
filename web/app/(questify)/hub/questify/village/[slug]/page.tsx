import { notFound } from "next/navigation";
import Image from "next/image";
import Link from "next/link";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import ConnectButton from "@questify/web/components/village/ConnectButton";
import TemplateRow from "@questify/web/components/village/TemplateRow";
import type { NpcQuestTemplate } from "@/lib/types";

type TemplateWithStatus = NpcQuestTemplate & {
  accepted_quest_id: string | null;
};

export default async function NpcDetailPage({
  params,
}: {
  params: Promise<{ slug: string }>;
}) {
  const { slug } = await params;
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: npc } = await supabase
    .from("npc_quest_givers")
    .select("*")
    .eq("slug", slug)
    .single();

  if (!npc) notFound();

  const [templatesRes, userQuestsRes, connectionRes] = await Promise.all([
    supabase
      .from("npc_quest_templates")
      .select("*")
      .eq("npc_id", npc.id)
      .order("sort_order"),
    supabase
      .from("quests")
      .select("*")
      .eq("user_id", user!.id)
      .eq("npc_quest_giver_id", npc.id)
      .eq("status", "active"),
    supabase
      .from("user_npc_connections")
      .select("id")
      .eq("user_id", user!.id)
      .eq("npc_id", npc.id)
      .maybeSingle(),
  ]);

  const acceptedByTemplate: Record<string, string> = {};
  for (const q of userQuestsRes.data ?? []) {
    const quest = q as { npc_template_id: string | null; id: string };
    if (quest.npc_template_id) {
      acceptedByTemplate[quest.npc_template_id] = quest.id;
    }
  }

  const templates: TemplateWithStatus[] = (templatesRes.data ?? []).map(
    (t) => ({
      ...t,
      accepted_quest_id: acceptedByTemplate[t.id] ?? null,
    })
  );

  const isConnected = connectionRes.data !== null;

  return (
    <div className="max-w-2xl">
      {/* Back link */}
      <Link
        href="/hub/questify/village"
        className="text-ink-3 hover:text-ink-2 text-[10px] tracking-[.06em] transition-colors mb-6 inline-flex items-center gap-1"
      >
        ← Village
      </Link>

      {/* NPC header */}
      <div className="bg-paper-raised border border-paper-border rounded-[4px] mb-6 overflow-hidden flex gap-5 items-start">
        <div className="relative w-[120px] h-[120px] flex-shrink-0 bg-paper-sunken overflow-hidden">
          <Image
            src={`/images/npc/${npc.image_filename}`}
            alt={npc.name}
            fill
            className="object-cover object-top"
            unoptimized
          />
        </div>
        <div className="flex-1 min-w-0 p-5 pl-0">
          <div className="flex items-start justify-between gap-4">
            <div>
              <h1 className="text-ink-1 text-[15px] tracking-[.06em]">
                {npc.name}
              </h1>
              <p className="text-accent text-[10px] tracking-[.04em] mt-0.5">{npc.title}</p>
              <p className="text-ink-3 text-[10px] mt-0.5 tracking-[.04em]">
                {npc.category}
              </p>
            </div>
            <ConnectButton npcId={npc.id} isConnected={isConnected} />
          </div>
          {npc.description && (
            <p className="text-ink-3 text-[11px] mt-3 leading-relaxed">
              {npc.description}
            </p>
          )}
        </div>
      </div>

      {/* Quest templates */}
      <div>
        <h2 className="text-ink-3 text-[9px] tracking-[.1em] uppercase mb-4">
          Available Quests
        </h2>
        <div className="flex flex-col gap-3">
          {templates.map((template) => (
            <TemplateRow
              key={template.id}
              template={template}
              npcId={npc.id}
            />
          ))}
        </div>
      </div>
    </div>
  );
}
