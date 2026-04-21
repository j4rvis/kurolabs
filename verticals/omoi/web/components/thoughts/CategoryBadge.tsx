"use client";

import type { ThoughtCategory } from "../../lib/types";

const CATEGORY_STYLES: Record<ThoughtCategory, string> = {
  question: "bg-blue-900/40 text-blue-300 border-blue-700/50",
  reminder: "bg-amber-900/40 text-amber-300 border-amber-700/50",
  insight: "bg-emerald-900/40 text-emerald-300 border-emerald-700/50",
  idea: "bg-purple-900/40 text-purple-300 border-purple-700/50",
  other: "bg-zinc-800/40 text-zinc-400 border-zinc-700/50",
};

const CATEGORY_ICONS: Record<ThoughtCategory, string> = {
  question: "?",
  reminder: "⏰",
  insight: "✦",
  idea: "💡",
  other: "·",
};

export function CategoryBadge({ category }: { category: ThoughtCategory }) {
  return (
    <span
      className={`inline-flex items-center gap-1 px-2 py-0.5 rounded-full text-xs border ${CATEGORY_STYLES[category]}`}
    >
      <span>{CATEGORY_ICONS[category]}</span>
      {category}
    </span>
  );
}
