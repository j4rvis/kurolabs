"use client";

interface TagChipProps {
  tag: string;
  onClick?: () => void;
  active?: boolean;
}

export function TagChip({ tag, onClick, active }: TagChipProps) {
  const base = "inline-block px-2 py-0.5 rounded text-xs font-mono transition-colors";
  const style = active
    ? "bg-violet-600 text-white"
    : "bg-zinc-800 text-zinc-400 hover:bg-zinc-700 hover:text-zinc-300";

  return (
    <button
      onClick={(e) => { e.stopPropagation(); onClick?.(); }}
      className={`${base} ${style} ${onClick ? "cursor-pointer" : "cursor-default"}`}
      type="button"
    >
      #{tag}
    </button>
  );
}
