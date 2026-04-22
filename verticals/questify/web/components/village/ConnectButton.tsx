"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

export default function ConnectButton({
  npcId,
  isConnected,
}: {
  npcId: string;
  isConnected: boolean;
}) {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const router = useRouter();

  async function handleToggle() {
    setLoading(true);
    setError(null);
    const res = await fetch(`/api/village/${npcId}/connect`, {
      method: isConnected ? "DELETE" : "POST",
    });
    if (res.ok) {
      router.refresh();
    } else {
      const data = await res.json().catch(() => ({}));
      setError(data.error ?? "Something went wrong");
      setLoading(false);
    }
  }

  return (
    <div className="flex flex-col items-start gap-1">
      <button
        onClick={handleToggle}
        disabled={loading}
        className={`text-[10px] tracking-[.06em] px-[18px] py-[7px] rounded-[2px] border transition-all disabled:opacity-50 disabled:cursor-not-allowed ${
          isConnected
            ? "bg-paper-sunken text-ink-3 border-paper-divider hover:border-diff-deadly hover:text-diff-deadly"
            : "bg-transparent text-accent border-accent hover:opacity-70"
        }`}
      >
        {loading ? "…" : isConnected ? "connected ✓" : "connect"}
      </button>
      {error && <p className="text-diff-deadly text-[10px]">{error}</p>}
    </div>
  );
}
