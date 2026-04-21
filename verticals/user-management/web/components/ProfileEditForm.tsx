"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { createSupabaseBrowserClient } from "../lib/supabase/client";
import type { Profile } from "@kurolabs/web/types";

interface Props {
  profile: Profile;
}

export default function ProfileEditForm({ profile }: Props) {
  const router = useRouter();
  const supabase = createSupabaseBrowserClient();

  const [displayName, setDisplayName] = useState(profile.display_name ?? "");
  const [username, setUsername] = useState(profile.username);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState(false);

  async function handleSave(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    setSuccess(false);

    const { error: updateError } = await supabase
      .from("profiles")
      .update({ display_name: displayName || null, username })
      .eq("id", profile.id);

    setSaving(false);

    if (updateError) {
      if (updateError.message.includes("unique") || updateError.code === "23505") {
        setError("That username is already taken.");
      } else {
        setError(updateError.message);
      }
    } else {
      setSuccess(true);
      router.refresh();
    }
  }

  async function handleSignOut() {
    await supabase.auth.signOut();
    router.push("/hub");
  }

  return (
    <div className="space-y-6">
      <form onSubmit={handleSave} className="space-y-4">
        <div>
          <label className="block text-parchment-muted text-xs uppercase tracking-widest mb-1.5">
            Display Name
          </label>
          <input
            value={displayName}
            onChange={(e) => setDisplayName(e.target.value)}
            className="w-full bg-tavern border border-tavern-border text-parchment px-3 py-2.5 rounded focus:outline-none focus:border-gold placeholder-ink-muted text-sm"
            placeholder="Your adventurer name"
          />
        </div>

        <div>
          <label className="block text-parchment-muted text-xs uppercase tracking-widest mb-1.5">
            Username
          </label>
          <input
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
            className="w-full bg-tavern border border-tavern-border text-parchment px-3 py-2.5 rounded focus:outline-none focus:border-gold placeholder-ink-muted text-sm"
            placeholder="unique_username"
          />
        </div>

        {error && (
          <p className="text-red-400 text-sm border border-red-900 bg-red-950/30 rounded px-3 py-2">
            {error}
          </p>
        )}

        {success && (
          <p className="text-green-400 text-sm border border-green-900 bg-green-950/30 rounded px-3 py-2">
            Profile updated.
          </p>
        )}

        <button
          type="submit"
          disabled={saving}
          className="bg-gold text-tavern font-semibold py-2 px-6 rounded hover:bg-gold-light transition-colors disabled:opacity-50 disabled:cursor-not-allowed font-display tracking-wider text-sm"
        >
          {saving ? "Saving…" : "Save Changes"}
        </button>
      </form>

      <div className="border-t border-tavern-border pt-6">
        <button
          onClick={handleSignOut}
          className="text-parchment-muted hover:text-parchment text-sm transition-colors"
        >
          Sign out
        </button>
      </div>
    </div>
  );
}
