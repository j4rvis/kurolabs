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
    <div className="flex flex-col gap-5">
      <div className="bg-paper-raised border border-paper-border rounded-[4px] p-7">
        {editing ? (
          <div className="flex flex-col gap-3">
            <textarea
              value={editContent}
              onChange={(e) => setEditContent(e.target.value)}
              className="w-full h-40 bg-paper-sunken border border-paper-border focus:border-omoi rounded-[4px] p-3 text-ink-1 text-[12px] tracking-[.02em] leading-[1.7] resize-none outline-none caret-omoi transition-colors"
            />
            <div className="flex gap-2">
              <button
                onClick={handleSave}
                disabled={saving}
                className="bg-omoi text-white rounded-[2px] px-[18px] py-[7px] text-[10px] tracking-[.08em] disabled:opacity-50"
              >
                {saving ? "saving…" : "save"}
              </button>
              <button
                onClick={() => { setEditing(false); setEditContent(thought.content); }}
                className="bg-paper-sunken text-ink-2 rounded-[2px] px-[18px] py-[7px] text-[10px] tracking-[.08em]"
              >
                cancel
              </button>
            </div>
          </div>
        ) : (
          <p className="text-ink-1 text-[13px] leading-[1.8] tracking-[.02em] whitespace-pre-wrap">
            {thought.content}
          </p>
        )}

        <div className="flex items-center gap-2 mt-5 pt-4 border-t border-paper-divider flex-wrap">
          <CategoryBadge category={thought.category} />
          {thought.tags.map((tag) => (
            <TagChip key={tag} tag={tag} />
          ))}
          <div className="ml-auto flex gap-4">
            {!editing && (
              <button
                onClick={() => setEditing(true)}
                className="text-[10px] tracking-[.06em] text-ink-3 hover:text-ink-2"
              >
                edit
              </button>
            )}
            <button
              onClick={() => onDelete(thought.id)}
              className="text-[10px] tracking-[.06em] text-[#b83c3c] hover:opacity-70"
            >
              delete
            </button>
          </div>
        </div>
      </div>

      {connections.length > 0 && (
        <div>
          <h3 className="text-ink-3 text-[9px] tracking-[.08em] uppercase mb-3">
            connected thoughts
          </h3>
          <div className="flex flex-col gap-2">
            {connections.map((c) => (
              <div
                key={c.id}
                onClick={() => onConnectionClick(c.id)}
                className="bg-paper-raised border border-paper-divider hover:border-paper-border rounded-[4px] p-3 cursor-pointer transition-colors"
              >
                <p className="text-ink-2 text-[12px] leading-[1.7] line-clamp-2">{c.content}</p>
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
