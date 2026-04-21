"use client";

import { useState } from "react";
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
      <div className="text-center py-12 text-zinc-500 text-sm">
        No thoughts yet. Capture your first one above.
      </div>
    );
  }

  return (
    <div className="flex flex-col gap-2">
      {thoughts.map((t) => (
        <div
          key={t.id}
          onClick={() => onThoughtClick(t.id)}
          className="bg-zinc-900 border border-zinc-800 rounded-lg p-4 cursor-pointer hover:border-zinc-700 transition-colors"
        >
          <p className="text-zinc-200 text-sm leading-relaxed line-clamp-3">{t.content}</p>
          <div className="flex items-center gap-2 mt-3 flex-wrap">
            <CategoryBadge category={t.category} />
            {t.tags.slice(0, 4).map((tag) => (
              <TagChip
                key={tag}
                tag={tag}
                onClick={() => onTagFilter(tag)}
              />
            ))}
            <span className="text-zinc-600 text-xs ml-auto">{timeAgo(t.created_at)}</span>
          </div>
        </div>
      ))}

      {totalPages > 1 && (
        <div className="flex justify-center gap-2 pt-2">
          <button
            disabled={page <= 1}
            onClick={() => onPageChange(page - 1)}
            className="px-3 py-1 rounded text-sm text-zinc-400 disabled:opacity-30 hover:bg-zinc-800"
          >
            ← prev
          </button>
          <span className="text-zinc-500 text-sm self-center">
            {page} / {totalPages}
          </span>
          <button
            disabled={page >= totalPages}
            onClick={() => onPageChange(page + 1)}
            className="px-3 py-1 rounded text-sm text-zinc-400 disabled:opacity-30 hover:bg-zinc-800"
          >
            next →
          </button>
        </div>
      )}
    </div>
  );
}
