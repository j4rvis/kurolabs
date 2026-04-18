import { NextResponse, type NextRequest } from "next/server";
import { authenticateRequest } from "@/lib/supabase/server";

export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const { user, accessToken } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const body = await request.json().catch(() => ({}));
  const notes: string | undefined = body.notes;

  // Proxy to the complete-quest Edge Function
  const edgeFunctionUrl = `${process.env.NEXT_PUBLIC_SUPABASE_URL}/functions/v1/complete-quest`;

  const response = await fetch(edgeFunctionUrl, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${accessToken}`,
    },
    body: JSON.stringify({ quest_id: id, notes }),
  });

  const result = await response.json();

  if (!response.ok) {
    return NextResponse.json({ error: result.error }, { status: response.status });
  }

  return NextResponse.json(result);
}
