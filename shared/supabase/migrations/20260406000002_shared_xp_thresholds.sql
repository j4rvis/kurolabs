-- ============================================================
-- Shared Migration 2: XP Level Thresholds
-- D&D-inspired 20-level progression used by all verticals.
-- ============================================================

create table public.xp_thresholds (
  level     int primary key,
  xp_needed bigint not null,
  title     text not null
);
