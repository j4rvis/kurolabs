"use client";

import { useState } from "react";
import Link from "next/link";
import { createSupabaseBrowserClient } from "@/lib/supabase/client";

export default function SignupPage() {
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);
  const [loading, setLoading] = useState(false);
  const supabase = createSupabaseBrowserClient();

  async function handleSubmit(e: React.FormEvent<HTMLFormElement>) {
    e.preventDefault();
    setError(null);
    setLoading(true);
    const fd = new FormData(e.currentTarget);
    const email = fd.get("email") as string;
    const { data, error } = await supabase.auth.signUp({
      email,
      password: fd.get("password") as string,
    });
    if (error) {
      setError(error.message);
      setLoading(false);
    } else if (data.user && !data.session) {
      await supabase.auth.resend({ type: "signup", email });
      setSuccess(true);
    } else {
      setSuccess(true);
    }
  }

  if (success) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-paper px-4">
        <div className="w-full max-w-sm text-center">
          <div className="text-[32px] mb-4">📜</div>
          <h2 className="text-ink-1 text-[15px] tracking-[.08em] mb-3">
            Check your email
          </h2>
          <p className="text-ink-3 text-[11px] leading-relaxed mb-6">
            A confirmation link has been sent. Click it to complete your signup.
          </p>
          <Link
            href="/auth/login"
            className="text-accent hover:opacity-70 text-[11px] tracking-[.06em] transition-opacity"
          >
            ← Back to sign in
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-paper px-4">
      <div className="w-full max-w-sm">
        <div className="text-center mb-8">
          <div className="font-display text-[11px] text-ink-3 tracking-[.3em] uppercase mb-3">黒ラボ</div>
          <div className="font-mono text-[24px] text-ink-1 tracking-[.2em] uppercase">KUROLABS</div>
          <div className="mx-auto mt-4" style={{ width: 48, height: 1, background: "var(--paper-border)" }} />
        </div>

        <div className="bg-paper-raised border border-paper-border rounded-[4px] p-8">
          <h2 className="text-ink-1 text-[14px] tracking-[.08em] mb-6">
            Create account
          </h2>

          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <div>
              <label className="block text-ink-3 text-[10px] uppercase tracking-[.1em] mb-1.5">
                Email
              </label>
              <input
                name="email"
                type="email"
                required
                autoComplete="email"
                className="w-full bg-paper-sunken border border-paper-border text-ink-1 px-3 py-2.5 rounded-[4px] focus:outline-none focus:border-accent placeholder:text-ink-4 text-[12px] tracking-[.02em] transition-colors"
                placeholder="you@example.com"
              />
            </div>

            <div>
              <label className="block text-ink-3 text-[10px] uppercase tracking-[.1em] mb-1.5">
                Password
              </label>
              <input
                name="password"
                type="password"
                required
                minLength={6}
                autoComplete="new-password"
                className="w-full bg-paper-sunken border border-paper-border text-ink-1 px-3 py-2.5 rounded-[4px] focus:outline-none focus:border-accent placeholder:text-ink-4 text-[12px] tracking-[.02em] transition-colors"
                placeholder="6+ characters"
              />
            </div>

            {error && (
              <p className="text-[#b83c3c] text-[11px] border border-[#e0a8a8] bg-[#f9e4e4] rounded-[2px] px-3 py-2">
                {error}
              </p>
            )}

            <button
              type="submit"
              disabled={loading}
              className="w-full bg-accent text-white py-2.5 rounded-[2px] hover:opacity-80 transition-opacity disabled:opacity-50 disabled:cursor-not-allowed font-mono tracking-[.08em] text-[11px] mt-2"
            >
              {loading ? "Creating account…" : "Create account"}
            </button>
          </form>

          <p className="text-center text-ink-3 text-[11px] mt-6">
            Already have an account?{" "}
            <Link
              href="/auth/login"
              className="text-accent hover:opacity-70 transition-opacity"
            >
              Sign in
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
}
