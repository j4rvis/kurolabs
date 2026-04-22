"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { DifficultyBadge, FrequencyBadge } from "../ui/Badge";
import type { NpcQuestTemplate } from "../../lib/types";

type TemplateWithStatus = NpcQuestTemplate & {
  accepted_quest_id: string | null;
};

export default function TemplateRow({
  template,
  npcId,
}: {
  template: TemplateWithStatus;
  npcId: string;
}) {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();
  const isAccepted = template.accepted_quest_id !== null;

  async function handleToggle() {
    setLoading(true);
    setError(null);
    const res = await fetch(`/api/village/${npcId}/quests`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(
        isAccepted
          ? { action: "remove", template_id: template.id }
          : { action: "accept", template_id: template.id }
      ),
    });
    if (res.ok) {
      router.refresh();
    } else {
      const data = await res.json().catch(() => ({}));
      setError(data.error ?? "Something went wrong");
      setLoading(false);
    }
  }

  return (
    <div className="bg-paper-raised border border-paper-border rounded-[4px] p-[20px] flex flex-col gap-3">
      <div className="flex items-start justify-between gap-3">
        <div className="flex-1 min-w-0">
          <h4 className="text-ink-1 text-[12px] tracking-[.03em] leading-snug">
            {template.title}
          </h4>
          {template.description && (
            <p className="text-ink-3 text-[10px] mt-1 leading-relaxed">
              {template.description}
            </p>
          )}
        </div>
        <button
          onClick={handleToggle}
          disabled={loading}
          className={`text-[10px] tracking-[.06em] px-[10px] py-[4px] rounded-[2px] border transition-all disabled:opacity-50 disabled:cursor-not-allowed flex-shrink-0 ${
            isAccepted
              ? "bg-paper-sunken text-ink-3 border-paper-divider hover:border-diff-deadly hover:text-diff-deadly"
              : "bg-transparent text-accent border-accent hover:opacity-70"
          }`}
        >
          {loading ? "…" : isAccepted ? "Remove" : "Accept"}
        </button>
      </div>

      <div className="flex items-center gap-[6px] flex-wrap">
        <FrequencyBadge frequency={template.frequency} />
        <DifficultyBadge difficulty={template.difficulty} />
        <span className="text-accent text-[10px] tracking-[.06em] ml-auto">
          {template.xp_reward} xp
        </span>
      </div>

      {error && <p className="text-diff-deadly text-[10px]">{error}</p>}
    </div>
  );
}
