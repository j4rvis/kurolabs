"use client";

import { useState, useEffect, useCallback } from "react";
import type { Thought, ThoughtCategory } from "../../lib/types";
import { CategoryBadge } from "./CategoryBadge";
import { TagChip } from "./TagChip";

const CATEGORIES: ThoughtCategory[] = ["question", "reminder", "insight", "idea", "other"];

interface ThoughtSearchProps {
  onResultClick: (id: string) => void;
}

export function ThoughtSearch({ onResultClick }: ThoughtSearchProps) {
  const [q, setQ] = useState("");
  const [activeTag, setActiveTag] = useState<string | null>(null);
  const [category, setCategory] = useState<ThoughtCategory | "">("");
  const [results, setResults] = useState<Thought[]>([]);
  const [loading, setLoading] = useState(false);

  const search = useCallback(async () => {
    const params = new URLSearchParams();
    if (q) params.set("q", q);
    if (activeTag) params.set("tag", activeTag);
    if (category) params.set("category", category);

    if (!q && !activeTag && !category) {
      setResults([]);
      return;
    }

    setLoading(true);
    const res = await fetch(`/api/thoughts/search?${params}`).catch(() => null);
    setLoading(false);
    if (!res?.ok) return;
    const data = await res.json();
    setResults(data.thoughts ?? []);
  }, [q, activeTag, category]);

  // Debounce text search
  useEffect(() => {
    const timer = setTimeout(search, 300);
    return () => clearTimeout(timer);
  }, [search]);

  return (
    <div className="flex flex-col gap-4">
      <div className="flex gap-2">
        <input
          type="text"
          value={q}
          onChange={(e) => setQ(e.target.value)}
          placeholder="Search thoughts…"
          className="flex-1 bg-zinc-900 border border-zinc-700 rounded-lg px-4 py-2 text-sm text-zinc-200 placeholder:text-zinc-600 focus:outline-none focus:border-violet-500"
        />
        <select
          value={category}
          onChange={(e) => setCategory(e.target.value as ThoughtCategory | "")}
          className="bg-zinc-900 border border-zinc-700 rounded-lg px-3 py-2 text-sm text-zinc-300 focus:outline-none focus:border-violet-500"
        >
          <option value="">All categories</option>
          {CATEGORIES.map((c) => (
            <option key={c} value={c}>{c}</option>
          ))}
        </select>
      </div>

      {activeTag && (
        <div className="flex items-center gap-2 text-sm text-zinc-400">
          Filtering by tag:
          <TagChip tag={activeTag} active onClick={() => setActiveTag(null)} />
          <button onClick={() => setActiveTag(null)} className="text-xs text-zinc-600 hover:text-zinc-400">
            clear
          </button>
        </div>
      )}

      {loading && <p className="text-zinc-500 text-sm">Searching…</p>}

      <div className="flex flex-col gap-2">
        {results.map((t) => (
          <div
            key={t.id}
            onClick={() => onResultClick(t.id)}
            className="bg-zinc-900 border border-zinc-800 rounded-lg p-4 cursor-pointer hover:border-zinc-700 transition-colors"
          >
            <p className="text-zinc-200 text-sm leading-relaxed line-clamp-2">{t.content}</p>
            <div className="flex items-center gap-2 mt-2 flex-wrap">
              <CategoryBadge category={t.category} />
              {t.tags.slice(0, 3).map((tag) => (
                <TagChip key={tag} tag={tag} onClick={() => setActiveTag(tag)} />
              ))}
            </div>
          </div>
        ))}
        {results.length === 0 && (q || activeTag || category) && !loading && (
          <p className="text-zinc-500 text-sm text-center py-6">No results.</p>
        )}
      </div>
    </div>
  );
}
