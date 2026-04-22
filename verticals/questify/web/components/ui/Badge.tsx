import type { QuestDifficulty, QuestType, NpcQuestFrequency } from "../../lib/types";

const difficultyStyles: Record<QuestDifficulty, string> = {
  trivial:   "bg-[#f0f1f2] text-[#8a9099] border-[#d0d4d8]",
  easy:      "bg-[#eaf4ee] text-[#3d7a52] border-[#b8d9c4]",
  medium:    "bg-[#f9f0e4] text-[#b07030] border-[#e0c89a]",
  hard:      "bg-[#f9ece4] text-[#b85a20] border-[#e0b898]",
  deadly:    "bg-[#f9e4e4] text-[#b83c3c] border-[#e0a8a8]",
  legendary: "bg-[#f0eaf9] text-[#7040a0] border-[#c8aee0]",
};

const questTypeStyles: Record<QuestType, string> = {
  daily: "bg-[#e8f0f9] text-[#2d5a8e] border-[#b0c8e8]",
  side:  "bg-[#eaf4ee] text-[#3d7a52] border-[#b8d9c4]",
  epic:  "bg-[#f0eaf9] text-[#7040a0] border-[#c8aee0]",
};

const questTypeLabels: Record<QuestType, string> = {
  daily: "Daily",
  side:  "Side Quest",
  epic:  "Epic",
};

const frequencyStyles: Record<NpcQuestFrequency, string> = {
  daily:    "bg-[#e8f0f9] text-[#2d5a8e] border-[#b0c8e8]",
  weekly:   "bg-[#eaf4ee] text-[#3d7a52] border-[#b8d9c4]",
  monthly:  "bg-[#f9f0e4] text-[#b07030] border-[#e0c89a]",
  one_time: "bg-[#f0eaf9] text-[#7040a0] border-[#c8aee0]",
};

const frequencyLabels: Record<NpcQuestFrequency, string> = {
  daily:    "Daily",
  weekly:   "Weekly",
  monthly:  "Monthly",
  one_time: "One-time",
};

function Badge({ className, children }: { className: string; children: React.ReactNode }) {
  return (
    <span className={`inline-flex items-center px-[7px] py-[2px] rounded-[2px] text-[10px] tracking-[.04em] border ${className}`}>
      {children}
    </span>
  );
}

export function DifficultyBadge({ difficulty }: { difficulty: QuestDifficulty }) {
  return (
    <Badge className={difficultyStyles[difficulty]}>
      {difficulty.charAt(0).toUpperCase() + difficulty.slice(1)}
    </Badge>
  );
}

export function QuestTypeBadge({ type }: { type: QuestType }) {
  return (
    <Badge className={questTypeStyles[type]}>
      {questTypeLabels[type]}
    </Badge>
  );
}

export function FrequencyBadge({ frequency }: { frequency: NpcQuestFrequency }) {
  return (
    <Badge className={frequencyStyles[frequency]}>
      {frequencyLabels[frequency]}
    </Badge>
  );
}
