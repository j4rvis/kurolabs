import { redirect } from "next/navigation";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import Link from "next/link";

export default async function OmoiLayout({ children }: { children: React.ReactNode }) {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/auth/login");

  return (
    <div className="theme-omoi min-h-screen bg-paper flex flex-col font-mono">
      <header className="border-b border-paper-divider px-6 py-3 flex items-center justify-between">
        <Link href="/hub/omoi/dashboard" className="text-omoi text-[11px] tracking-[.08em]">
          想 · OMOI
        </Link>
        <nav className="flex items-center gap-5 text-[10px] tracking-[.06em]">
          <Link href="/hub/omoi/dashboard" className="text-ink-3 hover:text-ink-2">dashboard</Link>
          <Link href="/hub/omoi/chrome-extension" className="text-ink-3 hover:text-ink-2">extension</Link>
          <Link href="/hub" className="text-ink-4 hover:text-ink-3">← hub</Link>
        </nav>
      </header>
      <main className="flex-1 w-full">
        {children}
      </main>
    </div>
  );
}
