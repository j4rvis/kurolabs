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
          className={`flex-1 bg-paper-raised border rounded-[4px] px-4 py-2 text-ink-1 text-[12px] tracking-[.02em] outline-none placeholder:text-ink-4 transition-colors ${
            q ? "border-omoi" : "border-paper-border"
          }`}
        />
        <select
          value={category}
          onChange={(e) => setCategory(e.target.value as ThoughtCategory | "")}
          className="bg-paper-raised border border-paper-border rounded-[4px] px-3 py-2 text-ink-2 text-[11px] tracking-[.04em] outline-none focus:border-omoi"
        >
          <option value="">all categories</option>
          {CATEGORIES.map((c) => (
            <option key={c} value={c}>{c}</option>
          ))}
        </select>
      </div>

      {activeTag && (
        <div className="flex items-center gap-2">
          <span className="text-ink-3 text-[10px]">filtering by tag:</span>
          <TagChip tag={activeTag} active onClick={() => setActiveTag(null)} />
          <button
            onClick={() => setActiveTag(null)}
            className="text-ink-4 text-[10px] hover:text-ink-3"
          >
            clear ×
          </button>
        </div>
      )}

      {loading && <p className="text-ink-3 text-[11px]">searching…</p>}

      <div className="flex flex-col gap-2">
        {results.map((t) => (
          <div
            key={t.id}
            onClick={() => onResultClick(t.id)}
            className="bg-paper-raised border border-paper-divider hover:border-paper-border rounded-[4px] p-4 cursor-pointer transition-colors"
          >
            <p className="text-ink-2 text-[12px] leading-[1.7] tracking-[.02em] line-clamp-2">
              {t.content}
            </p>
            <div className="flex items-center gap-2 mt-2 flex-wrap">
              <CategoryBadge category={t.category} />
              {t.tags.slice(0, 3).map((tag) => (
                <TagChip key={tag} tag={tag} onClick={() => setActiveTag(tag)} />
              ))}
            </div>
          </div>
        ))}
        {results.length === 0 && (q || activeTag || category) && !loading && (
          <p className="text-ink-3 text-[11px] text-center py-6">No results.</p>
        )}
      </div>
    </div>
  );
}
