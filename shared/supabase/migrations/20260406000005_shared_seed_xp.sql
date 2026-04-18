-- ============================================================
-- Shared Migration 5: XP Threshold Seed Data
-- D&D-inspired curve, 20 levels.
-- ============================================================

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
