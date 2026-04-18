-- ============================================================
-- Migration 5: Village NPC Quest Givers
-- ============================================================

-- System-defined NPC quest givers
create table public.npc_quest_givers (
  id             uuid primary key default gen_random_uuid(),
  slug           text unique not null,
  name           text not null,
  title          text not null,
  category       text not null,
  description    text not null,
  image_filename text not null,
  sort_order     int not null default 0,
  created_at     timestamptz not null default now()
);

-- Template quests per NPC
create table public.npc_quest_templates (
  id          uuid primary key default gen_random_uuid(),
  npc_id      uuid not null references public.npc_quest_givers(id) on delete cascade,
  title       text not null,
  description text,
  frequency   text not null check (frequency in ('daily', 'weekly', 'monthly', 'one_time')),
  difficulty  text not null default 'easy' check (difficulty in ('trivial','easy','medium','hard','deadly','legendary')),
  xp_reward   int not null default 50,
  sort_order  int not null default 0,
  created_at  timestamptz not null default now()
);

-- User connections to NPC quest givers
create table public.user_npc_connections (
  id           uuid primary key default gen_random_uuid(),
  user_id      uuid not null references auth.users(id) on delete cascade,
  npc_id       uuid not null references public.npc_quest_givers(id) on delete cascade,
  connected_at timestamptz not null default now(),
  unique (user_id, npc_id)
);

-- Link quests back to the NPC quest giver and template that spawned them
alter table public.quests
  add column npc_quest_giver_id uuid references public.npc_quest_givers(id) on delete set null,
  add column npc_template_id    uuid references public.npc_quest_templates(id) on delete set null;

-- Indexes
create index on public.npc_quest_templates (npc_id);
create index on public.user_npc_connections (user_id);
create index on public.quests (npc_quest_giver_id);

-- ============================================================
-- RLS
-- ============================================================

alter table public.npc_quest_givers    enable row level security;
alter table public.npc_quest_templates enable row level security;
alter table public.user_npc_connections enable row level security;

-- NPCs and templates are globally readable
create policy "npc_givers_read"    on public.npc_quest_givers    for select to authenticated using (true);
create policy "npc_templates_read" on public.npc_quest_templates for select to authenticated using (true);

-- Connections: users own their rows
create policy "npc_connections_select" on public.user_npc_connections for select to authenticated using (auth.uid() = user_id);
create policy "npc_connections_insert" on public.user_npc_connections for insert to authenticated with check (auth.uid() = user_id);
create policy "npc_connections_delete" on public.user_npc_connections for delete to authenticated using (auth.uid() = user_id);

-- ============================================================
-- Seed: NPC Quest Givers (17, matching available portrait images)
-- ============================================================

insert into public.npc_quest_givers (slug, name, title, category, description, image_filename, sort_order) values
  ('bronn-ironveil',     'Bronn Ironveil',     'The Training Master',         'Fitness & Strength',      'A battle-scarred half-orc warrior who runs the open-air training yard. He believes discipline of the body is the foundation of all greatness.',                'Fitness_Bronn Ironveil.png',         1),
  ('brother-ashveil',    'Brother Ashveil',     'The Calm Keeper',             'Mindfulness & Meditation', 'An elderly monk who tends a monastery garden. He teaches that stillness is itself a form of strength.',                                                     'Mindfulness_Brother Ashveil.png',    2),
  ('elspeth-inkwell',    'Elspeth Inkwell',     'The Loremaster',              'Reading & Learning',       'A sharp-eyed halfling scholar surrounded by towering bookshelves. She believes knowledge is the greatest treasure one can accumulate.',                     'Reading_Elspeth Inkwell.png',        3),
  ('oriole-greenbloom',  'Oriole Greenbloom',   'The Herbalist Nutritionist',  'Hydration & Nutrition',    'A cheerful wood elf herbalist whose bright kitchen overflows with fresh produce and healing potions. She preaches that what you consume shapes your fate.',  'Nutrition_Oriole Greenbloom.png',    4),
  ('mabel-cozymoor',     'Mabel Cozymoor',      'The Innkeeper of Rest',       'Sleep & Recovery',         'A motherly halfling innkeeper who keeps the warmest beds in the village. She insists that true power comes from proper rest.',                               'Sleep_Mabel Cozymoor.png',           5),
  ('sibyl-morterstone',  'Sibyl Morterstone',   'The Apothecary',              'Health & Medical',         'A warm halfling herbalist who runs the apothecary shop. She is the village''s first line of defence against ill health.',                                   'Health_Sibyl Morterstone.png',       6),
  ('aldric-goldledger',  'Aldric Goldledger',   'The Coin Counter',            'Finance & Bills',          'A precise gnome banker who runs the village counting house. He believes a well-managed purse is the mark of a true adventurer.',                            'Finance_Aldric Goldledger.png',      7),
  ('luca-brightstring',  'Luca Brightstring',   'The Messenger Bard',          'Social & Communication',   'A charming tiefling bard who carries letters and stories alike. He knows that the strength of one''s connections is worth more than gold.',                 'Social_Luca Brightstring.png',       8),
  ('rowena-pawsworth',   'Rowena Pawsworth',    'The Beast Tender',            'Pet Care',                 'A gentle halfling animal keeper whose stable is always full of creatures great and small. She believes caring for animals builds character.',                'Pet_Rowena Pawsworth.png',           9),
  ('cog-sparklefuse',    'Cog Sparklefuse',     'The Clockwork Artificer',     'Tech & Digital',           'An eccentric gnome artificer whose workshop hums with mechanical curiosity. She tackles any device-related challenge with wide-eyed enthusiasm.',           'Tech_Cog Sparklefuse.png',          10),
  ('pip-quickpocket',    'Pip Quickpocket',     'The Market Runner',           'Errands & Shopping',       'An energetic gnome merchant who knows every stall in the market. She can source anything you need and gets it done before lunch.',                          'Errands_Pip-Quickpocket.png',       11),
  ('wren-soapstone',     'Wren Soapstone',      'The Launderer',               'Household Cleaning',       'A cheerful gnome whose wash yard is always busy. He takes great pride in a home kept spotless, soap suds and all.',                                        'Household_Wren Soapstone.png',      12),
  ('durgin-ironknuckle', 'Durgin Ironknuckle',  'The Handyman',                'Home Maintenance',         'A gruff but kind dwarf craftsman with sawdust perpetually in his beard. Nothing stays broken for long when Durgin is on the job.',                         'Maintenance_Durgin Ironknuckle.png',13),
  ('finn-quillmark',     'Finn Quillmark',      'The Chronicler',              'Journaling & Writing',     'A thoughtful young scribe with ink-stained fingers who believes every life deserves to be written down. He assigns quests to help you tell your story.',   'Writing_Finn Quillmark.png',        14),
  ('seb-clearstone',     'Seb Clearstone',      'The Organizer',               'Organization & Decluttering','A calm and methodical halfling who runs the most orderly storage room in the village. He teaches that a tidy space leads to a tidy mind.',               'Organization_Seb Clearstone.png',   15),
  ('barnaby-crust',      'Barnaby Crust',       'The Baker',                   'Cooking & Baking',         'A cheerful halfling baker whose warm loaves and iced cakes draw a crowd every morning. He believes cooking for yourself is an act of self-respect.',         'Cooking_Barnaby Crust.png',         16),
  ('mira-seedwhisper',   'Mira Seedwhisper',    'The Gardener',                'Gardening',                'A warm gnome gardener who tends lush vegetable beds and trellised vines. She says that patience in the garden teaches patience in life.',                    'Gardening_Mira Seedwhisper.png',    17);

-- ============================================================
-- Seed: NPC Quest Templates (3–4 per NPC, covering all frequencies)
-- ============================================================

-- Bronn Ironveil — Fitness & Strength
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Complete today''s workout', 'Show up and put in the work. A warrior is forged in the daily grind.', 'daily', 'medium', 100, 1 from public.npc_quest_givers where slug = 'bronn-ironveil';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Hit four or more workouts this week', 'Consistency is the mark of a true warrior. Four sessions minimum.', 'weekly', 'hard', 250, 2 from public.npc_quest_givers where slug = 'bronn-ironveil';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Set a new personal record', 'Push past your limits and set a benchmark for the next challenger to beat.', 'monthly', 'deadly', 500, 3 from public.npc_quest_givers where slug = 'bronn-ironveil';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Complete a 30-day fitness challenge', 'Commit for a full month. Prove to yourself what you are made of.', 'one_time', 'legendary', 1000, 4 from public.npc_quest_givers where slug = 'bronn-ironveil';

-- Brother Ashveil — Mindfulness & Meditation
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Ten minutes of meditation', 'Sit. Breathe. Let the noise of the world pass by like clouds.', 'daily', 'trivial', 25, 1 from public.npc_quest_givers where slug = 'brother-ashveil';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Five mindfulness sessions this week', 'Return to stillness five times this week. The mind is a muscle.', 'weekly', 'easy', 50, 2 from public.npc_quest_givers where slug = 'brother-ashveil';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Try a new mindfulness technique', 'Body scan, loving-kindness, breathwork — explore a practice you have never tried.', 'monthly', 'medium', 100, 3 from public.npc_quest_givers where slug = 'brother-ashveil';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Build a 21-day meditation streak', 'Twenty-one days without missing a session. That is where the habit takes root.', 'one_time', 'hard', 250, 4 from public.npc_quest_givers where slug = 'brother-ashveil';

-- Elspeth Inkwell — Reading & Learning
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Read for twenty minutes', 'Open a book. Any book. The door to knowledge is never locked.', 'daily', 'trivial', 25, 1 from public.npc_quest_givers where slug = 'elspeth-inkwell';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Finish a chapter or article', 'Complete a unit of learning this week. Fragments do not build understanding.', 'weekly', 'easy', 50, 2 from public.npc_quest_givers where slug = 'elspeth-inkwell';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Finish a book this month', 'See it through to the last page. A book left unfinished is a debt unpaid.', 'monthly', 'medium', 100, 3 from public.npc_quest_givers where slug = 'elspeth-inkwell';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Read twelve books in a year', 'One a month for twelve months. A Loremaster''s minimum.', 'one_time', 'legendary', 1000, 4 from public.npc_quest_givers where slug = 'elspeth-inkwell';

-- Oriole Greenbloom — Hydration & Nutrition
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Drink eight glasses of water today', 'Your body is mostly water. Treat it accordingly.', 'daily', 'trivial', 25, 1 from public.npc_quest_givers where slug = 'oriole-greenbloom';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Eat five servings of fruit and vegetables', 'Colour your plate. Nature''s medicine comes in many shades.', 'daily', 'easy', 50, 2 from public.npc_quest_givers where slug = 'oriole-greenbloom';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Meal prep for the week ahead', 'Spend one session preparing meals so that good choices come easily all week.', 'weekly', 'medium', 100, 3 from public.npc_quest_givers where slug = 'oriole-greenbloom';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Complete a 30-day clean eating challenge', 'Thirty days of intentional nourishment. Your future self will feel the difference.', 'one_time', 'legendary', 1000, 4 from public.npc_quest_givers where slug = 'oriole-greenbloom';

-- Mabel Cozymoor — Sleep & Recovery
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Be in bed by your target bedtime', 'The hearth is warm and the pillow is waiting. No more excuses.', 'daily', 'trivial', 25, 1 from public.npc_quest_givers where slug = 'mabel-cozymoor';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Keep a consistent sleep schedule for seven days', 'Same time to bed, same time to rise. The body loves routine.', 'weekly', 'medium', 100, 2 from public.npc_quest_givers where slug = 'mabel-cozymoor';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Track and improve your sleep quality this month', 'Log your sleep and find one thing to improve. Rest is not optional for adventurers.', 'monthly', 'hard', 250, 3 from public.npc_quest_givers where slug = 'mabel-cozymoor';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Establish a perfect bedtime routine', 'Herbal tea, dim lights, no scrolls before sleeping. Build the ritual once and keep it forever.', 'one_time', 'medium', 100, 4 from public.npc_quest_givers where slug = 'mabel-cozymoor';

-- Sibyl Morterstone — Health & Medical
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Take all medications and supplements', 'Not optional. Your health regimen only works if you stick to it.', 'daily', 'easy', 50, 1 from public.npc_quest_givers where slug = 'sibyl-morterstone';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Schedule or attend a health appointment', 'Prevention is cheaper than cure. Do not wait until the ailment grows.', 'monthly', 'medium', 100, 2 from public.npc_quest_givers where slug = 'sibyl-morterstone';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Get your annual physical done', 'A full audit of the vessel that carries you through life. Do not skip it.', 'one_time', 'hard', 250, 3 from public.npc_quest_givers where slug = 'sibyl-morterstone';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Establish a health tracking routine', 'Weight, blood pressure, steps — pick your metrics and check them regularly.', 'one_time', 'medium', 100, 4 from public.npc_quest_givers where slug = 'sibyl-morterstone';

-- Aldric Goldledger — Finance & Bills
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Review your weekly spending', 'Where did the coin go? Check your ledger and hold yourself accountable.', 'weekly', 'easy', 50, 1 from public.npc_quest_givers where slug = 'aldric-goldledger';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Pay all bills on time this month', 'Late fees are a tax on disorganisation. Pay promptly.', 'monthly', 'medium', 100, 2 from public.npc_quest_givers where slug = 'aldric-goldledger';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Update your budget and savings plan', 'Review the numbers and adjust. A plan that never changes is already obsolete.', 'monthly', 'medium', 100, 3 from public.npc_quest_givers where slug = 'aldric-goldledger';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Set up an emergency fund', 'Three months of expenses, locked away. The greatest peace of mind coin can buy.', 'one_time', 'hard', 250, 4 from public.npc_quest_givers where slug = 'aldric-goldledger';

-- Luca Brightstring — Social & Communication
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Reach out to one person today', 'Send the message. Make the call. Connection begins with a single word.', 'daily', 'trivial', 25, 1 from public.npc_quest_givers where slug = 'luca-brightstring';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Have a meaningful conversation this week', 'Not small talk — a real exchange. Something that matters to both of you.', 'weekly', 'easy', 50, 2 from public.npc_quest_givers where slug = 'luca-brightstring';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Plan and attend a social gathering', 'Bring people together this month. Even a small gathering fills the spirit.', 'monthly', 'medium', 100, 3 from public.npc_quest_givers where slug = 'luca-brightstring';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Reconnect with someone you''ve lost touch with', 'There is someone who would love to hear from you. You know who it is.', 'one_time', 'hard', 250, 4 from public.npc_quest_givers where slug = 'luca-brightstring';

-- Rowena Pawsworth — Pet Care
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Feed and care for your pet', 'Your companion depends on you entirely. Do not let them down.', 'daily', 'trivial', 25, 1 from public.npc_quest_givers where slug = 'rowena-pawsworth';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Give your pet extra attention and playtime', 'Beyond the basics — spend quality time this week. They notice more than you think.', 'weekly', 'easy', 50, 2 from public.npc_quest_givers where slug = 'rowena-pawsworth';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Schedule or attend a vet visit', 'A healthy companion is a happy companion. Keep those checkups regular.', 'monthly', 'medium', 100, 3 from public.npc_quest_givers where slug = 'rowena-pawsworth';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Set up a complete pet care routine', 'Feeding times, grooming schedule, enrichment plan. Put it all in writing.', 'one_time', 'medium', 100, 4 from public.npc_quest_givers where slug = 'rowena-pawsworth';

-- Cog Sparklefuse — Tech & Digital
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Do a digital declutter', 'Delete files, unsubscribe from lists, archive old emails. Clear the cache of your life.', 'weekly', 'easy', 50, 1 from public.npc_quest_givers where slug = 'cog-sparklefuse';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Learn a new tech skill or shortcut', 'Sharpen your tools. Even one small improvement compounds over time.', 'weekly', 'medium', 100, 2 from public.npc_quest_givers where slug = 'cog-sparklefuse';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Back up all important files this month', 'The disaster you do not prepare for is the one that costs everything.', 'monthly', 'medium', 100, 3 from public.npc_quest_givers where slug = 'cog-sparklefuse';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Set up a complete backup system', '3-2-1 rule: three copies, two media types, one offsite. Do it once, do it right.', 'one_time', 'hard', 250, 4 from public.npc_quest_givers where slug = 'cog-sparklefuse';

-- Pip Quickpocket — Errands & Shopping
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Complete one errand today', 'Pick the task that has been sitting on the list longest. Off it goes.', 'daily', 'trivial', 25, 1 from public.npc_quest_givers where slug = 'pip-quickpocket';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Do your weekly shopping run', 'Stocked shelves mean fewer bad decisions. Get the essentials before you run out.', 'weekly', 'easy', 50, 2 from public.npc_quest_givers where slug = 'pip-quickpocket';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Clear your errand backlog this month', 'That ever-growing list deserves a reckoning. Knock it all out in one month.', 'monthly', 'medium', 100, 3 from public.npc_quest_givers where slug = 'pip-quickpocket';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Set up a weekly errand system', 'Batch, schedule, delegate. Build a repeatable process so nothing slips through.', 'one_time', 'medium', 100, 4 from public.npc_quest_givers where slug = 'pip-quickpocket';

-- Wren Soapstone — Household Cleaning
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Wash up and tidy the kitchen', 'A clean kitchen is a clean mind. Start here every day.', 'daily', 'trivial', 25, 1 from public.npc_quest_givers where slug = 'wren-soapstone';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Deep clean one room this week', 'Corners, surfaces, and all. Give one room your full attention.', 'weekly', 'easy', 50, 2 from public.npc_quest_givers where slug = 'wren-soapstone';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Full household reset', 'Top to bottom, every room. Once a month the whole place gets the treatment.', 'monthly', 'hard', 250, 3 from public.npc_quest_givers where slug = 'wren-soapstone';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Establish a cleaning routine', 'Write down what gets cleaned and when. A schedule makes it effortless.', 'one_time', 'medium', 100, 4 from public.npc_quest_givers where slug = 'wren-soapstone';

-- Durgin Ironknuckle — Home Maintenance
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Fix one thing that has been broken', 'The leaky tap, the squeaky hinge — pick one and put it right this week.', 'weekly', 'medium', 100, 1 from public.npc_quest_givers where slug = 'durgin-ironknuckle';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Home inspection and maintenance check', 'Walk through every room with a critical eye. Catch the small problems before they grow.', 'monthly', 'hard', 250, 2 from public.npc_quest_givers where slug = 'durgin-ironknuckle';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Complete a major home repair project', 'The big one. The project you have been putting off. Time to get your hands dirty.', 'one_time', 'deadly', 500, 3 from public.npc_quest_givers where slug = 'durgin-ironknuckle';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Build something for your home', 'Shelves, a workbench, a planter box — make something with your own hands.', 'one_time', 'hard', 250, 4 from public.npc_quest_givers where slug = 'durgin-ironknuckle';

-- Finn Quillmark — Journaling & Writing
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Write a journal entry today', 'Ink your day into permanence. Even a single sentence counts.', 'daily', 'trivial', 25, 1 from public.npc_quest_givers where slug = 'finn-quillmark';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Complete a creative writing piece', 'A short story, a poem, a scene — finish something this week.', 'weekly', 'medium', 100, 2 from public.npc_quest_givers where slug = 'finn-quillmark';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Review and reflect on the past month', 'Read back through your entries. What did you learn? What changed?', 'monthly', 'easy', 50, 3 from public.npc_quest_givers where slug = 'finn-quillmark';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Write and finish a short story', 'Beginning, middle, end — a complete story, however short. Finish what you start.', 'one_time', 'hard', 250, 4 from public.npc_quest_givers where slug = 'finn-quillmark';

-- Seb Clearstone — Organization & Decluttering
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Organise one area or drawer', 'One drawer, one shelf, one corner. Small wins build the habit.', 'weekly', 'easy', 50, 1 from public.npc_quest_givers where slug = 'seb-clearstone';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Clear your inbox and to-do list', 'Nothing pending, nothing lurking. Start the week with a clean slate.', 'weekly', 'medium', 100, 2 from public.npc_quest_givers where slug = 'seb-clearstone';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Declutter and donate unused items', 'Once a month, let go of things you no longer need. Others will use what you hoard.', 'monthly', 'hard', 250, 3 from public.npc_quest_givers where slug = 'seb-clearstone';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Set up an organisation system for your home', 'A place for everything, and everything in its place. Build the system once.', 'one_time', 'legendary', 1000, 4 from public.npc_quest_givers where slug = 'seb-clearstone';

-- Barnaby Crust — Cooking & Baking
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Cook a meal from scratch today', 'No parcels, no packets. Real ingredients, real effort, real satisfaction.', 'daily', 'easy', 50, 1 from public.npc_quest_givers where slug = 'barnaby-crust';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Try a new recipe this week', 'Step outside your usual rotation. A cook who stops experimenting stops growing.', 'weekly', 'medium', 100, 2 from public.npc_quest_givers where slug = 'barnaby-crust';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Bake something and share it', 'Food made with care and given freely — that is the highest use of your kitchen.', 'monthly', 'hard', 250, 3 from public.npc_quest_givers where slug = 'barnaby-crust';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Master your signature dish', 'One dish, perfected. The one you can make in your sleep and everyone asks for by name.', 'one_time', 'legendary', 1000, 4 from public.npc_quest_givers where slug = 'barnaby-crust';

-- Mira Seedwhisper — Gardening
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Water your plants today', 'Thirsty roots, thirsty roots. A minute''s attention, a week''s gratitude.', 'daily', 'trivial', 25, 1 from public.npc_quest_givers where slug = 'mira-seedwhisper';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Weed and tend your garden this week', 'Pull the uninvited guests. Give your plants the space they deserve.', 'weekly', 'easy', 50, 2 from public.npc_quest_givers where slug = 'mira-seedwhisper';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Plant something new this month', 'Every garden deserves a new resident. Seeds, cuttings, or seedlings — add something.', 'monthly', 'medium', 100, 3 from public.npc_quest_givers where slug = 'mira-seedwhisper';
insert into public.npc_quest_templates (npc_id, title, description, frequency, difficulty, xp_reward, sort_order)
select id, 'Establish a dedicated garden bed', 'Raised bed, container garden, or a plot in the ground — make a proper space for growing.', 'one_time', 'hard', 250, 4 from public.npc_quest_givers where slug = 'mira-seedwhisper';
