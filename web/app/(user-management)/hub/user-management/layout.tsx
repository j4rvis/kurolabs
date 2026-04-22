import { redirect } from "next/navigation";
import { createSupabaseServerClient } from "@/lib/supabase/server";
import Link from "next/link";

export default async function UserManagementLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) redirect("/auth/login");

  return (
    <div className="min-h-screen bg-paper flex flex-col">
      <nav className="bg-paper-raised border-b border-paper-border px-8 py-4 flex items-center">
        <Link
          href="/hub"
          className="font-display text-[14px] text-ink-1 tracking-[.2em]"
        >
          KUROLABS
        </Link>
      </nav>
      <main className="flex-1 max-w-7xl mx-auto w-full px-4 sm:px-6 py-8">
        {children}
      </main>
    </div>
  );
}
