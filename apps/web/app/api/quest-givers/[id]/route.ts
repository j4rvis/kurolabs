import { NextResponse, type NextRequest } from "next/server";
import { z } from "zod";
import { authenticateRequest } from "@/lib/supabase/server";

const UpdateStatusSchema = z.object({
  status: z.enum(["accepted", "declined", "revoked"]),
});

// Accept or decline an invite (called by the quest giver)
export async function PATCH(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const body = await request.json().catch(() => null);
  const parsed = UpdateStatusSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 });
  }

  const updates: Record<string, unknown> = { status: parsed.data.status };
  if (parsed.data.status === "accepted") {
    updates.accepted_at = new Date().toISOString();
  }

  // RLS ensures only the giver_user_id or user_id can update this row
  const { data, error } = await supabase
    .from("quest_givers")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ quest_giver: data });
}
