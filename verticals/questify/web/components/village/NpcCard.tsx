import Image from "next/image";
import Link from "next/link";
import type { NpcQuestGiver } from "../../lib/types";

type NpcWithConnection = NpcQuestGiver & { is_connected: boolean };

export default function NpcCard({ npc }: { npc: NpcWithConnection }) {
  return (
    <Link href={`/hub/questify/village/${npc.slug}`}>
      <div className="bg-tavern-light border border-tavern-border rounded-lg p-4 flex flex-col items-center gap-3 hover:border-gold/50 transition-colors cursor-pointer group">
        <div className="relative w-20 h-20 rounded-full overflow-hidden border-2 border-tavern-border group-hover:border-gold/50 transition-colors bg-tavern-mid flex-shrink-0">
          <Image
            src={`/images/npc/${npc.image_filename}`}
            alt={npc.name}
            fill
            className="object-cover object-top"
            unoptimized
          />
        </div>

        <div className="text-center min-w-0 w-full">
          <h3 className="text-parchment text-sm font-medium leading-tight truncate">
            {npc.name}
          </h3>
          <p className="text-parchment-muted text-xs mt-0.5 truncate">
            {npc.title}
          </p>
          <p className="text-gold/70 text-xs mt-1 truncate">{npc.category}</p>
        </div>

        {npc.is_connected && (
          <div className="flex items-center gap-1.5 text-xs text-[#52be80]">
            <span className="w-1.5 h-1.5 rounded-full bg-[#52be80] inline-block" />
            Connected
          </div>
        )}
      </div>
    </Link>
  );
}
