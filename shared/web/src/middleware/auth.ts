import { createServerClient } from "@supabase/ssr";
import { NextResponse, type NextRequest } from "next/server";

/**
 * Creates a Supabase client for use in middleware with proper cookie handling
 * and session refresh. Returns the client, the response object (with updated
 * cookies), and the authenticated user (or null).
 *
 * Usage:
 *   const { supabase, response, user } = await createSupabaseMiddlewareClient(request);
 *   // add your own route-protection logic, then return response
 */
export async function createSupabaseMiddlewareClient(request: NextRequest) {
  let response = NextResponse.next({ request });

  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() {
          return request.cookies.getAll();
        },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value));
          response = NextResponse.next({ request });
          cookiesToSet.forEach(({ name, value, options }) =>
            response.cookies.set(name, value, options)
          );
        },
      },
    }
  );

  // Refresh session — must not run getUser() in a cached context
  const { data: { user } } = await supabase.auth.getUser();

  return { supabase, response, user };
}
