import Image from "next/image";
import Link from "next/link";
import type { NpcQuestGiver } from "../../lib/types";

type NpcWithConnection = NpcQuestGiver & { is_connected: boolean };

export default function NpcCard({ npc }: { npc: NpcWithConnection }) {
  return (
    <Link href={`/hub/questify/village/${npc.slug}`}>
      <div
        className="bg-paper-raised rounded-[4px] overflow-hidden transition-colors cursor-pointer group"
        style={{ border: `1px solid ${npc.is_connected ? "var(--accent)" : "var(--paper-border)"}` }}
      >
        <div className="h-[200px] bg-paper-sunken overflow-hidden">
          <Image
            src={`/images/npc/${npc.image_filename}`}
            alt={npc.name}
            width={200}
            height={200}
            className="w-full h-full object-cover object-top"
            unoptimized
          />
        </div>

        <div className="p-[14px]">
          <div className="text-ink-1 text-[11px] tracking-[.04em] mb-0.5 truncate">{npc.name}</div>
          <div className="text-ink-3 text-[10px] tracking-[.06em] mb-3 truncate">{npc.category}</div>

          {npc.is_connected && (
            <div className="text-[10px] text-accent tracking-[.04em]">connected ✓</div>
          )}
        </div>
      </div>
    </Link>
  );
}
