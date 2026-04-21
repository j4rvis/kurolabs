"use client";

import { useState, useEffect } from "react";
import { useRouter } from "next/navigation";
import { ThoughtDetail } from "@omoi/web/components/thoughts/ThoughtDetail";
import type { Thought } from "@omoi/web/lib/types";

export default function ThoughtDetailPage({ params }: { params: Promise<{ id: string }> }) {
  const router = useRouter();
  const [thought, setThought] = useState<Thought | null>(null);
  const [connections, setConnections] = useState<Thought[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    params.then(({ id }) => {
      fetch(`/api/thoughts/${id}`)
        .then((r) => r.json())
        .then((data) => {
          setThought(data.thought);
          setConnections(data.connections ?? []);
          setLoading(false);
        })
        .catch(() => setLoading(false));
    });
  }, [params]);

  async function handleEdit(id: string, content: string) {
    const res = await fetch(`/api/thoughts/${id}`, {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ content }),
    });
    if (res.ok) {
      const data = await res.json();
      setThought(data.thought);
    }
  }

  async function handleDelete(id: string) {
    await fetch(`/api/thoughts/${id}`, { method: "DELETE" });
    router.push("/hub/omoi/dashboard");
  }

  if (loading) {
    return <div className="text-zinc-500 text-sm py-12 text-center">Loading…</div>;
  }

  if (!thought) {
    return <div className="text-zinc-500 text-sm py-12 text-center">Thought not found.</div>;
  }

  return (
    <ThoughtDetail
      thought={thought}
      connections={connections}
      onEdit={handleEdit}
      onDelete={handleDelete}
      onConnectionClick={(id) => router.push(`/hub/omoi/thoughts/${id}`)}
    />
  );
}
