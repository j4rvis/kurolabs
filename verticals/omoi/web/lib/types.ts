export type ThoughtCategory = "question" | "reminder" | "insight" | "idea" | "other";

export interface Thought {
  id: string;
  user_id: string;
  content: string;
  category: ThoughtCategory;
  tags: string[];
  created_at: string;
  updated_at: string;
}

export interface ThoughtStats {
  total: number;
  today: number;
  connections: number;
  top_tags: Array<{ tag: string; count: number }>;
}
