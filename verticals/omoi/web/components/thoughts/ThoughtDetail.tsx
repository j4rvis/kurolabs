"use client";

import { useState } from "react";
import type { Thought } from "../../lib/types";
import { CategoryBadge } from "./CategoryBadge";
import { TagChip } from "./TagChip";

interface ThoughtDetailProps {
  thought: Thought;
  connections: Pick<Thought, "id" | "content" | "category" | "tags" | "created_at">[];
  onEdit: (id: string, content: string) => Promise<void>;
  onDelete: (id: string) => Promise<void>;
  onConnectionClick: (id: string) => void;
}

export function ThoughtDetail({
  thought,
  connections,
  onEdit,
  onDelete,
  onConnectionClick,
}: ThoughtDetailProps) {
  const [editing, setEditing] = useState(false);
  const [editContent, setEditContent] = useState(thought.content);
  const [saving, setSaving] = useState(false);

  async function handleSave() {
    setSaving(true);
    await onEdit(thought.id, editContent);
    setSaving(false);
    setEditing(false);
  }

  return (
    <div className="flex flex-col gap-6">
      <div className="bg-zinc-900 border border-zinc-800 rounded-lg p-6">
        {editing ? (
          <div className="flex flex-col gap-3">
            <textarea
              value={editContent}
              onChange={(e) => setEditContent(e.target.value)}
              className="w-full h-40 bg-zinc-800 border border-zinc-700 rounded p-3 text-zinc-200 text-sm resize-none focus:outline-none focus:border-violet-500"
            />
            <div className="flex gap-2">
              <button
                onClick={handleSave}
                disabled={saving}
                className="px-4 py-2 bg-violet-600 hover:bg-violet-700 disabled:opacity-50 rounded text-sm text-white"
              >
                {saving ? "Saving…" : "Save"}
              </button>
              <button
                onClick={() => { setEditing(false); setEditContent(thought.content); }}
                className="px-4 py-2 bg-zinc-800 hover:bg-zinc-700 rounded text-sm text-zinc-300"
              >
                Cancel
              </button>
            </div>
          </div>
        ) : (
          <p className="text-zinc-200 text-sm leading-relaxed whitespace-pre-wrap">{thought.content}</p>
        )}

        <div className="flex items-center gap-2 mt-4 flex-wrap border-t border-zinc-800 pt-4">
          <CategoryBadge category={thought.category} />
          {thought.tags.map((tag) => (
            <TagChip key={tag} tag={tag} />
          ))}
          <div className="ml-auto flex gap-3">
            {!editing && (
              <button
                onClick={() => setEditing(true)}
                className="text-xs text-zinc-500 hover:text-zinc-300"
              >
                Edit
              </button>
            )}
            <button
              onClick={() => onDelete(thought.id)}
              className="text-xs text-red-600 hover:text-red-400"
            >
              Delete
            </button>
          </div>
        </div>
      </div>

      {connections.length > 0 && (
        <div>
          <h3 className="text-xs font-semibold text-zinc-500 uppercase tracking-wider mb-3">
            Connected thoughts
          </h3>
          <div className="flex flex-col gap-2">
            {connections.map((c) => (
              <div
                key={c.id}
                onClick={() => onConnectionClick(c.id)}
                className="bg-zinc-900 border border-zinc-800 rounded-lg p-3 cursor-pointer hover:border-zinc-700 transition-colors"
              >
                <p className="text-zinc-300 text-sm line-clamp-2">{c.content}</p>
                <div className="flex gap-2 mt-2">
                  <CategoryBadge category={c.category} />
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}
