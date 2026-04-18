// Shared database types for KuroLabs verticals.
// Replace with generated types after running:
// supabase gen types typescript --project-id <id> > lib/types.ts

export interface Profile {
  id: string;
  username: string;
  display_name: string | null;
  avatar_url: string | null;
  character_class: string;
  created_at: string;
  updated_at: string;
}

export interface Character {
  id: string;
  user_id: string;
  level: number;
  total_xp: number;
  str: number;
  dex: number;
  con: number;
  int_score: number;
  wis: number;
  cha: number;
  created_at: string;
  updated_at: string;
}

export interface XpThreshold {
  level: number;
  xp_needed: number;
  title: string;
}
