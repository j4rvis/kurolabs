"use client";

import { useState, useEffect, useCallback } from "react";
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
    // Refresh stats
    const sr = await fetch("/api/thoughts/stats").catch(() => null);
    if (sr?.ok) setStats(await sr.json());
  }

  return (
    <div className="flex flex-col gap-6">
      {/* Stats bar */}
      <div className="grid grid-cols-3 gap-3">
        {[
          { label: "Total", value: stats.total },
          { label: "Today", value: stats.today },
          { label: "Connections", value: stats.connections },
        ].map(({ label, value }) => (
          <div key={label} className="bg-zinc-900 border border-zinc-800 rounded-lg p-4 text-center">
            <div className="text-2xl font-bold text-violet-400">{value}</div>
            <div className="text-xs text-zinc-500 mt-1">{label}</div>
          </div>
        ))}
      </div>

      {/* Quick capture */}
      <div className="bg-zinc-900 border border-zinc-800 rounded-lg p-4 flex flex-col gap-3">
        <textarea
          value={content}
          onChange={(e) => setContent(e.target.value)}
          onKeyDown={(e) => {
            if (e.key === "Enter" && (e.metaKey || e.ctrlKey)) handleCapture();
          }}
          placeholder="What's on your mind? (⌘↵ to save)"
          className="w-full h-24 bg-zinc-800 border border-zinc-700 rounded p-3 text-zinc-200 text-sm resize-none focus:outline-none focus:border-violet-500 placeholder:text-zinc-600"
        />
        <button
          onClick={handleCapture}
          disabled={submitting || !content.trim()}
          className="self-end px-4 py-2 bg-violet-600 hover:bg-violet-700 disabled:opacity-40 rounded text-sm text-white font-medium"
        >
          {submitting ? "Capturing…" : "Capture thought"}
        </button>
      </div>

      {/* Top tags */}
      {stats.top_tags.length > 0 && (
        <div className="flex flex-wrap gap-2">
          {stats.top_tags.map(({ tag, count }) => (
            <button
              key={tag}
              onClick={() => {
                const next = tagFilter === tag ? null : tag;
                setTagFilter(next);
                loadPage(1, next);
              }}
              className={`px-2 py-1 rounded text-xs font-mono transition-colors ${
                tagFilter === tag
                  ? "bg-violet-600 text-white"
                  : "bg-zinc-800 text-zinc-400 hover:bg-zinc-700"
              }`}
            >
              #{tag} <span className="opacity-60">{count}</span>
            </button>
          ))}
          {tagFilter && (
            <button
              onClick={() => { setTagFilter(null); loadPage(1, null); }}
              className="text-xs text-zinc-600 hover:text-zinc-400 self-center"
            >
              clear filter
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
