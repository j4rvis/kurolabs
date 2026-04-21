import { createClient } from 'jsr:@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SUPABASE_SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

// ── keyword → category heuristics ────────────────────────────────────────────

const CATEGORY_PATTERNS: Array<{ category: string; patterns: RegExp[] }> = [
  {
    category: 'question',
    patterns: [/\?$/, /\bwhy\b/i, /\bhow\b/i, /\bwhat\b/i, /\bwhen\b/i, /\bwhere\b/i, /\bwho\b/i],
  },
  {
    category: 'reminder',
    patterns: [/\bremember\b/i, /\bdon'?t forget\b/i, /\bneed to\b/i, /\bmust\b/i, /\bshould\b/i, /\btodo\b/i],
  },
  {
    category: 'insight',
    patterns: [/\brealize[d]?\b/i, /\bnotice[d]?\b/i, /\bunderstand\b/i, /\blearn(ed)?\b/i, /\binsight\b/i, /\bkey\b/i],
  },
  {
    category: 'idea',
    patterns: [/\bidea\b/i, /\bwhat if\b/i, /\bcould\b/i, /\bmaybe\b/i, /\bpossibly\b/i, /\blet'?s\b/i],
  },
];

function classifyCategory(content: string): string {
  for (const { category, patterns } of CATEGORY_PATTERNS) {
    if (patterns.some((p) => p.test(content))) return category;
  }
  return 'other';
}

// ── tag extraction ────────────────────────────────────────────────────────────

// Extracts #hashtags and significant capitalized words/phrases
function extractTags(content: string): string[] {
  const tags = new Set<string>();

  // Explicit #hashtags
  const hashtags = content.match(/#([a-zA-Z][a-zA-Z0-9_-]*)/g);
  if (hashtags) {
    for (const tag of hashtags) tags.add(tag.slice(1).toLowerCase());
  }

  // Capitalized sequences (proper nouns / named concepts), excluding sentence start
  const sentences = content.split(/(?<=[.!?])\s+/);
  for (const sentence of sentences) {
    const words = sentence.trim().split(/\s+/);
    for (let i = 1; i < words.length; i++) {
      const word = words[i].replace(/[^a-zA-Z]/g, '');
      if (word.length > 2 && word[0] === word[0].toUpperCase() && word[0] !== word[0].toLowerCase()) {
        tags.add(word.toLowerCase());
      }
    }
  }

  return Array.from(tags).slice(0, 10); // cap at 10 tags
}

// ── handler ───────────────────────────────────────────────────────────────────

Deno.serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('Method Not Allowed', { status: 405 });
  }

  let thought_id: string;
  try {
    ({ thought_id } = await req.json());
  } catch {
    return new Response('Invalid JSON', { status: 400 });
  }

  if (!thought_id) {
    return new Response('Missing thought_id', { status: 400 });
  }

  const supabase = createClient(SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY);

  const { data: thought, error: fetchError } = await supabase
    .from('thoughts')
    .select('id, content, category, tags')
    .eq('id', thought_id)
    .single();

  if (fetchError || !thought) {
    return new Response('Thought not found', { status: 404 });
  }

  const category = classifyCategory(thought.content);
  const tags = extractTags(thought.content);

  const { error: updateError } = await supabase
    .from('thoughts')
    .update({ category, tags })
    .eq('id', thought_id);

  if (updateError) {
    console.error('Failed to update thought:', updateError);
    return new Response('Update failed', { status: 500 });
  }

  return Response.json({ thought_id, category, tags });
});
