"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

export default function CompleteQuestButton({ questId }: { questId: string }) {
  const [loading, setLoading] = useState(false);
  const [done, setDone] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();

  async function handleComplete() {
    setLoading(true);
    setError(null);
    const res = await fetch(`/api/quests/${questId}/complete`, {
      method: "POST",
    });
    if (res.ok) {
      setDone(true);
      setTimeout(() => {
        router.refresh();
      }, 800);
    } else {
      const data = await res.json().catch(() => ({}));
      setError(data.error ?? "Failed to complete quest");
      setLoading(false);
    }
  }

  if (done) {
    return (
      <span className="text-[11px] text-accent flex-shrink-0">✓</span>
    );
  }

  return (
    <div className="flex flex-col items-end gap-1">
      <button
        onClick={handleComplete}
        disabled={loading}
        className="flex-shrink-0 border border-paper-border text-ink-3 rounded-[2px] px-[10px] py-[4px] text-[10px] tracking-[.04em] transition-colors hover:border-accent hover:text-accent disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {loading ? "…" : "complete"}
      </button>
      {error && <span className="text-[10px] text-diff-deadly">{error}</span>}
    </div>
  );
}
