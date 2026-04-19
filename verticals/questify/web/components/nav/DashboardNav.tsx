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
    <nav className="bg-tavern-light border-b border-tavern-border px-4 sm:px-6 py-3 flex items-center justify-between">
      <div className="flex items-center gap-1">
        <Link
          href="/dashboard/quests"
          className="font-display text-xl text-gold tracking-widest mr-4 sm:mr-8"
        >
          QUESTIFY
        </Link>
        <NavLinks />
      </div>
      <div className="flex items-center gap-3">
        {user?.email && (
          <span className="text-parchment-muted text-xs hidden sm:block truncate max-w-[160px]">
            {user.email}
          </span>
        )}
        <SignOutButton />
      </div>
    </nav>
  );
}
