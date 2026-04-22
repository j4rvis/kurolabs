"use client";

interface TagChipProps {
  tag: string;
  onClick?: () => void;
  active?: boolean;
}

export function TagChip({ tag, onClick, active }: TagChipProps) {
  return (
    <button
      onClick={(e) => { e.stopPropagation(); onClick?.(); }}
      type="button"
      className={`inline-block px-[7px] py-[2px] rounded-[2px] text-[10px] tracking-[.04em] border transition-all ${
        onClick ? "cursor-pointer" : "cursor-default"
      } ${
        active
          ? "bg-omoi-soft text-omoi border-omoi"
          : "bg-paper-sunken text-ink-3 border-paper-divider"
      }`}
    >
      #{tag}
    </button>
  );
}
