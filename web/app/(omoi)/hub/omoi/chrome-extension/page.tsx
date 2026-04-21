export default function ChromeExtensionPage() {
  return (
    <div className="flex flex-col gap-8 py-4">
      <div>
        <h1 className="text-2xl font-semibold text-zinc-100 mb-2">Omoi Chrome Extension</h1>
        <p className="text-zinc-400 text-sm leading-relaxed">
          Capture thoughts from anywhere in your browser without switching tabs. The Omoi extension
          adds a popup where you can write down an idea, question, or reminder in seconds.
        </p>
      </div>

      <div className="bg-zinc-900 border border-zinc-800 rounded-lg p-6 flex flex-col gap-4">
        <h2 className="text-zinc-200 font-medium">Features</h2>
        <ul className="text-zinc-400 text-sm space-y-2">
          <li>⚡ One-click thought capture from any tab</li>
          <li>🔒 Authenticated via your Omoi session — no extra login</li>
          <li>🏷️ Thoughts are auto-tagged and categorized by the server</li>
          <li>⌘↵ Keyboard shortcut to submit instantly</li>
        </ul>
      </div>

      <div className="bg-zinc-900 border border-zinc-800 rounded-lg p-6 flex flex-col gap-4">
        <h2 className="text-zinc-200 font-medium">Install</h2>
        <div className="flex flex-col gap-3 text-sm text-zinc-400">
          <div className="flex items-start gap-3">
            <span className="text-violet-400 font-mono text-xs mt-0.5">1</span>
            <p>
              The extension is currently in development. You can{" "}
              <a
                href="https://github.com/kurolabs/kurolabs"
                target="_blank"
                rel="noopener noreferrer"
                className="text-violet-400 hover:underline"
              >
                download the source
              </a>{" "}
              and load it as an unpacked extension in Chrome.
            </p>
          </div>
          <div className="flex items-start gap-3">
            <span className="text-violet-400 font-mono text-xs mt-0.5">2</span>
            <p>Go to <code className="bg-zinc-800 px-1 rounded text-xs">chrome://extensions</code>, enable Developer Mode, and click "Load unpacked".</p>
          </div>
          <div className="flex items-start gap-3">
            <span className="text-violet-400 font-mono text-xs mt-0.5">3</span>
            <p>Select the <code className="bg-zinc-800 px-1 rounded text-xs">verticals/omoi/chrome-extension/</code> folder from the repo.</p>
          </div>
          <div className="flex items-start gap-3">
            <span className="text-violet-400 font-mono text-xs mt-0.5">4</span>
            <p>Log in to Omoi in this browser tab first — the extension reads your session automatically.</p>
          </div>
        </div>
      </div>

      <p className="text-zinc-600 text-xs">
        A Chrome Web Store listing is planned for a future release.
      </p>
    </div>
  );
}
