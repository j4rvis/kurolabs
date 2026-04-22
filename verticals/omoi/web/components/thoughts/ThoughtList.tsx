"use client";

import type { Thought } from "../../lib/types";
import { CategoryBadge } from "./CategoryBadge";
import { TagChip } from "./TagChip";

interface ThoughtListProps {
  thoughts: Thought[];
  total: number;
  page: number;
  limit: number;
  onPageChange: (page: number) => void;
  onThoughtClick: (id: string) => void;
  onTagFilter: (tag: string) => void;
}

function timeAgo(dateStr: string): string {
  const diff = Date.now() - new Date(dateStr).getTime();
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return "just now";
  if (mins < 60) return `${mins}m ago`;
  const hrs = Math.floor(mins / 60);
  if (hrs < 24) return `${hrs}h ago`;
  return `${Math.floor(hrs / 24)}d ago`;
}

function ThoughtCard({
  t,
  onThoughtClick,
  onTagFilter,
}: {
  t: Thought;
  onThoughtClick: (id: string) => void;
  onTagFilter: (tag: string) => void;
}) {
  return (
    <div
      onClick={() => onThoughtClick(t.id)}
      className="bg-paper-raised border border-paper-divider hover:border-paper-border rounded-[4px] p-[18px] cursor-pointer transition-colors"
    >
      <p className="text-ink-2 text-[12px] leading-[1.7] tracking-[.02em] line-clamp-3">
        {t.content}
      </p>
      <div className="flex items-center gap-[6px] mt-3 flex-wrap">
        <CategoryBadge category={t.category} />
        {t.tags.slice(0, 4).map((tag) => (
          <TagChip key={tag} tag={tag} onClick={() => onTagFilter(tag)} />
        ))}
        <span className="text-ink-4 text-[10px] ml-auto">{timeAgo(t.created_at)}</span>
      </div>
    </div>
  );
}

export function ThoughtList({
  thoughts,
  total,
  page,
  limit,
  onPageChange,
  onThoughtClick,
  onTagFilter,
}: ThoughtListProps) {
  const totalPages = Math.ceil(total / limit);

  if (thoughts.length === 0) {
    return (
      <div className="text-center py-12 text-ink-3 text-[11px]">
        No thoughts yet. Capture your first one above.
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-2">
      {thoughts.map((t) => (
        <ThoughtCard key={t.id} t={t} onThoughtClick={onThoughtClick} onTagFilter={onTagFilter} />
      ))}

      {totalPages > 1 && (
        <div className="flex justify-center gap-2 pt-2">
          <button
            disabled={page <= 1}
            onClick={() => onPageChange(page - 1)}
            className="px-3 py-1 rounded-[2px] text-[10px] tracking-[.06em] text-ink-3 hover:text-ink-2 disabled:opacity-30"
          >
            ← prev
          </button>
          <span className="text-ink-3 text-[10px] self-center">{page} / {totalPages}</span>
          <button
            disabled={page >= totalPages}
            onClick={() => onPageChange(page + 1)}
            className="px-3 py-1 rounded-[2px] text-[10px] tracking-[.06em] text-ink-3 hover:text-ink-2 disabled:opacity-30"
          >
            next →
          </button>
        </div>
      )}
    </div>
  );
}
