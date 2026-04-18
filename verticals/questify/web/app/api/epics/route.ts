import { NextResponse, type NextRequest } from "next/server";
import { z } from "zod";
import { authenticateRequest } from "@/lib/supabase/server";

const CreateEpicSchema = z.object({
  name: z.string().min(1).max(100),
  description: z.string().max(500).optional(),
  icon_name: z.string().optional(),
  color_hex: z.string().regex(/^#[0-9A-Fa-f]{6}$/).optional(),
  ability_score: z.enum(["str", "dex", "con", "int_score", "wis", "cha"]),
});

export async function GET(request: NextRequest) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  // RLS returns system epics + the user's own epics
  const { data, error } = await supabase
    .from("epics")
    .select("*")
    .order("is_system", { ascending: false })
    .order("name");

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ epics: data });
}

export async function POST(request: NextRequest) {
  const { supabase, user } = await authenticateRequest(request);
  if (!user) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });

  const body = await request.json().catch(() => null);
  const parsed = CreateEpicSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: parsed.error.flatten() }, { status: 400 });
  }

  const { data, error } = await supabase
    .from("epics")
    .insert({ ...parsed.data, user_id: user.id, is_system: false })
    .select()
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });

  return NextResponse.json({ epic: data }, { status: 201 });
}
