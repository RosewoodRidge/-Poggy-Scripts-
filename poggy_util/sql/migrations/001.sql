-- poggy: only-if-table characters
-- ============================================================================
--  poggy_util · migration 001 · government stipend tenure
--  ---------------------------------------------------------------------------
--  Adds `characters`.`created_at`, which the stipend reads to work out how many
--  days a character has been on the server.
--
--  Characters that already exist get the legacy date below
--  (Config.Stipend.LegacyDate). Change it here, before poggy_util first starts,
--  if your server launched on a different date. New characters then get the
--  time they are created.
--
--  Runs once. A server that already has the column (added by poggy_util 1.x)
--  keeps its dates; only the default for new characters is set again. A server
--  with no `characters` table records this as done without running it.
-- ============================================================================

ALTER TABLE `characters` ADD COLUMN `created_at` DATETIME DEFAULT '2025-11-01 00:00:00';

ALTER TABLE `characters` CHANGE COLUMN `created_at` `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP;
