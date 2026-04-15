// Database types — replace with generated types after running:
// supabase gen types typescript --project-id <id> > lib/types.ts

export type QuestType = "daily" | "side" | "epic";
export type QuestDifficulty = "trivial" | "easy" | "medium" | "hard" | "deadly" | "legendary";
export type QuestStatus = "active" | "completed" | "failed" | "archived";
export type AbilityScore = "str" | "dex" | "con" | "int_score" | "wis" | "cha";
export type QuestGiverStatus = "pending" | "accepted" | "declined" | "revoked";
export type NpcQuestFrequency = "daily" | "weekly" | "monthly" | "one_time";

export const XP_BY_DIFFICULTY: Record<QuestDifficulty, number> = {
  trivial: 25,
  easy: 50,
  medium: 100,
  hard: 250,
  deadly: 500,
  legendary: 1000,
};

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

export interface Epic {
  id: string;
  user_id: string | null;
  name: string;
  description: string | null;
  icon_name: string | null;
  color_hex: string;
  ability_score: AbilityScore;
  is_system: boolean;
  created_at: string;
}

export interface Quest {
  id: string;
  user_id: string;
  epic_id: string | null;
  quest_giver_id: string | null;
  title: string;
  description: string | null;
  quest_type: QuestType;
  difficulty: QuestDifficulty;
  xp_reward: number;
  recurrence_rule: string | null;
  due_date: string | null;
  status: QuestStatus;
  completed_at: string | null;
  verified_at: string | null;
  verified_by: string | null;
  current_streak: number;
  longest_streak: number;
  last_completed_date: string | null;
  created_at: string;
  updated_at: string;
}

export interface QuestCompletion {
  id: string;
  quest_id: string;
  user_id: string;
  xp_earned: number;
  ability_score: AbilityScore | null;
  score_delta: number;
  notes: string | null;
  completed_at: string;
}

export interface QuestGiver {
  id: string;
  user_id: string;
  giver_user_id: string;
  status: QuestGiverStatus;
  invited_at: string;
  accepted_at: string | null;
}

export interface NpcQuestGiver {
  id: string;
  slug: string;
  name: string;
  title: string;
  category: string;
  description: string;
  image_filename: string;
  sort_order: number;
  created_at: string;
}

export interface NpcQuestTemplate {
  id: string;
  npc_id: string;
  title: string;
  description: string | null;
  frequency: NpcQuestFrequency;
  difficulty: QuestDifficulty;
  xp_reward: number;
  sort_order: number;
  created_at: string;
}

export interface UserNpcConnection {
  id: string;
  user_id: string;
  npc_id: string;
  connected_at: string;
}

export interface XpThreshold {
  level: number;
  xp_needed: number;
  title: string;
}

// Placeholder Database type for @supabase/ssr generics
// Replace with the generated type from `supabase gen types typescript`
export type Database = {
  public: {
    Tables: {
      profiles: { Row: Profile; Insert: Partial<Profile>; Update: Partial<Profile> };
      characters: { Row: Character; Insert: Partial<Character>; Update: Partial<Character> };
      epics: { Row: Epic; Insert: Partial<Epic>; Update: Partial<Epic> };
      quests: { Row: Quest; Insert: Partial<Quest>; Update: Partial<Quest> };
      quest_completions: { Row: QuestCompletion; Insert: Partial<QuestCompletion>; Update: Partial<QuestCompletion> };
      quest_givers: { Row: QuestGiver; Insert: Partial<QuestGiver>; Update: Partial<QuestGiver> };
      xp_thresholds: { Row: XpThreshold; Insert: Partial<XpThreshold>; Update: Partial<XpThreshold> };
    };
    Views: Record<string, never>;
    Functions: {
      complete_quest: { Args: { p_quest_id: string; p_user_id: string; p_notes?: string }; Returns: unknown };
      reset_daily_quests: { Args: Record<string, never>; Returns: void };
    };
    Enums: Record<string, never>;
  };
};
