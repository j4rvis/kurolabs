const SUPABASE_URL = 'https://kpmyutnnqliguzawcjvs.supabase.co';
const SESSION_KEY = 'omoi_session';

// Refresh session token before it expires
async function refreshSession() {
  const stored = await chrome.storage.local.get(SESSION_KEY);
  const session = stored[SESSION_KEY];
  if (!session?.refresh_token) return;

  try {
    const res = await fetch(`${SUPABASE_URL}/auth/v1/token?grant_type=refresh_token`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'apikey': session.anon_key },
      body: JSON.stringify({ refresh_token: session.refresh_token }),
    });
    if (!res.ok) {
      await chrome.storage.local.remove(SESSION_KEY);
      return;
    }
    const data = await res.json();
    await chrome.storage.local.set({
      [SESSION_KEY]: {
        ...session,
        access_token: data.access_token,
        refresh_token: data.refresh_token,
        expires_at: Date.now() + data.expires_in * 1000,
      },
    });
  } catch {
    // Network error — will retry next alarm
  }
}

chrome.alarms.create('session-refresh', { periodInMinutes: 50 });
chrome.alarms.onAlarm.addListener((alarm) => {
  if (alarm.name === 'session-refresh') refreshSession();
});
