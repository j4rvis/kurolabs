"use client";

import type { ThoughtCategory } from "../../lib/types";

const CATEGORY_CLASSES: Record<ThoughtCategory, string> = {
  question: "bg-cat-question-bg text-cat-question-text border-cat-question-border",
  reminder: "bg-cat-reminder-bg text-cat-reminder-text border-cat-reminder-border",
  insight:  "bg-cat-insight-bg  text-cat-insight-text  border-cat-insight-border",
  idea:     "bg-cat-idea-bg     text-cat-idea-text     border-cat-idea-border",
  other:    "bg-cat-other-bg    text-cat-other-text    border-cat-other-border",
};

export function CategoryBadge({ category }: { category: ThoughtCategory }) {
  return (
    <span
      className={`inline-flex items-center px-[7px] py-[2px] rounded-[2px] text-[10px] tracking-[.04em] border ${CATEGORY_CLASSES[category] ?? CATEGORY_CLASSES.other}`}
    >
      {category}
    </span>
  );
}
