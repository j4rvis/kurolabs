"use client";

import { useState, useCallback } from "react";
import { useRouter } from "next/navigation";
import type { Thought, ThoughtStats } from "../../lib/types";
import { ThoughtList } from "./ThoughtList";

interface OmoiDashboardProps {
  initialThoughts: Thought[];
  initialTotal: number;
  initialStats: ThoughtStats;
}

export function OmoiDashboard({ initialThoughts, initialTotal, initialStats }: OmoiDashboardProps) {
  const router = useRouter();
  const [thoughts, setThoughts] = useState(initialThoughts);
  const [total, setTotal] = useState(initialTotal);
  const [stats, setStats] = useState(initialStats);
  const [page, setPage] = useState(1);
  const [content, setContent] = useState("");
  const [submitting, setSubmitting] = useState(false);
  const [tagFilter, setTagFilter] = useState<string | null>(null);
  const LIMIT = 20;

  const allTags = [...new Set(thoughts.flatMap((t) => t.tags))];

  const loadPage = useCallback(async (p: number, tag?: string | null) => {
    const params = new URLSearchParams({ page: String(p), limit: String(LIMIT) });
    const url = tag
      ? `/api/thoughts/search?tag=${encodeURIComponent(tag)}&limit=${LIMIT}`
      : `/api/thoughts?${params}`;
    const res = await fetch(url).catch(() => null);
    if (!res?.ok) return;
    const data = await res.json();
    setThoughts(data.thoughts ?? []);
    setTotal(data.total ?? 0);
    setPage(p);
  }, []);

  async function handleCapture() {
    if (!content.trim()) return;
    setSubmitting(true);
    const res = await fetch("/api/thoughts", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ content }),
    }).catch(() => null);
    setSubmitting(false);
    if (!res?.ok) return;
    setContent("");
    loadPage(1, tagFilter);
    const sr = await fetch("/api/thoughts/stats").catch(() => null);
    if (sr?.ok) setStats(await sr.json());
  }

  const toggleTag = (tag: string) => {
    const next = tagFilter === tag ? null : tag;
    setTagFilter(next);
    loadPage(1, next);
  };

  return (
    <div className="max-w-[760px] mx-auto px-6 py-8 flex flex-col gap-5">

      {/* Header */}
      <div className="flex items-end justify-between pb-5 mb-2 border-b border-paper-divider">
        <div>
          <div className="font-display text-[28px] text-omoi leading-none mb-1 opacity-25">想</div>
          <div className="text-ink-1 text-[18px] tracking-[.1em]">OMOI</div>
          <div className="text-ink-3 text-[10px] mt-1 tracking-[.06em]">inner knowledge base</div>
        </div>

        {/* Stats grid */}
        <div className="grid grid-cols-3 border border-paper-divider rounded-[2px] overflow-hidden divide-x divide-paper-divider">
          {[
            { label: "total",       value: stats.total },
            { label: "today",       value: stats.today },
            { label: "connections", value: stats.connections },
          ].map(({ label, value }) => (
            <div key={label} className="bg-paper-raised px-4 py-[10px] text-center">
              <div className="text-omoi text-[16px] tracking-[.02em]">{value}</div>
              <div className="text-ink-3 text-[9px] mt-[2px] tracking-[.08em]">{label}</div>
            </div>
          ))}
        </div>
      </div>

      {/* Capture */}
      <div>
        <textarea
          value={content}
          onChange={(e) => setContent(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter" && (e.metaKey || e.ctrlKey)) handleCapture();
          }}
          placeholder="What's on your mind? (⌘↵ to save)"
          className={`w-full h-[72px] bg-paper-raised border rounded-[4px] px-[14px] py-3 text-ink-1 text-[12px] tracking-[.02em] leading-[1.6] resize-none outline-none placeholder:text-ink-4 transition-colors caret-omoi ${
            content ? "border-omoi" : "border-paper-border"
          }`}
        />
        <div className="flex justify-end mt-2">
          <button
            onClick={handleCapture}
            disabled={submitting || !content.trim()}
            className={`border rounded-[2px] px-[18px] py-[7px] text-[10px] tracking-[.08em] transition-all ${
              content.trim() && !submitting
                ? "bg-omoi text-white border-omoi cursor-pointer"
                : "bg-paper-sunken text-ink-4 border-paper-divider cursor-default"
            }`}
          >
            {submitting ? "capturing…" : "capture"}
          </button>
        </div>
      </div>

      {/* Tag filter */}
      {allTags.length > 0 && (
        <div className="flex flex-wrap gap-[6px]">
          {allTags.slice(0, 10).map((tag) => (
            <button
              key={tag}
              onClick={() => toggleTag(tag)}
              className={`text-[10px] tracking-[.04em] border rounded-[2px] px-[7px] py-[2px] cursor-pointer transition-all ${
                tagFilter === tag
                  ? "bg-omoi-soft text-omoi border-omoi"
                  : "bg-paper-sunken text-ink-3 border-paper-divider"
              }`}
            >
              #{tag}
            </button>
          ))}
          {tagFilter && (
            <button
              onClick={() => { setTagFilter(null); loadPage(1, null); }}
              className="text-[10px] tracking-[.04em] text-ink-4 hover:text-ink-3 bg-transparent border-none cursor-pointer"
            >
              clear ×
            </button>
          )}
        </div>
      )}

      <ThoughtList
        thoughts={thoughts}
        total={total}
        page={page}
        limit={LIMIT}
        onPageChange={(p) => loadPage(p, tagFilter)}
        onThoughtClick={(id) => router.push(`/hub/omoi/thoughts/${id}`)}
        onTagFilter={(tag) => { setTagFilter(tag); loadPage(1, tag); }}
      />
    </div>
  );
}
