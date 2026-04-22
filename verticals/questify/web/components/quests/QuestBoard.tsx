"use client";

import { useState } from "react";
import type { Quest, QuestType } from "../../lib/types";
import QuestCard from "./QuestCard";

type QuestWithNpc = Quest & {
  npc_quest_givers?: { name: string; image_filename: string } | null;
};

const filters: { label: string; value: QuestType | "all" }[] = [
  { label: "All", value: "all" },
  { label: "Daily", value: "daily" },
  { label: "Side Quests", value: "side" },
  { label: "Epic", value: "epic" },
];

export default function QuestBoard({ quests }: { quests: QuestWithNpc[] }) {
  const [activeFilter, setActiveFilter] = useState<QuestType | "all">("all");

  const filtered =
    activeFilter === "all"
      ? quests
      : quests.filter((q) => q.quest_type === activeFilter);

  return (
    <div>
      <div className="flex items-baseline justify-between mb-6">
        <h1 className="text-ink-1 text-[16px] tracking-[.12em]">Quest Board</h1>
        <span className="text-ink-3 text-[10px]">
          {filtered.length} active
        </span>
      </div>

      {/* Filter tabs */}
      <div className="flex gap-[2px] mb-6 border-b border-paper-divider pb-3">
        {filters.map((f) => {
          const active = activeFilter === f.value;
          return (
            <button
              key={f.value}
              onClick={() => setActiveFilter(f.value)}
              className={`rounded-[2px] px-[14px] py-[5px] text-[10px] tracking-[.06em] transition-all border ${
                active
                  ? "bg-accent-soft text-accent border-accent"
                  : "bg-transparent text-ink-3 border-transparent hover:text-ink-2"
              }`}
            >
              {f.label}
            </button>
          );
        })}
      </div>

      {filtered.length === 0 ? (
        <div className="text-center py-20">
          <p className="text-ink-3 text-[11px] mb-2">No quests found</p>
          <p className="text-ink-3 text-[10px]">
            Visit the{" "}
            <a href="/hub/questify/village" className="text-accent hover:opacity-70 transition-opacity">
              Village
            </a>{" "}
            to accept quests from NPCs.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-[14px]">
          {filtered.map((quest) => (
            <QuestCard key={quest.id} quest={quest} />
          ))}
        </div>
      )}
    </div>
  );
}
