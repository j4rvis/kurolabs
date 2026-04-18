import { createSupabaseMiddlewareClient } from "@kurolabs/web/middleware/auth";
import { NextResponse, type NextRequest } from "next/server";

export async function middleware(request: NextRequest) {
  const { response, user } = await createSupabaseMiddlewareClient(request);

  const { pathname } = request.nextUrl;

  // Protect dashboard routes
  if (pathname.startsWith("/dashboard") && !user) {
    const url = request.nextUrl.clone();
    url.pathname = "/auth/login";
    return NextResponse.redirect(url);
  }

  // Return 401 JSON for unauthenticated API requests (except auth endpoints).
  // Skip if a Bearer token is present — those are authenticated in the route handler.
  const hasBearerToken = request.headers.get("Authorization")?.startsWith("Bearer ");
  if (pathname.startsWith("/api/") && !pathname.startsWith("/api/auth/") && !user && !hasBearerToken) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  return response;
}

export const config = {
  matcher: [
    "/((?!_next/static|_next/image|favicon.ico|.*\\.(?:svg|png|jpg|jpeg|gif|webp)$).*)",
  ],
};
