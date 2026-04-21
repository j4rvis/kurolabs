import { createSupabaseServerClient } from "../lib/supabase/server";
import ProfileEditForm from "./ProfileEditForm";

export default async function ProfilePage() {
  const supabase = await createSupabaseServerClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user!.id)
    .single();

  if (!profile) {
    return (
      <div className="text-parchment-muted text-sm">Profile not found.</div>
    );
  }

  return (
    <div className="max-w-lg">
      <div className="mb-8">
        <h1 className="font-display text-2xl text-gold tracking-wide mb-1">
          Your Profile
        </h1>
        <p className="text-parchment-muted text-sm">
          Manage your account and adventurer details
        </p>
      </div>

      <div className="bg-tavern-light border border-tavern-border rounded-lg p-6 mb-6">
        <div className="flex items-center gap-4 mb-6">
          <div className="w-16 h-16 rounded-full bg-tavern-mid border-2 border-tavern-border flex items-center justify-center flex-shrink-0">
            {profile.avatar_url ? (
              // eslint-disable-next-line @next/next/no-img-element
              <img
                src={profile.avatar_url}
                alt="Avatar"
                className="w-full h-full rounded-full object-cover"
              />
            ) : (
              <span className="text-2xl">⚔️</span>
            )}
          </div>
          <div>
            <p className="text-parchment font-medium">
              {profile.display_name || profile.username}
            </p>
            <p className="text-parchment-muted text-sm">@{profile.username}</p>
            <p className="text-gold text-xs mt-0.5">{profile.character_class}</p>
          </div>
        </div>

        <ProfileEditForm profile={profile} />
      </div>
    </div>
  );
}
