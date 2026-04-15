import { NextResponse, type NextRequest } from "next/server";
import { authenticateRequest } from "@/lib/supabase/server";

export async function GET(request: NextRequest) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const [asAdventurerRes, asGiverRes] = await Promise.all([
    // Relationships where this user is the adventurer
    supabase
      .from("quest_givers")
      .select("*")
      .eq("user_id", user.id)
      .order("invited_at", { ascending: false }),
    // Relationships where this user is the giver (accepted only)
    supabase
      .from("quest_givers")
      .select("*")
      .eq("giver_user_id", user.id)
      .eq("status", "accepted")
      .order("accepted_at", { ascending: false }),
  ]);

  if (asAdventurerRes.error) {
    return NextResponse.json({ error: asAdventurerRes.error.message }, { status: 500 });
  }

  return NextResponse.json({
    quest_givers: asAdventurerRes.data,
    my_adventurers: asGiverRes.data ?? [],
  });
}

export async function POST(request: NextRequest) {
  const { user, accessToken } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const body = await request.json().catch(() => null);
  if (!body?.giver_email) {
    return NextResponse.json({ error: "giver_email is required" }, { status: 400 });
  }

  // Proxy to the invite-quest-giver Edge Function
  const edgeFunctionUrl = `${process.env.NEXT_PUBLIC_SUPABASE_URL}/functions/v1/invite-quest-giver`;

  const response = await fetch(edgeFunctionUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${accessToken}`,
    },
    body: JSON.stringify({ giver_email: body.giver_email }),
  });

  const result = await response.json();
  if (!response.ok) {
    return NextResponse.json({ error: result.error }, { status: response.status });
  }

  return NextResponse.json(result, { status: 201 });
}
