import { createClient } from "jsr:@supabase/supabase-js@2";

// This function is triggered on a cron schedule: every day at 00:00 UTC
// Configure in supabase/config.toml under [functions.daily-reset]
Deno.serve(async (_req) => {
  try {
    const adminClient = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
    );

    const { error } = await adminClient.rpc("reset_daily_quests");

    if (error) {
      console.error("Failed to reset daily quests:", error.message);
      return new Response(JSON.stringify({ error: error.message }), {
        status: 500,
        headers: { "Content-Type": "application/json" },
      });
    }

    console.log("Daily quests reset successfully at", new Date().toISOString());

    return new Response(JSON.stringify({ ok: true, timestamp: new Date().toISOString() }), {
      status: 200,
      headers: { "Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Unexpected error:", err);
    return new Response(JSON.stringify({ error: "Internal server error" }), {
      status: 500,
      headers: { "Content-Type": "application/json" },
    });
  }
});
