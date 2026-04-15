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
      <span className="text-xs text-[#52be80] font-medium px-3 py-1.5">
        ✓ Completed!
      </span>
    );
  }

  return (
    <div className="flex flex-col items-end gap-1">
      <button
        onClick={handleComplete}
        disabled={loading}
        className="text-xs bg-gold text-tavern font-semibold px-3 py-1.5 rounded hover:bg-gold-light transition-colors disabled:opacity-50 disabled:cursor-not-allowed"
      >
        {loading ? "…" : "Complete"}
      </button>
      {error && <span className="text-xs text-red-400">{error}</span>}
    </div>
  );
}
