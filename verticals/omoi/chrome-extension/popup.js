const SUPABASE_URL = 'https://kpmyutnnqliguzawcjvs.supabase.co';
const SESSION_KEY = 'omoi_session';
const OMOI_APP_URL = 'https://kurolabs.app/omoi/dashboard';

async function getSession() {
  const stored = await chrome.storage.local.get(SESSION_KEY);
  const session = stored[SESSION_KEY];
  if (!session?.access_token) return null;
  if (session.expires_at && Date.now() > session.expires_at - 60_000) return null;
  return session;
}

async function init() {
  const session = await getSession();
  const openAppLink = document.getElementById('open-app-link');
  openAppLink.href = OMOI_APP_URL;

  if (!session) {
    document.getElementById('not-logged-in').style.display = 'block';
    return;
  }

  document.getElementById('capture-form').style.display = 'block';

  const input = document.getElementById('thought-input');
  const btn = document.getElementById('submit-btn');
  const status = document.getElementById('status');

  async function submit() {
    const content = input.value.trim();
    if (!content) return;

    btn.disabled = true;
    status.className = '';
    status.textContent = 'Saving…';

    try {
      const res = await fetch(`${SUPABASE_URL}/rest/v1/thoughts`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'apikey': session.anon_key,
          'Authorization': `Bearer ${session.access_token}`,
          'Prefer': 'return=minimal',
        },
        body: JSON.stringify({ content }),
      });

      if (!res.ok) {
        const err = await res.json().catch(() => ({}));
        throw new Error(err.message || `HTTP ${res.status}`);
      }

      status.className = 'success';
      status.textContent = 'Thought captured!';
      input.value = '';
      setTimeout(() => window.close(), 1200);
    } catch (err) {
      status.className = 'error';
      status.textContent = `Error: ${err.message}`;
      btn.disabled = false;
    }
  }

  btn.addEventListener('click', submit);
  input.addEventListener('keydown', (e) => {
    if (e.key === 'Enter' && (e.metaKey || e.ctrlKey)) submit();
  });
}

document.addEventListener('DOMContentLoaded', init);
