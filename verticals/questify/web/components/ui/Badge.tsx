import type { QuestDifficulty, QuestType, NpcQuestFrequency } from "../../lib/types";

const difficultyStyles: Record<QuestDifficulty, string> = {
  trivial:   "bg-[#6c757d]/20 text-[#9aa0a6] border-[#6c757d]/40",
  easy:      "bg-[#3a8c4e]/20 text-[#6abf7a] border-[#3a8c4e]/40",
  medium:    "bg-[#c9a227]/20 text-[#f0c940] border-[#c9a227]/40",
  hard:      "bg-[#d4732a]/20 text-[#f0924a] border-[#d4732a]/40",
  deadly:    "bg-[#c0392b]/20 text-[#e05c50] border-[#c0392b]/40",
  legendary: "bg-[#8e44ad]/20 text-[#c07ad8] border-[#8e44ad]/40",
};

const questTypeStyles: Record<QuestType, string> = {
  daily: "bg-[#2980b9]/20 text-[#5dade2] border-[#2980b9]/40",
  side:  "bg-[#27ae60]/20 text-[#52be80] border-[#27ae60]/40",
  epic:  "bg-[#8e44ad]/20 text-[#c07ad8] border-[#8e44ad]/40",
};

const questTypeLabels: Record<QuestType, string> = {
  daily: "Daily",
  side:  "Side Quest",
  epic:  "Epic",
};

const frequencyStyles: Record<NpcQuestFrequency, string> = {
  daily:    "bg-[#2980b9]/20 text-[#5dade2] border-[#2980b9]/40",
  weekly:   "bg-[#27ae60]/20 text-[#52be80] border-[#27ae60]/40",
  monthly:  "bg-[#c9a227]/20 text-[#f0c940] border-[#c9a227]/40",
  one_time: "bg-[#8e44ad]/20 text-[#c07ad8] border-[#8e44ad]/40",
};

const frequencyLabels: Record<NpcQuestFrequency, string> = {
  daily:    "Daily",
  weekly:   "Weekly",
  monthly:  "Monthly",
  one_time: "One-time",
};

function Badge({ className, children }: { className: string; children: React.ReactNode }) {
  return (
    <span className={`inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium border ${className}`}>
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
