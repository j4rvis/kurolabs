import Link from "next/link";

const verticals = [
  {
    name: "Questify",
    description: "Turn your daily habits into epic quests",
    href: "/hub/questify/quests",
    icon: "⚔️",
    color: "bg-tavern-mid border-tavern-border",
  },
  {
    name: "User Management",
    description: "Manage your profile, account, and character",
    href: "/hub/user-management",
    icon: "👤",
    color: "bg-tavern-mid border-tavern-border",
  },
];

export default function LauncherDashboard() {
  return (
    <div className="min-h-screen bg-tavern px-4 py-12">
      <div className="max-w-4xl mx-auto">
        <div className="text-center mb-12">
          <h1 className="font-display text-4xl text-gold tracking-widest mb-3">
            KUROLABS
          </h1>
          <p className="text-parchment-muted text-sm">Choose your adventure</p>
        </div>

        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
          {verticals.map((v) => (
            <Link
              key={v.name}
              href={v.href}
              className={`${v.color} border rounded-lg p-6 flex flex-col gap-3 hover:border-gold transition-colors`}
            >
              <span className="text-4xl">{v.icon}</span>
              <div>
                <h2 className="font-display text-lg text-gold tracking-wide">
                  {v.name}
                </h2>
                <p className="text-parchment-muted text-sm mt-1">
                  {v.description}
                </p>
              </div>
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}
