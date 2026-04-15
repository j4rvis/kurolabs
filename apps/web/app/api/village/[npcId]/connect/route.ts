import { NextResponse, type NextRequest } from "next/server";
import { authenticateRequest } from "@/lib/supabase/server";

// POST /api/village/[npcId]/connect
export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ npcId: string }> }
) {
  const { npcId } = await params;
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { data, error } = await supabase
    .from("user_npc_connections")
    .insert({ user_id: user.id, npc_id: npcId })
    .select()
    .single();

  if (error) {
    // Unique violation = already connected
    if (error.code === "23505") return NextResponse.json({ error: "Already connected" }, { status: 409 });
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ connection: data }, { status: 201 });
}

// DELETE /api/village/[npcId]/connect
export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ npcId: string }> }
) {
  const { npcId } = await params;
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { error } = await supabase
    .from("user_npc_connections")
    .delete()
    .eq("user_id", user.id)
    .eq("npc_id", npcId);

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ ok: true });
}
