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
    <div className="min-h-screen bg-zinc-950 flex flex-col">
      <header className="border-b border-zinc-800 px-6 py-4 flex items-center justify-between">
        <Link href="/hub/omoi/dashboard" className="text-violet-400 font-semibold tracking-wide">
          想い · Omoi
        </Link>
        <nav className="flex items-center gap-4 text-sm">
          <Link href="/hub/omoi/dashboard" className="text-zinc-400 hover:text-zinc-200">Dashboard</Link>
          <Link href="/hub/omoi/chrome-extension" className="text-zinc-400 hover:text-zinc-200">Extension</Link>
          <Link href="/hub" className="text-zinc-600 hover:text-zinc-400">← Hub</Link>
        </nav>
      </header>
      <main className="flex-1 max-w-3xl mx-auto w-full px-4 sm:px-6 py-8">
        {children}
      </main>
    </div>
  );
}
