"use client";

import { useRouter } from "next/navigation";
import { createSupabaseBrowserClient } from "../../lib/supabase/client";

export default function SignOutButton() {
  const router = useRouter();
  const supabase = createSupabaseBrowserClient();

  async function handleSignOut() {
    await supabase.auth.signOut();
    router.push("/auth/login");
  }

  return (
    <button
      onClick={handleSignOut}
      className="text-ink-3 hover:text-ink-2 text-[10px] tracking-[.06em] transition-colors px-2 py-1"
    >
      Sign out
    </button>
  );
}
