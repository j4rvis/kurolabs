import Link from "next/link";
import { createSupabaseServerClient } from "../../lib/supabase/server";
import SignOutButton from "./SignOutButton";
import NavLinks from "./NavLinks";

export default async function DashboardNav() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  return (
    <nav className="bg-paper-raised border-b border-paper-border px-8 flex items-center gap-0">
      <div className="mr-8 py-4">
        <Link href="/hub/questify/quests">
          <div className="font-display text-[9px] text-ink-3 tracking-[.25em] mb-0.5">冒険</div>
          <div className="font-mono text-[14px] text-ink-1 tracking-[.15em]">QUESTIFY</div>
        </Link>
      </div>
      <NavLinks />
      <div className="ml-auto flex items-center gap-3 py-4">
        {user?.email && (
          <span className="text-ink-3 text-[10px] hidden sm:block truncate max-w-[160px] tracking-[.04em]">
            {user.email}
          </span>
        )}
        <SignOutButton />
      </div>
    </nav>
  );
}
