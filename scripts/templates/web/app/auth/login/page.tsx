"use client";
import { useState } from "react";
import { useRouter } from "next/navigation";
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
      router.push("/dashboard");
    }
  }

  return (
    <main className="min-h-screen flex items-center justify-center">
      <form onSubmit={handleSubmit} className="flex flex-col gap-4 w-full max-w-sm p-8">
        <h1 className="text-2xl font-bold">__VERTICAL_PASCAL__</h1>
        <input name="email" type="email" required placeholder="Email" className="border px-3 py-2 rounded" />
        <input name="password" type="password" required placeholder="Password" className="border px-3 py-2 rounded" />
        {error && <p className="text-red-500 text-sm">{error}</p>}
        <button type="submit" disabled={loading} className="bg-black text-white py-2 rounded disabled:opacity-50">
          {loading ? "Signing in…" : "Sign in"}
        </button>
        <a href="/auth/signup" className="text-sm text-center underline">No account? Sign up</a>
      </form>
    </main>
  );
}
