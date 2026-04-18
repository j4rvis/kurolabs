"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { DifficultyBadge, FrequencyBadge } from "@/components/ui/Badge";
import type { NpcQuestTemplate } from "@/lib/types";

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
    <div className="bg-tavern border border-tavern-border rounded-lg p-4 flex flex-col gap-3">
      <div className="flex items-start justify-between gap-3">
        <div className="flex-1 min-w-0">
          <h4 className="text-parchment text-sm font-medium leading-snug">
            {template.title}
          </h4>
          {template.description && (
            <p className="text-parchment-muted text-xs mt-1 leading-relaxed">
              {template.description}
            </p>
          )}
        </div>
        <button
          onClick={handleToggle}
          disabled={loading}
          className={`text-xs font-semibold px-3 py-1.5 rounded transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex-shrink-0 ${
            isAccepted
              ? "border border-tavern-border text-parchment-muted hover:border-red-700 hover:text-red-400"
              : "bg-gold text-tavern hover:bg-gold-light"
          }`}
        >
          {loading ? "…" : isAccepted ? "Remove" : "Accept"}
        </button>
      </div>

      <div className="flex items-center gap-2 flex-wrap">
        <FrequencyBadge frequency={template.frequency} />
        <DifficultyBadge difficulty={template.difficulty} />
        <span className="text-gold text-xs font-medium ml-auto">
          {template.xp_reward} XP
        </span>
      </div>

      {error && <p className="text-red-400 text-xs">{error}</p>}
    </div>
  );
}
