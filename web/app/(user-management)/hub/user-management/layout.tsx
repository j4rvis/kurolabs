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
    <div className="min-h-screen bg-tavern flex flex-col">
      <nav className="bg-tavern-light border-b border-tavern-border px-4 sm:px-6 py-3 flex items-center">
        <Link
          href="/hub"
          className="font-display text-xl text-gold tracking-widest"
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
