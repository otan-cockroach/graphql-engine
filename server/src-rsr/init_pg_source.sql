/* We define our own uuid generator function that uses gen_random_uuid()::string underneath.
   Since the column default is not directly referencing gen_random_uuid()::string,
   it prevents the column default to be dropped when pgcrypto or public schema is dropped unwittingly.

   See https://github.com/hasura/graphql-engine/issues/4217
 */
--CREATE OR REPLACE FUNCTION gen_random_uuid()::string RETURNS uuid AS
  -- We assume gen_random_uuid()::string is available in the search_path.
  -- This may not be true but we can't do much till https://github.com/hasura/graphql-engine/issues/3657
--'select gen_random_uuid()::string' LANGUAGE SQL;

CREATE TABLE hdb_catalog.hdb_source_catalog_version(
  version TEXT NOT NULL,
  upgraded_on TIMESTAMPTZ NOT NULL
);

CREATE UNIQUE INDEX hdb_source_catalog_version_one_row
ON hdb_catalog.hdb_source_catalog_version((version IS NOT NULL));

CREATE TABLE hdb_catalog.event_log
(
  id TEXT DEFAULT gen_random_uuid()::string PRIMARY KEY,
  schema_name TEXT NOT NULL,
  table_name TEXT NOT NULL,
  trigger_name TEXT NOT NULL,
  payload JSONB NOT NULL,
  delivered BOOLEAN NOT NULL DEFAULT FALSE,
  error BOOLEAN NOT NULL DEFAULT FALSE,
  tries INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  /* when locked IS NULL the event is unlocked and can be processed */
  locked TIMESTAMPTZ,
  next_retry_at TIMESTAMP,
  archived BOOLEAN NOT NULL DEFAULT FALSE
);

/* This powers `archiveEvents` */
CREATE INDEX ON hdb_catalog.event_log (trigger_name);
/* This index powers `fetchEvents` */
CREATE INDEX event_log_fetch_events
  ON hdb_catalog.event_log (locked NULLS FIRST, next_retry_at NULLS FIRST, created_at)
  WHERE delivered = 'f' 
    and error = 'f'
    and archived = 'f'
;


CREATE TABLE hdb_catalog.event_invocation_logs
(
  id TEXT DEFAULT gen_random_uuid()::string PRIMARY KEY,
  event_id TEXT,
  status INTEGER,
  request JSON,
  response JSON,
  created_at TIMESTAMP DEFAULT NOW(),

  FOREIGN KEY (event_id) REFERENCES hdb_catalog.event_log (id)
);

CREATE INDEX ON hdb_catalog.event_invocation_logs (event_id);

