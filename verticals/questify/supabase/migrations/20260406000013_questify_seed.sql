-- ============================================================
-- Questify Migration 4: System Epic Seed Data
-- ============================================================

insert into public.epics (user_id, name, description, icon_name, color_hex, ability_score, is_system) values
  (null, 'Fitness & Strength',      'Physical training, exercise, and athletic feats',    'fitness',    '#8B4513', 'str',       true),
  (null, 'Agility & Movement',      'Flexibility, coordination, and movement practices',  'agility',    '#2D5016', 'dex',       true),
  (null, 'Health & Endurance',      'Nutrition, sleep, medical care, and wellness',        'health',     '#1A3A5C', 'con',       true),
  (null, 'Learning & Study',        'Books, courses, skills acquisition, and research',   'learning',   '#4A2C6E', 'int_score', true),
  (null, 'Mind & Wisdom',           'Meditation, mindfulness, journaling, and reflection','mind',       '#5C4A1A', 'wis',       true),
  (null, 'Social & Communication',  'Relationships, socializing, networking, and empathy','social',     '#8B1A1A', 'cha',       true),
  (null, 'Home & Order',            'Cleaning, organising, maintenance, and home care',   'home',       '#3A5C3A', 'con',       true);
