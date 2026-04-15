"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

export default function LoginPage() {
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const router = useRouter();
  const supabase = createSupabaseBrowserClient();

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setError(null);
    setLoading(true);
    const fd = new FormData(e.currentTarget);
    const { error } = await supabase.auth.signInWithPassword({
      email: fd.get("email") as string,
      password: fd.get("password") as string,
    });
    if (error) {
      setError(error.message);
      setLoading(false);
    } else {
      router.push("/dashboard/quests");
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-tavern px-4">
      <div className="w-full max-w-sm">
        <div className="text-center mb-8">
          <h1 className="font-display text-4xl text-gold tracking-widest mb-2">
            QUESTIFY
          </h1>
          <p className="text-parchment-muted text-sm">Your adventure awaits</p>
        </div>

        <div className="bg-tavern-light border border-tavern-border rounded-lg p-8">
          <h2 className="font-display text-lg text-parchment mb-6 tracking-wide">
            Enter the Tavern
          </h2>

          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-parchment-muted text-xs uppercase tracking-widest mb-1.5">
                Email
              </label>
              <input
                name="email"
                type="email"
                required
                autoComplete="email"
                className="w-full bg-tavern border border-tavern-border text-parchment px-3 py-2.5 rounded focus:outline-none focus:border-gold placeholder-ink-muted text-sm"
                placeholder="adventurer@realm.com"
              />
            </div>

            <div>
              <label className="block text-parchment-muted text-xs uppercase tracking-widest mb-1.5">
                Password
              </label>
              <input
                name="password"
                type="password"
                required
                autoComplete="current-password"
                className="w-full bg-tavern border border-tavern-border text-parchment px-3 py-2.5 rounded focus:outline-none focus:border-gold placeholder-ink-muted text-sm"
                placeholder="••••••••"
              />
            </div>

            {error && (
              <p className="text-red-400 text-sm border border-red-900 bg-red-950/30 rounded px-3 py-2">
                {error}
              </p>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-gold text-tavern font-semibold py-2.5 rounded hover:bg-gold-light transition-colors disabled:opacity-50 disabled:cursor-not-allowed font-display tracking-wider text-sm mt-2"
            >
              {loading ? "Entering…" : "Begin Quest"}
            </button>
          </form>

          <p className="text-center text-parchment-muted text-sm mt-6">
            No account?{" "}
            <Link
              href="/auth/signup"
              className="text-gold hover:text-gold-light transition-colors"
            >
              Create one
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
}
