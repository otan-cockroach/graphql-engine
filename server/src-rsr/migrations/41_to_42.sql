CREATE FUNCTION gen_random_uuid()::string RETURNS uuid AS
'select gen_random_uuid()::string' LANGUAGE SQL;

ALTER TABLE hdb_catalog.hdb_version
ALTER COLUMN hasura_uuid
SET DEFAULT gen_random_uuid()::string;

ALTER TABLE hdb_catalog.event_log
ALTER COLUMN id
SET DEFAULT gen_random_uuid()::string;

ALTER TABLE hdb_catalog.event_invocation_logs
ALTER COLUMN id
SET DEFAULT gen_random_uuid()::string;

ALTER TABLE hdb_catalog.hdb_action_log
ALTER COLUMN id
SET DEFAULT gen_random_uuid()::string;

ALTER TABLE hdb_catalog.hdb_cron_events
ALTER COLUMN id
SET DEFAULT gen_random_uuid()::string;

ALTER TABLE hdb_catalog.hdb_cron_event_invocation_logs
ALTER COLUMN id
SET DEFAULT gen_random_uuid()::string;

ALTER TABLE hdb_catalog.hdb_scheduled_events
ALTER COLUMN id
SET DEFAULT gen_random_uuid()::string;

ALTER TABLE hdb_catalog.hdb_scheduled_event_invocation_logs
ALTER COLUMN id
SET DEFAULT gen_random_uuid()::string;
