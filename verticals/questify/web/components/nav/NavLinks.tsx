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
    <div className="flex items-center gap-1">
      {links.map((link) => {
        const active = pathname.startsWith(link.href);
        return (
          <Link
            key={link.href}
            href={link.href}
            className={`px-3 py-1.5 rounded text-sm transition-colors ${
              active
                ? "text-gold bg-tavern-mid"
                : "text-parchment hover:text-gold hover:bg-tavern-mid"
            }`}
          >
            {link.label}
          </Link>
        );
      })}
    </div>
  );
}
