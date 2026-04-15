import type { Quest } from "@/lib/types";
import { DifficultyBadge, QuestTypeBadge } from "@/components/ui/Badge";
import CompleteQuestButton from "./CompleteQuestButton";

type QuestWithNpc = Quest & {
  npc_quest_givers?: { name: string; image_filename: string } | null;
};

export default function QuestCard({ quest }: { quest: QuestWithNpc }) {
  return (
    <div className="bg-tavern-light border border-tavern-border rounded-lg p-4 flex flex-col gap-3">
      <div className="flex items-start justify-between gap-3">
        <div className="flex-1 min-w-0">
          <h3 className="text-parchment font-medium text-sm leading-snug">
            {quest.title}
          </h3>
          {quest.npc_quest_givers && (
            <p className="text-parchment-muted text-xs mt-0.5">
              {quest.npc_quest_givers.name}
            </p>
          )}
        </div>
        {quest.quest_type === "daily" && (
          <CompleteQuestButton questId={quest.id} />
        )}
      </div>

      {quest.description && (
        <p className="text-parchment-muted text-xs leading-relaxed line-clamp-2">
          {quest.description}
        </p>
      )}

      <div className="flex items-center gap-2 flex-wrap">
        <QuestTypeBadge type={quest.quest_type} />
        <DifficultyBadge difficulty={quest.difficulty} />
        <span className="text-gold text-xs font-medium ml-auto">
          {quest.xp_reward} XP
        </span>
      </div>

      {quest.quest_type === "daily" && quest.current_streak > 0 && (
        <div className="text-xs text-parchment-muted border-t border-tavern-border pt-2">
          🔥 {quest.current_streak} day streak
        </div>
      )}
    </div>
  );
}
