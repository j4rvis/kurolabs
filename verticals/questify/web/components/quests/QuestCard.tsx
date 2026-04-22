import type { Quest } from "../../lib/types";
import { DifficultyBadge, QuestTypeBadge } from "../ui/Badge";
import CompleteQuestButton from "./CompleteQuestButton";

type QuestWithNpc = Quest & {
  npc_quest_givers?: { name: string; image_filename: string } | null;
};

export default function QuestCard({ quest }: { quest: QuestWithNpc }) {
  return (
    <div className="bg-paper-raised border border-paper-border rounded-[4px] p-5 flex flex-col gap-3">
      <div className="flex items-start justify-between gap-3">
        <div className="flex-1 min-w-0">
          <h3 className="text-ink-1 text-[12px] tracking-[.03em] leading-snug">
            {quest.title}
          </h3>
          {quest.npc_quest_givers && (
            <p className="text-ink-3 text-[10px] tracking-[.04em] mt-0.5">
              {quest.npc_quest_givers.name}
            </p>
          )}
        </div>
        {quest.quest_type === "daily" && (
          <CompleteQuestButton questId={quest.id} />
        )}
      </div>

      {quest.description && (
        <p className="text-ink-3 text-[10px] leading-relaxed line-clamp-2">
          {quest.description}
        </p>
      )}

      <div className="flex items-center gap-[6px] flex-wrap border-t border-paper-divider pt-[10px]">
        <QuestTypeBadge type={quest.quest_type} />
        <DifficultyBadge difficulty={quest.difficulty} />
        <span className="text-accent text-[10px] tracking-[.06em] ml-auto">
          {quest.xp_reward} xp
        </span>
      </div>

      {quest.quest_type === "daily" && quest.current_streak > 0 && (
        <div className="text-[10px] text-ink-3">
          ↑ {quest.current_streak} day streak
        </div>
      )}
    </div>
  );
}
