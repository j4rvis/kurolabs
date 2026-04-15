-- ============================================================
-- Migration 4: Seed Data (system epics + XP thresholds)
-- ============================================================

-- System epics (quest categories)
insert into public.epics (user_id, name, description, icon_name, color_hex, ability_score, is_system) values
  (null, 'Fitness & Strength',      'Physical training, exercise, and athletic feats',    'fitness',    '#8B4513', 'str',       true),
  (null, 'Agility & Movement',      'Flexibility, coordination, and movement practices',  'agility',    '#2D5016', 'dex',       true),
  (null, 'Health & Endurance',      'Nutrition, sleep, medical care, and wellness',        'health',     '#1A3A5C', 'con',       true),
  (null, 'Learning & Study',        'Books, courses, skills acquisition, and research',   'learning',   '#4A2C6E', 'int_score', true),
  (null, 'Mind & Wisdom',           'Meditation, mindfulness, journaling, and reflection','mind',       '#5C4A1A', 'wis',       true),
  (null, 'Social & Communication',  'Relationships, socializing, networking, and empathy','social',     '#8B1A1A', 'cha',       true),
  (null, 'Home & Order',            'Cleaning, organising, maintenance, and home care',   'home',       '#3A5C3A', 'con',       true);

-- XP level thresholds (D&D-inspired curve, 20 levels)
insert into public.xp_thresholds (level, xp_needed, title) values
  ( 1,       0, 'Novice Adventurer'),
  ( 2,     300, 'Apprentice'),
  ( 3,     900, 'Journeyman'),
  ( 4,    2700, 'Adventurer'),
  ( 5,    6500, 'Seasoned Adventurer'),
  ( 6,   14000, 'Seasoned Warrior'),
  ( 7,   23000, 'Veteran'),
  ( 8,   34000, 'Veteran Warrior'),
  ( 9,   48000, 'Battle-Hardened'),
  (10,   64000, 'Champion Aspirant'),
  (11,   85000, 'Champion'),
  (12,  100000, 'Renowned Champion'),
  (13,  120000, 'Hero'),
  (14,  140000, 'Renowned Hero'),
  (15,  165000, 'Epic Hero'),
  (16,  195000, 'Legendary Warrior'),
  (17,  225000, 'Legendary Champion'),
  (18,  265000, 'Mythic Hero'),
  (19,  305000, 'Demigod'),
  (20,  355000, 'Legendary Hero');
