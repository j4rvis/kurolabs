import { createServerClient } from "@supabase/ssr";
import { createClient } from "@supabase/supabase-js";
import { cookies } from "next/headers";
import type { NextRequest } from "next/server";

// eslint-disable-next-line @typescript-eslint/no-explicit-any
type AnyDatabase = any;

export async function createSupabaseServerClient() {
  const cookieStore = await cookies();

  return createServerClient<AnyDatabase>(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return cookieStore.getAll();
        },
        setAll(cookiesToSet) {
          try {
            cookiesToSet.forEach(({ name, value, options }) => {
              cookieStore.set(name, value, options);
            });
          } catch {
            // Called from a Server Component — middleware will handle session refresh
          }
        },
      },
    }
  );
}

/**
 * Authenticates the request and returns both the scoped Supabase client and
 * the verified user. Handles two auth strategies:
 *
 * - Bearer token (mobile / API clients): the JWT is extracted from the
 *   Authorization header and passed explicitly to `auth.getUser(jwt)` so
 *   Supabase verifies it server-side. The same token is injected as a global
 *   header so RLS policies apply correctly for all subsequent DB queries.
 *
 * - Cookie session (web): falls back to the SSR cookie-based client and
 *   calls `auth.getUser()` as normal.
 *
 * Usage in route handlers:
 *   const { supabase, user, accessToken } = await authenticateRequest(request);
 *   if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
 */
export async function authenticateRequest(request: NextRequest) {
  const authHeader = request.headers.get("Authorization");

  if (authHeader?.startsWith("Bearer ")) {
    const token = authHeader.slice(7);
    const supabase = createClient<AnyDatabase>(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
      {
        global: { headers: { Authorization: `Bearer ${token}` } },
        auth: { persistSession: false, autoRefreshToken: false },
      }
    );
    // Must pass the token explicitly — getUser() without args looks for a
    // stored session, which doesn't exist when using Bearer auth.
    const { data: { user } } = await supabase.auth.getUser(token);
    return { supabase, user, accessToken: token };
  }

  const supabase = await createSupabaseServerClient();
  const { data: { user } } = await supabase.auth.getUser();
  const { data: { session } } = await supabase.auth.getSession();
  return { supabase, user, accessToken: session?.access_token };
}
