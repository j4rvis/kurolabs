import { NextResponse, type NextRequest } from "next/server";
import { z } from "zod";
import { authenticateRequest } from "@/lib/supabase/server";

const VerifySchema = z.object({
  quest_id: z.string().uuid(),
});

// Quest giver marks a quest as verified
export async function POST(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const body = await request.json().catch(() => null);
  const parsed = VerifySchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 });
  }

  // Confirm the current user is an accepted quest giver for this relationship
  const { data: relationship, error: relError } = await supabase
    .from("quest_givers")
    .select("*")
    .eq("id", id)
    .eq("giver_user_id", user.id)
    .eq("status", "accepted")
    .single();

  if (relError || !relationship) {
    return NextResponse.json({ error: "Quest giver relationship not found or not accepted" }, { status: 403 });
  }

  // Mark the quest as verified
  const { data, error } = await supabase
    .from("quests")
    .update({
      verified_at: new Date().toISOString(),
      verified_by: user.id,
      updated_at: new Date().toISOString(),
    })
    .eq("id", parsed.data.quest_id)
    .eq("user_id", relationship.user_id)
    .select()
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ quest: data });
}
