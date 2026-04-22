"use client";

import Link from "next/link";
import { useState } from "react";

const APPS = [
  {
    id: "questify",
    kanji: "冒",
    romaji: "bōken",
    name: "Questify",
    desc: "Turn daily habits into epic quests",
    href: "/hub/questify/quests",
    accent: "#b83c3c",
  },
  {
    id: "omoi",
    kanji: "想",
    romaji: "omoi",
    name: "Omoi",
    desc: "Capture thoughts, ideas, and insights",
    href: "/hub/omoi/dashboard",
    accent: "#3d5a9e",
    extensionHref: "/hub/omoi/chrome-extension",
  },
  {
    id: "profile",
    kanji: "人",
    romaji: "hito",
    name: "Profile",
    desc: "Manage your account and character",
    href: "/hub/user-management",
    accent: "#b07030",
  },
];

function AppCard({ app }: { app: (typeof APPS)[number] }) {
  const [hov, setHov] = useState(false);

  return (
    <div className="relative">
      <Link
        href={app.href}
        onMouseEnter={() => setHov(true)}
        onMouseLeave={() => setHov(false)}
        className="block relative overflow-hidden rounded p-7 flex flex-col gap-4"
        style={{
          background: hov ? "#faf8f3" : "#f5f0e8",
          border: `1px solid ${hov ? app.accent : "#d0c4b0"}`,
          transition: "border-color 0.2s, background 0.2s",
        }}
      >
        {/* Kanji watermark */}
        <div
          className="absolute top-[-6px] right-3 pointer-events-none select-none font-display leading-none"
          style={{
            fontSize: 80,
            color: hov ? app.accent : "#e2dbd0",
            opacity: hov ? 0.15 : 0.6,
            transition: "color 0.2s, opacity 0.2s",
          }}
        >
          {app.kanji}
        </div>

        <div>
          <div
            className="font-mono text-[11px] tracking-[0.12em] mb-1.5"
            style={{ color: "#9c8c78" }}
          >
            {app.romaji}
          </div>
          <div
            className="font-mono text-lg tracking-[0.06em]"
            style={{
              color: hov ? app.accent : "#1c1612",
              transition: "color 0.2s",
            }}
          >
            {app.name}
          </div>
        </div>

        <div
          className="font-mono text-[11px] leading-relaxed"
          style={{ color: "#5c4f3d" }}
        >
          {app.desc}
        </div>

        <div
          className="font-mono text-[10px] tracking-[0.1em]"
          style={{
            color: hov ? app.accent : "#9c8c78",
            transition: "color 0.2s",
          }}
        >
          {hov ? "enter →" : "· · ·"}
        </div>
      </Link>

      {app.extensionHref && (
        <Link
          href={app.extensionHref}
          className="absolute bottom-3 right-3 font-mono text-[10px] tracking-wider"
          style={{ color: "#9c8c78" }}
        >
          Get Extension →
        </Link>
      )}
    </div>
  );
}

export default function LauncherDashboard() {
  return (
    <div className="min-h-screen bg-paper flex flex-col items-center justify-center px-6 py-12">
      {/* Logo */}
      <div className="text-center mb-16">
        <div className="font-display text-[11px] text-ink-3 tracking-[0.3em] uppercase mb-3">
          黒ラボ
        </div>
        <div className="font-mono text-[28px] text-ink-1 tracking-[0.2em] uppercase">
          KUROLABS
        </div>
        <div className="mx-auto mt-4 h-px bg-paper-border" style={{ width: 48 }} />
      </div>

      {/* App grid */}
      <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 w-full" style={{ maxWidth: 900 }}>
        {APPS.map((app) => (
          <AppCard key={app.id} app={app} />
        ))}
      </div>

      {/* Footer */}
      <div className="mt-16 font-mono text-[10px] text-ink-3 tracking-[0.15em]">
        v 0.1 · choose your path
      </div>
    </div>
  );
}
