import { NextResponse, type NextRequest } from "next/server";
import { z } from "zod";
import { authenticateRequest } from "@/lib/supabase/server";

const ConnectSchema = z.object({
  other_id: z.string().uuid(),
});

export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { id } = await params;

  const body = await request.json().catch(() => null);
  const parsed = ConnectSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 });
  }

  const { other_id } = parsed.data;

  if (id === other_id) {
    return NextResponse.json({ error: "Cannot connect a thought to itself" }, { status: 400 });
  }

  // Enforce ordering: thought_id_a < thought_id_b
  const [thought_id_a, thought_id_b] = [id, other_id].sort();

  const { error } = await supabase
    .from("thought_connections")
    .insert({ thought_id_a, thought_id_b });

  if (error) {
    if (error.code === "23505") {
      return NextResponse.json({ error: "Connection already exists" }, { status: 409 });
    }
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ thought_id_a, thought_id_b }, { status: 201 });
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const { id } = await params;

  const { searchParams } = new URL(request.url);
  const other_id = searchParams.get("other_id");
  if (!other_id) {
    return NextResponse.json({ error: "Missing other_id query param" }, { status: 400 });
  }

  const [thought_id_a, thought_id_b] = [id, other_id].sort();

  const { error } = await supabase
    .from("thought_connections")
    .delete()
    .eq("thought_id_a", thought_id_a)
    .eq("thought_id_b", thought_id_b);

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return new NextResponse(null, { status: 204 });
}
