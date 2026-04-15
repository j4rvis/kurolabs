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
        className={`text-sm font-semibold px-4 py-2 rounded transition-colors disabled:opacity-50 disabled:cursor-not-allowed ${
          isConnected
            ? "border border-tavern-border text-parchment-muted hover:border-red-700 hover:text-red-400"
            : "bg-gold text-tavern hover:bg-gold-light"
        }`}
      >
        {loading ? "…" : isConnected ? "Disconnect" : "Connect"}
      </button>
      {error && <p className="text-red-400 text-xs">{error}</p>}
    </div>
  );
}
