import { NextResponse, type NextRequest } from "next/server";
import { z } from "zod";
import { authenticateRequest } from "@/lib/supabase/server";

const UpdateThoughtSchema = z.object({
  content: z.string().min(1).max(10000).optional(),
  category: z.enum(["question", "reminder", "insight", "idea", "other"]).optional(),
  tags: z.array(z.string()).optional(),
});

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { id } = await params;

  const { data: thought, error } = await supabase
    .from("thoughts")
    .select("*")
    .eq("id", id)
    .eq("user_id", user.id)
    .single();

  if (error || !thought) return NextResponse.json({ error: "Not found" }, { status: 404 });

  // Fetch connections (bidirectional)
  const { data: connections } = await supabase
    .from("thought_connections")
    .select("thought_id_a, thought_id_b, created_at")
    .or(`thought_id_a.eq.${id},thought_id_b.eq.${id}`);

  const connectedIds = (connections ?? []).map((c) =>
    c.thought_id_a === id ? c.thought_id_b : c.thought_id_a
  );

  let connectedThoughts: unknown[] = [];
  if (connectedIds.length > 0) {
    const { data } = await supabase
      .from("thoughts")
      .select("id, content, category, tags, created_at")
      .in("id", connectedIds);
    connectedThoughts = data ?? [];
  }

  return NextResponse.json({ thought, connections: connectedThoughts });
}

export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { id } = await params;

  const body = await request.json().catch(() => null);
  const parsed = UpdateThoughtSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 });
  }

  const { data, error } = await supabase
    .from("thoughts")
    .update(parsed.data)
    .eq("id", id)
    .eq("user_id", user.id)
    .select()
    .single();

  if (error || !data) return NextResponse.json({ error: "Not found" }, { status: 404 });

  return NextResponse.json({ thought: data });
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { id } = await params;

  const { error } = await supabase
    .from("thoughts")
    .delete()
    .eq("id", id)
    .eq("user_id", user.id);

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return new NextResponse(null, { status: 204 });
}
