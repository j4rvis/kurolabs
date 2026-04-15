"use client";

import { useState } from "react";
import type { Quest, QuestType } from "@/lib/types";
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
      <div className="flex items-center justify-between mb-6">
        <h1 className="font-display text-2xl text-gold tracking-wide">
          Quest Board
        </h1>
        <span className="text-parchment-muted text-sm">
          {filtered.length} active quest{filtered.length !== 1 ? "s" : ""}
        </span>
      </div>

      {/* Filter tabs */}
      <div className="flex gap-1 mb-6 border-b border-tavern-border pb-3">
        {filters.map((f) => {
          const count =
            f.value === "all"
              ? quests.length
              : quests.filter((q) => q.quest_type === f.value).length;
          return (
            <button
              key={f.value}
              onClick={() => setActiveFilter(f.value)}
              className={`px-3 py-1.5 rounded text-sm transition-colors flex items-center gap-1.5 ${
                activeFilter === f.value
                  ? "bg-tavern-mid text-gold"
                  : "text-parchment-muted hover:text-parchment hover:bg-tavern-mid"
              }`}
            >
              {f.label}
              <span className="text-xs opacity-70">({count})</span>
            </button>
          );
        })}
      </div>

      {filtered.length === 0 ? (
        <div className="text-center py-20">
          <p className="text-parchment-muted text-lg mb-2">No quests found</p>
          <p className="text-parchment-muted text-sm">
            Visit the{" "}
            <a href="/dashboard/village" className="text-gold hover:text-gold-light transition-colors">
              Village
            </a>{" "}
            to accept quests from NPCs.
          </p>
        </div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {filtered.map((quest) => (
            <QuestCard key={quest.id} quest={quest} />
          ))}
        </div>
      )}
    </div>
  );
}
