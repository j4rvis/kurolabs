"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";

const links = [
  { href: "/hub/questify/quests", label: "Quest Board" },
  { href: "/hub/questify/village", label: "Village" },
];

export default function NavLinks() {
  const pathname = usePathname();

  return (
    <div className="flex items-center gap-0">
      {links.map((link) => {
        const active = pathname.startsWith(link.href);
        return (
          <Link
            key={link.href}
            href={link.href}
            className={`px-4 py-[18px] text-[11px] tracking-[.06em] transition-colors border-b-2 ${
              active
                ? "text-accent border-accent"
                : "text-ink-3 border-transparent hover:text-ink-2"
            }`}
          >
            {link.label}
          </Link>
        );
      })}
    </div>
  );
}
