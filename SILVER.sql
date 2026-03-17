--
-- PostgreSQL database dump
--

\restrict hnykzxKLEcDwA7jSxNvkj1Z3RNoVt8IAZ0UjZKcLhd2EiYKqLIddbQ4uaZNi0Gh

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.7 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


ALTER TYPE auth.oauth_authorization_status OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


ALTER TYPE auth.oauth_client_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


ALTER TYPE auth.oauth_registration_type OWNER TO supabase_auth_admin;

--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


ALTER TYPE auth.oauth_response_type OWNER TO supabase_auth_admin;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO supabase_auth_admin;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO supabase_admin;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO supabase_admin;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO supabase_admin;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO supabase_admin;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: supabase_admin
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO supabase_admin;

--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


ALTER TYPE storage.buckettype OWNER TO supabase_storage_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: supabase_admin
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO supabase_admin;

--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
  INSERT INTO public.profiles (id, email, nick)
  VALUES (
    new.id, 
    new.email, 
    COALESCE(new.raw_user_meta_data->>'nick', split_part(new.email, '@', 1))
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN new;
END;
$$;


ALTER FUNCTION public.handle_new_user() OWNER TO postgres;

--
-- Name: rls_auto_enable(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.rls_auto_enable() RETURNS event_trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog'
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN
    SELECT *
    FROM pg_event_trigger_ddl_commands()
    WHERE command_tag IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
      AND object_type IN ('table','partitioned table')
  LOOP
     IF cmd.schema_name IS NOT NULL AND cmd.schema_name IN ('public') AND cmd.schema_name NOT IN ('pg_catalog','information_schema') AND cmd.schema_name NOT LIKE 'pg_toast%' AND cmd.schema_name NOT LIKE 'pg_temp%' THEN
      BEGIN
        EXECUTE format('alter table if exists %s enable row level security', cmd.object_identity);
        RAISE LOG 'rls_auto_enable: enabled RLS on %', cmd.object_identity;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE LOG 'rls_auto_enable: failed to enable RLS on %', cmd.object_identity;
      END;
     ELSE
        RAISE LOG 'rls_auto_enable: skip % (either system schema or not in enforced list: %.)', cmd.object_identity, cmd.schema_name;
     END IF;
  END LOOP;
END;
$$;


ALTER FUNCTION public.rls_auto_enable() OWNER TO postgres;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO supabase_admin;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO supabase_admin;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO supabase_admin;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO supabase_admin;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO supabase_admin;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO supabase_admin;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO supabase_admin;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO supabase_admin;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO supabase_admin;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: supabase_admin
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO supabase_admin;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO supabase_realtime_admin;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO supabase_storage_admin;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO supabase_storage_admin;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


ALTER FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO supabase_storage_admin;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text) OWNER TO supabase_storage_admin;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO supabase_storage_admin;

--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION storage.protect_delete() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


ALTER FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


ALTER TABLE auth.custom_oauth_providers OWNER TO supabase_auth_admin;

--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


ALTER TABLE auth.flow_state OWNER TO supabase_auth_admin;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


ALTER TABLE auth.oauth_authorizations OWNER TO supabase_auth_admin;

--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE auth.oauth_client_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


ALTER TABLE auth.oauth_clients OWNER TO supabase_auth_admin;

--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


ALTER TABLE auth.oauth_consents OWNER TO supabase_auth_admin;

--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: avisos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.avisos (
    id bigint DEFAULT 1 NOT NULL,
    titulo text,
    contenido text,
    mostrar boolean DEFAULT false,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.avisos OWNER TO postgres;

--
-- Name: matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matches (
    id bigint NOT NULL,
    home_team uuid,
    away_team uuid,
    home_score integer,
    away_score integer,
    week integer,
    is_played boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    season integer DEFAULT 1,
    division integer DEFAULT 1
);


ALTER TABLE public.matches OWNER TO postgres;

--
-- Name: profiles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    nick text,
    email text,
    avatar_url text,
    is_confirmed boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    telegram_user text,
    phone text,
    is_admin boolean DEFAULT false,
    last_seen timestamp with time zone,
    is_colaborador boolean DEFAULT false
);


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: COLUMN profiles.last_seen; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.profiles.last_seen IS 'Última actividad registrada del usuario (Heartbeat)';


--
-- Name: clasificacion; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.clasificacion WITH (security_invoker='true') AS
 WITH lista_jugadores AS (
         SELECT DISTINCT matches.home_team AS user_id,
            matches.season,
            matches.division
           FROM public.matches
        UNION
         SELECT DISTINCT matches.away_team AS user_id,
            matches.season,
            matches.division
           FROM public.matches
        ), stats_partidos AS (
         SELECT matches.season,
            matches.division,
            matches.home_team,
            matches.away_team,
            matches.home_score,
            matches.away_score,
                CASE
                    WHEN (matches.home_score > matches.away_score) THEN 3
                    WHEN (matches.home_score = matches.away_score) THEN 1
                    ELSE 0
                END AS pts_h,
                CASE
                    WHEN (matches.away_score > matches.home_score) THEN 3
                    WHEN (matches.home_score = matches.away_score) THEN 1
                    ELSE 0
                END AS pts_a,
                CASE
                    WHEN (matches.home_score > matches.away_score) THEN 1
                    ELSE 0
                END AS win_h,
                CASE
                    WHEN (matches.away_score > matches.home_score) THEN 1
                    ELSE 0
                END AS win_a,
                CASE
                    WHEN (matches.home_score = matches.away_score) THEN 1
                    ELSE 0
                END AS draw
           FROM public.matches
          WHERE ((matches.home_score IS NOT NULL) AND (matches.away_score IS NOT NULL))
        )
 SELECT lj.user_id,
    lj.season,
    lj.division,
    p.nick,
    p.avatar_url,
    COALESCE(sum(
        CASE
            WHEN (sp.home_team = lj.user_id) THEN sp.pts_h
            WHEN (sp.away_team = lj.user_id) THEN sp.pts_a
            ELSE 0
        END), (0)::bigint) AS pts,
    count(sp.home_team) AS pj,
    COALESCE(sum(
        CASE
            WHEN (sp.home_team = lj.user_id) THEN sp.win_h
            WHEN (sp.away_team = lj.user_id) THEN sp.win_a
            ELSE 0
        END), (0)::bigint) AS pg,
    COALESCE(sum(
        CASE
            WHEN ((sp.home_team = lj.user_id) OR (sp.away_team = lj.user_id)) THEN sp.draw
            ELSE 0
        END), (0)::bigint) AS pe,
    COALESCE(sum(
        CASE
            WHEN (sp.home_team = lj.user_id) THEN sp.home_score
            WHEN (sp.away_team = lj.user_id) THEN sp.away_score
            ELSE 0
        END), (0)::bigint) AS gf,
    COALESCE(sum(
        CASE
            WHEN (sp.home_team = lj.user_id) THEN sp.away_score
            WHEN (sp.away_team = lj.user_id) THEN sp.home_score
            ELSE 0
        END), (0)::bigint) AS gc,
    COALESCE(sum(
        CASE
            WHEN (sp.home_team = lj.user_id) THEN (sp.home_score - sp.away_score)
            WHEN (sp.away_team = lj.user_id) THEN (sp.away_score - sp.home_score)
            ELSE 0
        END), (0)::bigint) AS dg
   FROM ((lista_jugadores lj
     LEFT JOIN public.profiles p ON ((lj.user_id = p.id)))
     LEFT JOIN stats_partidos sp ON ((((lj.user_id = sp.home_team) OR (lj.user_id = sp.away_team)) AND (lj.season = sp.season) AND (lj.division = sp.division))))
  GROUP BY lj.user_id, lj.season, lj.division, p.nick, p.avatar_url
  ORDER BY COALESCE(sum(
        CASE
            WHEN (sp.home_team = lj.user_id) THEN sp.pts_h
            WHEN (sp.away_team = lj.user_id) THEN sp.pts_a
            ELSE 0
        END), (0)::bigint) DESC, COALESCE(sum(
        CASE
            WHEN (sp.home_team = lj.user_id) THEN (sp.home_score - sp.away_score)
            WHEN (sp.away_team = lj.user_id) THEN (sp.away_score - sp.home_score)
            ELSE 0
        END), (0)::bigint) DESC, COALESCE(sum(
        CASE
            WHEN (sp.home_team = lj.user_id) THEN sp.home_score
            WHEN (sp.away_team = lj.user_id) THEN sp.away_score
            ELSE 0
        END), (0)::bigint) DESC;


ALTER VIEW public.clasificacion OWNER TO postgres;

--
-- Name: config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.config (
    id integer NOT NULL,
    current_week integer DEFAULT 1,
    current_season integer DEFAULT 1,
    auto_week_by_date boolean DEFAULT false,
    auto_playoff_by_date boolean DEFAULT false,
    allow_registration boolean DEFAULT true
);


ALTER TABLE public.config OWNER TO postgres;

--
-- Name: config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.config ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: encuestas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.encuestas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    pregunta text NOT NULL,
    opciones text[] NOT NULL,
    activa boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    creador_id uuid
);


ALTER TABLE public.encuestas OWNER TO postgres;

--
-- Name: extra_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extra_groups (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    extra_id uuid,
    nombre_grupo text NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.extra_groups OWNER TO postgres;

--
-- Name: extra_matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extra_matches (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    extra_id uuid,
    group_id uuid,
    player1_id uuid,
    player2_id uuid,
    score1 integer,
    score2 integer,
    fecha_inicio timestamp with time zone,
    fecha_fin timestamp with time zone,
    fase text DEFAULT 'group'::text,
    numero_jornada integer,
    is_played boolean DEFAULT false,
    next_match_id uuid,
    stream_url text
);


ALTER TABLE public.extra_matches OWNER TO postgres;

--
-- Name: extra_playoffs_clasificacion; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.extra_playoffs_clasificacion WITH (security_invoker='true') AS
 WITH partidos_normalizados AS (
         SELECT extra_matches.extra_id,
            extra_matches.group_id,
            extra_matches.player1_id AS p_id,
            extra_matches.score1 AS gf,
            extra_matches.score2 AS gc,
                CASE
                    WHEN (extra_matches.score1 > extra_matches.score2) THEN 1
                    ELSE 0
                END AS pg,
                CASE
                    WHEN (extra_matches.score1 = extra_matches.score2) THEN 1
                    ELSE 0
                END AS pe,
                CASE
                    WHEN (extra_matches.score1 < extra_matches.score2) THEN 1
                    ELSE 0
                END AS pp
           FROM public.extra_matches
          WHERE ((extra_matches.is_played = true) AND (extra_matches.group_id IS NOT NULL))
        UNION ALL
         SELECT extra_matches.extra_id,
            extra_matches.group_id,
            extra_matches.player2_id AS p_id,
            extra_matches.score2 AS gf,
            extra_matches.score1 AS gc,
                CASE
                    WHEN (extra_matches.score2 > extra_matches.score1) THEN 1
                    ELSE 0
                END AS pg,
                CASE
                    WHEN (extra_matches.score2 = extra_matches.score1) THEN 1
                    ELSE 0
                END AS pe,
                CASE
                    WHEN (extra_matches.score2 < extra_matches.score1) THEN 1
                    ELSE 0
                END AS pp
           FROM public.extra_matches
          WHERE ((extra_matches.is_played = true) AND (extra_matches.group_id IS NOT NULL))
        ), universo_jugadores AS (
         SELECT DISTINCT extra_matches.extra_id,
            extra_matches.group_id,
            extra_matches.player1_id AS user_id
           FROM public.extra_matches
          WHERE (extra_matches.group_id IS NOT NULL)
        UNION
         SELECT DISTINCT extra_matches.extra_id,
            extra_matches.group_id,
            extra_matches.player2_id AS user_id
           FROM public.extra_matches
          WHERE (extra_matches.group_id IS NOT NULL)
        )
 SELECT uj.extra_id AS playoff_extra_id,
    uj.group_id,
    COALESCE(g.nombre_grupo, ('Grupo '::text || (uj.group_id)::text)) AS nombre_grupo_texto,
    p.nick,
    p.avatar_url,
    p.id AS user_id,
    COALESCE(count(pn.p_id), (0)::bigint) AS pj,
    COALESCE(sum(pn.pg), (0)::bigint) AS pg,
    COALESCE(sum(pn.pe), (0)::bigint) AS pe,
    COALESCE(sum(pn.pp), (0)::bigint) AS pp,
    COALESCE(sum(
        CASE
            WHEN (pn.pg = 1) THEN 3
            WHEN (pn.pe = 1) THEN 1
            ELSE 0
        END), (0)::bigint) AS pts,
    COALESCE(sum(pn.gf), (0)::bigint) AS gf,
    COALESCE(sum(pn.gc), (0)::bigint) AS gc,
    COALESCE((sum(pn.gf) - sum(pn.gc)), (0)::bigint) AS dg
   FROM (((universo_jugadores uj
     JOIN public.profiles p ON ((uj.user_id = p.id)))
     JOIN public.extra_groups g ON ((uj.group_id = g.id)))
     LEFT JOIN partidos_normalizados pn ON (((uj.extra_id = pn.extra_id) AND (uj.user_id = pn.p_id))))
  GROUP BY uj.extra_id, uj.group_id, g.nombre_grupo, p.id, p.nick, p.avatar_url;


ALTER VIEW public.extra_playoffs_clasificacion OWNER TO postgres;

--
-- Name: extra_playoffs_matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.extra_playoffs_matches (
    id integer NOT NULL,
    playoff_extra_id uuid,
    numero_jornada text,
    player1_id uuid,
    group_id_p1 uuid,
    posicion_p1 integer,
    player2_id uuid,
    group_id_p2 uuid,
    posicion_p2 integer,
    score1 integer,
    score2 integer,
    is_played boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    p1_from_match_id integer,
    p2_from_match_id integer,
    stream_url text,
    stream_updated_at timestamp with time zone
);


ALTER TABLE public.extra_playoffs_matches OWNER TO postgres;

--
-- Name: extra_playoffs_matches_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.extra_playoffs_matches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.extra_playoffs_matches_id_seq OWNER TO postgres;

--
-- Name: extra_playoffs_matches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.extra_playoffs_matches_id_seq OWNED BY public.extra_playoffs_matches.id;


--
-- Name: match_playoff_streams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.match_playoff_streams (
    playoff_match_id uuid NOT NULL,
    stream_url text NOT NULL,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.match_playoff_streams OWNER TO postgres;

--
-- Name: match_streams; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.match_streams (
    match_id bigint NOT NULL,
    stream_url text,
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.match_streams OWNER TO postgres;

--
-- Name: matches_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.matches ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.matches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: partidos_detallados; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.partidos_detallados WITH (security_invoker='on') AS
 SELECT m.id,
    m.home_team,
    m.away_team,
    m.home_score,
    m.away_score,
    m.is_played,
    m.week,
    m.season,
    m.division,
    m.created_at,
    ms.stream_url,
    ph.nick AS local_nick,
    ph.avatar_url AS local_avatar,
    pa.nick AS visitante_nick,
    pa.avatar_url AS visitante_avatar
   FROM (((public.matches m
     LEFT JOIN public.profiles ph ON ((m.home_team = ph.id)))
     LEFT JOIN public.profiles pa ON ((m.away_team = pa.id)))
     LEFT JOIN public.match_streams ms ON ((m.id = ms.match_id)));


ALTER VIEW public.partidos_detallados OWNER TO postgres;

--
-- Name: playoff_matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.playoff_matches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    playoff_id uuid,
    round text NOT NULL,
    match_order integer,
    home_team uuid,
    away_team uuid,
    home_score integer,
    away_score integer,
    winner_id uuid,
    next_match_id uuid,
    played boolean DEFAULT false,
    start_date timestamp with time zone,
    end_date timestamp with time zone
);


ALTER TABLE public.playoff_matches OWNER TO postgres;

--
-- Name: playoff_matches_detallados; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.playoff_matches_detallados WITH (security_invoker='on') AS
 SELECT pm.id,
    pm.playoff_id,
    pm.round,
    pm.match_order,
    pm.home_team AS local_id,
    pm.away_team AS visitante_id,
    pm.home_score,
    pm.away_score,
    pm.played AS is_played,
    pm.start_date,
    pm.end_date,
    p1.nick AS local_nick,
    p1.avatar_url AS local_avatar,
    p2.nick AS visitante_nick,
    p2.avatar_url AS visitante_avatar
   FROM ((public.playoff_matches pm
     LEFT JOIN public.profiles p1 ON ((pm.home_team = p1.id)))
     LEFT JOIN public.profiles p2 ON ((pm.away_team = p2.id)));


ALTER VIEW public.playoff_matches_detallados OWNER TO postgres;

--
-- Name: playoffs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.playoffs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    name text NOT NULL,
    season integer NOT NULL,
    is_active boolean DEFAULT true,
    settings jsonb DEFAULT '{"Final": false, "Cuartos": false, "Octavos": false, "Semifinales": false, "Dieciseisavos": false}'::jsonb,
    current_round text DEFAULT 'No iniciado'::text,
    limit_ga_enabled boolean DEFAULT true,
    max_ga_playoff integer DEFAULT 5
);


ALTER TABLE public.playoffs OWNER TO postgres;

--
-- Name: playoffs_extra; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.playoffs_extra (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    season_id integer,
    nombre text NOT NULL,
    tipo_format text DEFAULT 'ida'::text,
    jugadores_por_grupo integer DEFAULT 4,
    estado text DEFAULT 'configurando'::text,
    created_at timestamp with time zone DEFAULT now(),
    config_eliminatorias jsonb DEFAULT '{"final": "ida", "semis": "ida", "cuartos": "ida", "octavos": "ida"}'::jsonb,
    config_fechas jsonb DEFAULT '{}'::jsonb,
    num_grupos integer DEFAULT 2,
    pasan_por_grupo integer DEFAULT 2,
    current_round text DEFAULT 'j1'::text,
    use_auto_round boolean DEFAULT true,
    stream_puntos boolean DEFAULT false
);


ALTER TABLE public.playoffs_extra OWNER TO postgres;

--
-- Name: season_rules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.season_rules (
    season integer NOT NULL,
    bonus_enabled boolean DEFAULT false,
    bonus_min_percentage integer DEFAULT 80,
    bonus_points integer DEFAULT 1,
    updated_at timestamp with time zone DEFAULT now(),
    limit_ga_enabled boolean DEFAULT true,
    max_ga_league integer DEFAULT 3
);


ALTER TABLE public.season_rules OWNER TO postgres;

--
-- Name: v_extra_playoffs_bracket_dinamico; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_extra_playoffs_bracket_dinamico AS
 WITH marcador_global AS (
         SELECT m1.id AS ida_id,
            m1.player1_id AS p1_orig,
            m1.player2_id AS p2_orig,
            (COALESCE(m1.score1, 0) + COALESCE(m2.score2, 0)) AS total_p1,
            (COALESCE(m1.score2, 0) + COALESCE(m2.score1, 0)) AS total_p2,
            m1.is_played AS jugada_ida,
            COALESCE(m2.is_played, false) AS jugada_vuelta
           FROM (public.extra_playoffs_matches m1
             LEFT JOIN public.extra_playoffs_matches m2 ON (((m2.p1_from_match_id = m1.id) AND (m2.numero_jornada ~~* '%VUELTA%'::text))))
          WHERE (m1.numero_jornada !~~* '%VUELTA%'::text)
        )
 SELECT id,
    playoff_extra_id,
    numero_jornada,
    player1_id,
    group_id_p1,
    posicion_p1,
    player2_id,
    group_id_p2,
    posicion_p2,
    score1,
    score2,
    is_played,
    created_at,
    p1_from_match_id,
    p2_from_match_id,
        CASE
            WHEN (player1_id IS NOT NULL) THEN ( SELECT profiles.nick
               FROM public.profiles
              WHERE (profiles.id = m.player1_id))
            WHEN (p1_from_match_id IS NOT NULL) THEN ( SELECT
                    CASE
                        WHEN ((rg.jugada_ida IS NOT TRUE) OR (rg.jugada_vuelta IS NOT TRUE)) THEN 'TBD'::text
                        WHEN (rg.total_p1 > rg.total_p2) THEN ( SELECT profiles.nick
                           FROM public.profiles
                          WHERE (profiles.id = rg.p1_orig))
                        WHEN (rg.total_p2 > rg.total_p1) THEN ( SELECT profiles.nick
                           FROM public.profiles
                          WHERE (profiles.id = rg.p2_orig))
                        ELSE 'TBD'::text
                    END AS "case"
               FROM marcador_global rg
              WHERE (rg.ida_id = m.p1_from_match_id))
            WHEN (group_id_p1 IS NOT NULL) THEN ('Ganador G.'::text || posicion_p1)
            ELSE 'TBD'::text
        END AS p1_nick,
        CASE
            WHEN (player1_id IS NOT NULL) THEN ( SELECT profiles.avatar_url
               FROM public.profiles
              WHERE (profiles.id = m.player1_id))
            WHEN (p1_from_match_id IS NOT NULL) THEN ( SELECT
                    CASE
                        WHEN ((rg.jugada_ida IS NOT TRUE) OR (rg.jugada_vuelta IS NOT TRUE)) THEN NULL::text
                        WHEN (rg.total_p1 > rg.total_p2) THEN ( SELECT profiles.avatar_url
                           FROM public.profiles
                          WHERE (profiles.id = rg.p1_orig))
                        WHEN (rg.total_p2 > rg.total_p1) THEN ( SELECT profiles.avatar_url
                           FROM public.profiles
                          WHERE (profiles.id = rg.p2_orig))
                        ELSE NULL::text
                    END AS "case"
               FROM marcador_global rg
              WHERE (rg.ida_id = m.p1_from_match_id))
            ELSE NULL::text
        END AS p1_avatar,
        CASE
            WHEN (player2_id IS NOT NULL) THEN ( SELECT profiles.nick
               FROM public.profiles
              WHERE (profiles.id = m.player2_id))
            WHEN (p2_from_match_id IS NOT NULL) THEN ( SELECT
                    CASE
                        WHEN ((rg.jugada_ida IS NOT TRUE) OR (rg.jugada_vuelta IS NOT TRUE)) THEN 'TBD'::text
                        WHEN (rg.total_p1 > rg.total_p2) THEN ( SELECT profiles.nick
                           FROM public.profiles
                          WHERE (profiles.id = rg.p1_orig))
                        WHEN (rg.total_p2 > rg.total_p1) THEN ( SELECT profiles.nick
                           FROM public.profiles
                          WHERE (profiles.id = rg.p2_orig))
                        ELSE 'TBD'::text
                    END AS "case"
               FROM marcador_global rg
              WHERE (rg.ida_id = m.p2_from_match_id))
            WHEN (group_id_p2 IS NOT NULL) THEN ('Ganador G.'::text || posicion_p2)
            ELSE 'TBD'::text
        END AS p2_nick,
        CASE
            WHEN (player2_id IS NOT NULL) THEN ( SELECT profiles.avatar_url
               FROM public.profiles
              WHERE (profiles.id = m.player2_id))
            WHEN (p2_from_match_id IS NOT NULL) THEN ( SELECT
                    CASE
                        WHEN ((rg.jugada_ida IS NOT TRUE) OR (rg.jugada_vuelta IS NOT TRUE)) THEN NULL::text
                        WHEN (rg.total_p1 > rg.total_p2) THEN ( SELECT profiles.avatar_url
                           FROM public.profiles
                          WHERE (profiles.id = rg.p1_orig))
                        WHEN (rg.total_p2 > rg.total_p1) THEN ( SELECT profiles.avatar_url
                           FROM public.profiles
                          WHERE (profiles.id = rg.p2_orig))
                        ELSE NULL::text
                    END AS "case"
               FROM marcador_global rg
              WHERE (rg.ida_id = m.p2_from_match_id))
            ELSE NULL::text
        END AS p2_avatar
   FROM public.extra_playoffs_matches m;


ALTER VIEW public.v_extra_playoffs_bracket_dinamico OWNER TO postgres;

--
-- Name: v_posiciones_dinamicas; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_posiciones_dinamicas AS
 SELECT playoff_extra_id,
    group_id,
    user_id,
    nick,
    pts AS puntos,
    dg AS diferencia_goles,
    gf AS goles_favor,
    row_number() OVER (PARTITION BY playoff_extra_id, group_id ORDER BY pts DESC, dg DESC, gf DESC) AS posicion_ranking
   FROM public.extra_playoffs_clasificacion;


ALTER VIEW public.v_posiciones_dinamicas OWNER TO postgres;

--
-- Name: votos_encuesta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.votos_encuesta (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    encuesta_id uuid,
    usuario_id uuid,
    opcion_index integer NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.votos_encuesta OWNER TO postgres;

--
-- Name: weeks_schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weeks_schedule (
    id bigint NOT NULL,
    season integer NOT NULL,
    week integer NOT NULL,
    start_at timestamp with time zone,
    end_at timestamp with time zone,
    is_linked boolean DEFAULT false
);


ALTER TABLE public.weeks_schedule OWNER TO postgres;

--
-- Name: weeks_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.weeks_schedule ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.weeks_schedule_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO supabase_realtime_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: supabase_admin
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


ALTER TABLE realtime.subscription OWNER TO supabase_admin;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


ALTER TABLE storage.buckets_analytics OWNER TO supabase_storage_admin;

--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.buckets_vectors OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: supabase_storage_admin
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO supabase_storage_admin;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO supabase_storage_admin;

--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.vector_indexes OWNER TO supabase_storage_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: extra_playoffs_matches id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_playoffs_matches ALTER COLUMN id SET DEFAULT nextval('public.extra_playoffs_matches_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
c06aa55d-9cd6-4f14-8d85-6c5739913994	c06aa55d-9cd6-4f14-8d85-6c5739913994	{"sub": "c06aa55d-9cd6-4f14-8d85-6c5739913994", "nick": "Mr.Macson", "email": "jhortolano@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-16 14:41:52.44859+00	2026-02-16 14:41:52.448639+00	2026-02-16 14:41:52.448639+00	0470001a-6283-4048-a451-3bb0dab7fe83
00872e2b-9e9c-442f-810c-bfd62ee8a524	00872e2b-9e9c-442f-810c-bfd62ee8a524	{"sub": "00872e2b-9e9c-442f-810c-bfd62ee8a524", "nick": "MELIODAS", "email": "mineclavelo11@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-28 09:22:43.213575+00	2026-02-28 09:22:43.213633+00	2026-02-28 09:22:43.213633+00	8093fddc-bd27-48e3-9316-67742d90b5e7
ff1dccb8-00bc-4042-a869-3a55773f3701	ff1dccb8-00bc-4042-a869-3a55773f3701	{"sub": "ff1dccb8-00bc-4042-a869-3a55773f3701", "nick": "errejota", "email": "rjgcolino@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-16 15:24:06.240843+00	2026-02-16 15:24:06.240891+00	2026-02-16 15:24:06.240891+00	6b618aab-ff5b-47bb-a8e2-5fe49efaf923
e2c0c4df-3aba-4f3e-9511-49df6b02b87b	e2c0c4df-3aba-4f3e-9511-49df6b02b87b	{"sub": "e2c0c4df-3aba-4f3e-9511-49df6b02b87b", "nick": "Javi GT", "email": "javigr77@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-17 15:36:20.324639+00	2026-02-17 15:36:20.32533+00	2026-02-17 15:36:20.32533+00	238d7966-30fd-4a4b-b6cd-8b41822158d5
a9757a54-7b1b-4e90-a88e-2f03cc0ca478	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	{"sub": "a9757a54-7b1b-4e90-a88e-2f03cc0ca478", "nick": "payo_malo_89", "email": "mendyvillacity@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-19 23:23:42.984328+00	2026-02-19 23:23:42.984384+00	2026-02-19 23:23:42.984384+00	94455ede-60fe-4cf5-854c-1016af988d44
b5d23981-469b-4353-a615-9e4d6c8d8daf	b5d23981-469b-4353-a615-9e4d6c8d8daf	{"sub": "b5d23981-469b-4353-a615-9e4d6c8d8daf", "nick": "AdriWins", "email": "adrianruizmartos16@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-21 18:35:14.281994+00	2026-02-21 18:35:14.283198+00	2026-02-21 18:35:14.283198+00	c2323181-9463-47b6-8022-b518654a096a
449ee91c-f52f-4661-abd4-ebfd556c37c3	449ee91c-f52f-4661-abd4-ebfd556c37c3	{"sub": "449ee91c-f52f-4661-abd4-ebfd556c37c3", "nick": "Hukha", "email": "hukha221@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-25 11:50:01.917419+00	2026-02-25 11:50:01.917477+00	2026-02-25 11:50:01.917477+00	25e3ce3b-d667-4c2b-a3b6-f7bcc78cca5b
2549f3dd-74dd-473b-be44-d5983b70e1ba	2549f3dd-74dd-473b-be44-d5983b70e1ba	{"sub": "2549f3dd-74dd-473b-be44-d5983b70e1ba", "nick": "Franchesco", "email": "francisaditrap@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-25 11:51:26.153319+00	2026-02-25 11:51:26.153367+00	2026-02-25 11:51:26.153367+00	9b1c947b-3abc-4ba0-9394-561c407218f5
943a493d-044c-4c88-babc-e64804553bb4	943a493d-044c-4c88-babc-e64804553bb4	{"sub": "943a493d-044c-4c88-babc-e64804553bb4", "nick": "Angel_Rico", "email": "angel_fgrico@hotmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-25 19:24:06.120852+00	2026-02-25 19:24:06.12154+00	2026-02-25 19:24:06.12154+00	d924fe3d-1890-471c-bb5f-3f0f812c7148
eae8c25a-a99d-480f-8e3e-854d36c5c8dc	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	{"sub": "eae8c25a-a99d-480f-8e3e-854d36c5c8dc", "nick": "Jeybiss", "email": "57juanjose57@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-26 13:49:18.386427+00	2026-02-26 13:49:18.386483+00	2026-02-26 13:49:18.386483+00	1033493a-a4df-44c6-948a-e9a2084ba578
4d3815fd-7460-4eb3-a435-257850cd58ca	4d3815fd-7460-4eb3-a435-257850cd58ca	{"sub": "4d3815fd-7460-4eb3-a435-257850cd58ca", "nick": "Piedr4hita11", "email": "santipiedrahita7@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-26 17:35:59.402629+00	2026-02-26 17:35:59.403241+00	2026-02-26 17:35:59.403241+00	27f5f3dc-f07c-4eea-9781-1d2438079459
8c1c7bba-636d-42f2-820a-ac1131897e84	8c1c7bba-636d-42f2-820a-ac1131897e84	{"sub": "8c1c7bba-636d-42f2-820a-ac1131897e84", "nick": "Don Ptr Squad", "email": "pedrorodriguezmoya83@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-28 11:22:16.490936+00	2026-02-28 11:22:16.490986+00	2026-02-28 11:22:16.490986+00	97fde2e0-a1e0-4521-909b-2a11b881953e
38f98f64-f2db-47bf-a5ea-dcd1804ce00a	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	{"sub": "38f98f64-f2db-47bf-a5ea-dcd1804ce00a", "nick": "themule089", "email": "david.cvega89@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-01 09:34:43.303239+00	2026-03-01 09:34:43.303294+00	2026-03-01 09:34:43.303294+00	f53590c9-0400-44ce-a2d4-0b9b9d2cfd04
2f58705a-25ad-42c9-b953-5137532b3584	2f58705a-25ad-42c9-b953-5137532b3584	{"sub": "2f58705a-25ad-42c9-b953-5137532b3584", "nick": "Selu ", "email": "jluisdiazmaroto@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-01 19:03:49.225077+00	2026-03-01 19:03:49.225133+00	2026-03-01 19:03:49.225133+00	9d7e3810-3f22-4feb-a742-cb3446e5500d
16f4402c-a1b5-4431-8d98-c454f52a6284	16f4402c-a1b5-4431-8d98-c454f52a6284	{"sub": "16f4402c-a1b5-4431-8d98-c454f52a6284", "nick": "Iker", "email": "ikerxu1985@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-02 22:26:22.691135+00	2026-03-02 22:26:22.691188+00	2026-03-02 22:26:22.691188+00	6282a820-367e-45ba-915b-de2f0d3e0c8a
84cdd50e-ef22-4022-aeca-60bfe32b6018	84cdd50e-ef22-4022-aeca-60bfe32b6018	{"sub": "84cdd50e-ef22-4022-aeca-60bfe32b6018", "nick": "Seventowers", "email": "superivanft@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-04 14:14:20.174255+00	2026-03-04 14:14:20.174307+00	2026-03-04 14:14:20.174307+00	3a988ffb-e6e1-42f2-9613-faf8079c51c5
c96625ad-9941-423c-8b5a-6fdc1b54ac20	c96625ad-9941-423c-8b5a-6fdc1b54ac20	{"sub": "c96625ad-9941-423c-8b5a-6fdc1b54ac20", "nick": "SharkD", "email": "dari970417@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-09 11:32:15.835569+00	2026-03-09 11:32:15.835619+00	2026-03-09 11:32:15.835619+00	9c733f8a-3eec-4ef3-a5ea-75f5784e26ce
45ef0325-e165-4aef-8836-03099f1d7bd9	45ef0325-e165-4aef-8836-03099f1d7bd9	{"sub": "45ef0325-e165-4aef-8836-03099f1d7bd9", "nick": "Chava_14", "email": "luischava1234@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-09 11:59:20.426085+00	2026-03-09 11:59:20.426136+00	2026-03-09 11:59:20.426136+00	facfb59d-d88c-4a0b-9b99-f679145c5642
8d16ce77-1836-4ce6-a462-b9d16358fb3f	8d16ce77-1836-4ce6-a462-b9d16358fb3f	{"sub": "8d16ce77-1836-4ce6-a462-b9d16358fb3f", "nick": "Rubens_saga", "email": "muycontento10@hotmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-11 13:13:38.166838+00	2026-03-11 13:13:38.166887+00	2026-03-11 13:13:38.166887+00	e9d487b9-27c2-491b-9244-ccb3fa6b2531
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
921211cb-2c1b-4f73-b316-c98e54e46770	2026-03-17 11:50:55.238095+00	2026-03-17 11:50:55.238095+00	password	f4598193-ad69-4afb-8b60-21692b6ed557
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	641	pha3qyjhtyo4	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-03-17 11:50:55.219665+00	2026-03-17 12:54:49.617097+00	\N	921211cb-2c1b-4f73-b316-c98e54e46770
00000000-0000-0000-0000-000000000000	642	2z4j5qfkccu7	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-03-17 12:54:49.645744+00	2026-03-17 13:53:56.992836+00	pha3qyjhtyo4	921211cb-2c1b-4f73-b316-c98e54e46770
00000000-0000-0000-0000-000000000000	643	kpaptv7zt6vy	c06aa55d-9cd6-4f14-8d85-6c5739913994	f	2026-03-17 13:53:57.007268+00	2026-03-17 13:53:57.007268+00	2z4j5qfkccu7	921211cb-2c1b-4f73-b316-c98e54e46770
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
921211cb-2c1b-4f73-b316-c98e54e46770	c06aa55d-9cd6-4f14-8d85-6c5739913994	2026-03-17 11:50:55.20232+00	2026-03-17 13:53:57.033823+00	\N	aal1	\N	2026-03-17 13:53:57.032115	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	77.230.14.47	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	authenticated	authenticated	57juanjose57@gmail.com	$2a$10$GpfQMhmVjoV1fepRVUu/x.3ST9sOJ4.eSwXLysQuYF4httGTlCyvO	2026-02-26 13:49:28.516411+00	\N		2026-02-26 13:49:18.39979+00		\N			\N	2026-02-26 13:49:28.52203+00	{"provider": "email", "providers": ["email"]}	{"sub": "eae8c25a-a99d-480f-8e3e-854d36c5c8dc", "nick": "Jeybiss", "email": "57juanjose57@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-26 13:49:18.323529+00	2026-03-15 19:16:26.650136+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ff1dccb8-00bc-4042-a869-3a55773f3701	authenticated	authenticated	rjgcolino@gmail.com	$2a$10$b1OwVkzY25CoClpixZRi2u.iT3PteD.5CgBwjoA9QH7TESlZxigN2	2026-02-16 15:24:29.591924+00	\N		\N		\N			\N	2026-03-16 15:26:52.226829+00	{"provider": "email", "providers": ["email"]}	{"sub": "ff1dccb8-00bc-4042-a869-3a55773f3701", "nick": "errejota", "email": "rjgcolino@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-16 15:24:06.156321+00	2026-03-16 15:26:52.243538+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	b5d23981-469b-4353-a615-9e4d6c8d8daf	authenticated	authenticated	adrianruizmartos16@gmail.com	$2a$10$3CzUZUFSTOdmyKa24GZUTeHxdspGzj9NUEVLfXPEGNQ7cU.4zCSjW	2026-02-21 18:35:43.783589+00	\N		2026-02-21 18:35:14.305928+00		\N			\N	2026-02-21 18:35:43.795597+00	{"provider": "email", "providers": ["email"]}	{"sub": "b5d23981-469b-4353-a615-9e4d6c8d8daf", "nick": "AdriWins", "email": "adrianruizmartos16@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-21 18:35:14.190404+00	2026-03-15 11:26:43.861478+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4d3815fd-7460-4eb3-a435-257850cd58ca	authenticated	authenticated	santipiedrahita7@gmail.com	$2a$10$YCHZneQqRwYUZTsQmtxi1ODIRWx0m0XzgTR/c9Vbt3YWLraEGSYHG	2026-02-26 17:36:26.877921+00	\N		2026-02-26 17:35:59.422929+00		\N			\N	2026-03-15 13:04:22.293403+00	{"provider": "email", "providers": ["email"]}	{"sub": "4d3815fd-7460-4eb3-a435-257850cd58ca", "nick": "Piedr4hita11", "email": "santipiedrahita7@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-26 17:35:59.323086+00	2026-03-15 13:04:22.310061+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8c1c7bba-636d-42f2-820a-ac1131897e84	authenticated	authenticated	pedrorodriguezmoya83@gmail.com	$2a$10$/FcmxVkAnijV5/lFzHqeYeH/yBAQlLGgzGL9V6yfVlA3veR99Bxoe	2026-02-28 11:22:27.661093+00	\N		2026-02-28 11:22:16.502673+00		\N			\N	2026-02-28 11:22:27.668357+00	{"provider": "email", "providers": ["email"]}	{"sub": "8c1c7bba-636d-42f2-820a-ac1131897e84", "nick": "Don Ptr Squad", "email": "pedrorodriguezmoya83@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-28 11:22:16.41071+00	2026-03-16 08:45:17.367951+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	449ee91c-f52f-4661-abd4-ebfd556c37c3	authenticated	authenticated	hukha221@gmail.com	$2a$10$.4hVjkKqDx8fAPimAMChRukwgDs00ATBn4CqgzWQP1vkuxeREkAlW	2026-02-25 11:51:07.505688+00	\N		2026-02-25 11:50:01.928268+00		\N			\N	2026-02-25 11:51:07.531673+00	{"provider": "email", "providers": ["email"]}	{"sub": "449ee91c-f52f-4661-abd4-ebfd556c37c3", "nick": "Hukha", "email": "hukha221@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-25 11:50:01.842461+00	2026-03-10 18:37:02.071976+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	00872e2b-9e9c-442f-810c-bfd62ee8a524	authenticated	authenticated	mineclavelo11@gmail.com	$2a$10$Dc9MUV5Yh/xtbjnUENoW3urLVBaujjXfRv89LXEaf/X9LI/cRYonq	2026-02-28 09:27:58.646956+00	\N		2026-02-28 09:22:43.230979+00		\N			\N	2026-03-02 11:01:55.13382+00	{"provider": "email", "providers": ["email"]}	{"sub": "00872e2b-9e9c-442f-810c-bfd62ee8a524", "nick": "MELIODAS", "email": "mineclavelo11@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-28 09:22:43.120096+00	2026-03-16 11:34:31.48907+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e2c0c4df-3aba-4f3e-9511-49df6b02b87b	authenticated	authenticated	javigr77@gmail.com	$2a$10$kvXOLw9KU3ZkZIZYEiJjxe.UmThcsVGKN6wc3naXI743/OnlNP68e	2026-02-17 15:36:36.276768+00	\N		\N		\N			\N	2026-03-03 15:41:24.938955+00	{"provider": "email", "providers": ["email"]}	{"sub": "e2c0c4df-3aba-4f3e-9511-49df6b02b87b", "nick": "Javi GT", "email": "javigr77@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-17 15:36:20.289572+00	2026-03-15 12:58:01.499949+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	943a493d-044c-4c88-babc-e64804553bb4	authenticated	authenticated	angel_fgrico@hotmail.com	$2a$10$AJhZDcvdBiGI4gvMFzclZ.fdamdOU082Acq2op7DhHVeMmqdFlzSW	2026-02-25 19:24:42.860648+00	\N		2026-02-25 19:24:06.141473+00		\N			\N	2026-03-16 15:53:44.067785+00	{"provider": "email", "providers": ["email"]}	{"sub": "943a493d-044c-4c88-babc-e64804553bb4", "nick": "Angel_Rico", "email": "angel_fgrico@hotmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-25 19:24:06.031284+00	2026-03-16 15:53:44.128959+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	authenticated	authenticated	mendyvillacity@gmail.com	$2a$10$TGDFclME.y89VE0xvxHXqeCahLA6uTkwaRKCZpu8WK09qoCs8/7c.	2026-02-19 23:27:10.36821+00	\N		2026-02-19 23:26:37.941244+00		\N			\N	2026-03-09 21:31:55.678434+00	{"provider": "email", "providers": ["email"]}	{"sub": "a9757a54-7b1b-4e90-a88e-2f03cc0ca478", "nick": "payo_malo_89", "email": "mendyvillacity@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-19 23:23:42.884382+00	2026-03-14 15:11:10.852257+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2549f3dd-74dd-473b-be44-d5983b70e1ba	authenticated	authenticated	francisaditrap@gmail.com	$2a$10$jFFnRA7o0GinaRFJJ0cDXuwET4InLx1Dvul6Yko8RcLfZ/Z1sV3ji	2026-02-25 11:51:51.26109+00	\N		2026-02-25 11:51:26.158647+00		\N			\N	2026-02-25 11:51:51.264208+00	{"provider": "email", "providers": ["email"]}	{"sub": "2549f3dd-74dd-473b-be44-d5983b70e1ba", "nick": "Franchesco", "email": "francisaditrap@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-25 11:51:26.140923+00	2026-03-09 20:31:52.326784+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	45ef0325-e165-4aef-8836-03099f1d7bd9	authenticated	authenticated	luischava1234@gmail.com	$2a$10$bR7jOnTDU5JKhYqtm5qjdOMiUoT97U7ihe2ksODQaCF1rnD2S/UHW	2026-03-09 11:59:31.830678+00	\N		2026-03-09 11:59:20.440525+00		\N			\N	2026-03-09 11:59:31.838669+00	{"provider": "email", "providers": ["email"]}	{"sub": "45ef0325-e165-4aef-8836-03099f1d7bd9", "nick": "Chava_14", "email": "luischava1234@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-09 11:59:20.359839+00	2026-03-09 16:51:59.409112+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	84cdd50e-ef22-4022-aeca-60bfe32b6018	authenticated	authenticated	superivanft@gmail.com	$2a$10$aWQcD47wkoyiTUysyRJFDOPzic/69J.dtDut3PXiKbmMvpdmdQTVq	2026-03-04 14:14:40.285736+00	\N		2026-03-04 14:14:20.193641+00		\N			\N	2026-03-04 14:14:40.292359+00	{"provider": "email", "providers": ["email"]}	{"sub": "84cdd50e-ef22-4022-aeca-60bfe32b6018", "nick": "Seventowers", "email": "superivanft@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-04 14:14:20.109309+00	2026-03-04 14:14:40.301987+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2f58705a-25ad-42c9-b953-5137532b3584	authenticated	authenticated	jluisdiazmaroto@gmail.com	$2a$10$ARZ3KOiyTtDOM2dKu26GB.l.Fq95o.XszlbdwJviezIbwE4NmrzXS	2026-03-01 19:14:31.270691+00	\N		2026-03-01 19:03:49.246213+00		\N			\N	2026-03-01 19:14:31.308644+00	{"provider": "email", "providers": ["email"]}	{"sub": "2f58705a-25ad-42c9-b953-5137532b3584", "nick": "Selu ", "email": "jluisdiazmaroto@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-01 19:03:49.130763+00	2026-03-15 19:07:50.222463+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	authenticated	authenticated	david.cvega89@gmail.com	$2a$10$AdcjtQw1BYIwq8SUqvhclOvZrq2O2jY.DBNA1YRmbsxLV3iSUEmSy	2026-03-01 09:34:58.290428+00	\N		2026-03-01 09:34:43.322612+00		\N			\N	2026-03-01 09:34:58.29578+00	{"provider": "email", "providers": ["email"]}	{"sub": "38f98f64-f2db-47bf-a5ea-dcd1804ce00a", "nick": "themule089", "email": "david.cvega89@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-01 09:34:43.212688+00	2026-03-16 08:27:29.231944+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c96625ad-9941-423c-8b5a-6fdc1b54ac20	authenticated	authenticated	dari970417@gmail.com	$2a$10$pFa07LiTSa42r.8BPD1TVOp4Kg/vk55m/V7KX.qiDCDI8zOPGEb3i	2026-03-09 11:32:37.14358+00	\N		2026-03-09 11:32:15.848157+00		\N			\N	2026-03-09 11:32:37.149201+00	{"provider": "email", "providers": ["email"]}	{"sub": "c96625ad-9941-423c-8b5a-6fdc1b54ac20", "nick": "SharkD", "email": "dari970417@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-09 11:32:15.759641+00	2026-03-16 12:09:04.368182+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8d16ce77-1836-4ce6-a462-b9d16358fb3f	authenticated	authenticated	muycontento10@hotmail.com	$2a$10$9hwtG3lBBxKAcR1EgH7q1OQBla9xhZ8wY45z3UmePbB9NQt5hfQCi	2026-03-11 13:14:34.072826+00	\N		2026-03-11 13:13:38.178514+00		\N			\N	2026-03-11 13:14:34.1365+00	{"provider": "email", "providers": ["email"]}	{"sub": "8d16ce77-1836-4ce6-a462-b9d16358fb3f", "nick": "Rubens_saga", "email": "muycontento10@hotmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-11 13:13:38.094624+00	2026-03-16 19:27:15.275435+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	16f4402c-a1b5-4431-8d98-c454f52a6284	authenticated	authenticated	ikerxu1985@gmail.com	$2a$10$AruBsDX59U49ifBHVTmpWOU1npSlmeJGyUgoEO1WFXT8EvUZWYZLe	2026-03-02 22:26:38.729633+00	\N		2026-03-02 22:26:22.707407+00		\N			\N	2026-03-02 22:41:23.048837+00	{"provider": "email", "providers": ["email"]}	{"sub": "16f4402c-a1b5-4431-8d98-c454f52a6284", "nick": "Iker", "email": "ikerxu1985@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-02 22:26:22.573167+00	2026-03-17 01:05:30.240283+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c06aa55d-9cd6-4f14-8d85-6c5739913994	authenticated	authenticated	jhortolano@gmail.com	$2a$10$421fUnsaWu7hdBcR9.kKKO7HwLxElpwerwrZu/obwKtOx6K4WExcm	2026-02-16 14:42:03.862989+00	\N		\N		2026-03-08 20:04:20.645762+00			\N	2026-03-17 11:50:55.202223+00	{"provider": "email", "providers": ["email"]}	{"sub": "c06aa55d-9cd6-4f14-8d85-6c5739913994", "nick": "Mr.Macson", "email": "jhortolano@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-16 14:41:52.428558+00	2026-03-17 13:53:57.019938+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: avisos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.avisos (id, titulo, contenido, mostrar, updated_at) FROM stdin;
1	📅 La liga empieza el lunes 📅	⚽ **CALENDARIO YA DISPONIBLE**⚽ \n\n🗓️ Del **9 al 15 de marzo** se disputará la primera jornada oficial.	f	2026-03-09 05:50:02.385+00
\.


--
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config (id, current_week, current_season, auto_week_by_date, auto_playoff_by_date, allow_registration) FROM stdin;
1	2	1	t	f	f
\.


--
-- Data for Name: encuestas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encuestas (id, pregunta, opciones, activa, created_at, creador_id) FROM stdin;
d222b220-a0c5-4783-bc0c-03a827e0f888	¿Quieres jugar la Champions? 1 partido adicional a la semana (hasta eliminación) - Modo Playoff -	{Si,No}	t	2026-03-09 14:20:09.575327+00	\N
\.


--
-- Data for Name: extra_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extra_groups (id, extra_id, nombre_grupo, created_at) FROM stdin;
025c49a4-08e6-4057-b79f-2dc439f6799b	5e1e9967-e3c0-4875-9980-abeea850803d	Grupo A	2026-03-17 12:22:56.38238+00
0db3e9a4-f193-4e4c-b97f-1e01997cb6f5	5e1e9967-e3c0-4875-9980-abeea850803d	Grupo B	2026-03-17 12:22:56.641805+00
376a502e-31a3-49b4-9506-b098a096e6fd	5e1e9967-e3c0-4875-9980-abeea850803d	Grupo C	2026-03-17 12:22:56.902092+00
00dce6ca-e6c7-4177-acd6-52b58ab0ce1f	5e1e9967-e3c0-4875-9980-abeea850803d	Grupo D	2026-03-17 12:22:57.1671+00
133484b4-e555-4157-9d71-9e545ec04521	5e1e9967-e3c0-4875-9980-abeea850803d	Grupo E	2026-03-17 12:22:57.451729+00
\.


--
-- Data for Name: extra_matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extra_matches (id, extra_id, group_id, player1_id, player2_id, score1, score2, fecha_inicio, fecha_fin, fase, numero_jornada, is_played, next_match_id, stream_url) FROM stdin;
b9d21e8b-1c0c-4a22-8f16-46ac63de1074	5e1e9967-e3c0-4875-9980-abeea850803d	376a502e-31a3-49b4-9506-b098a096e6fd	ff1dccb8-00bc-4042-a869-3a55773f3701	c06aa55d-9cd6-4f14-8d85-6c5739913994	1	6	\N	\N	j1	1	t	\N	http://www.youtube.com
0af185c0-11bb-45cb-982d-f45132c6455e	5e1e9967-e3c0-4875-9980-abeea850803d	0db3e9a4-f193-4e4c-b97f-1e01997cb6f5	2549f3dd-74dd-473b-be44-d5983b70e1ba	943a493d-044c-4c88-babc-e64804553bb4	3	1	\N	\N	j1	1	t	\N	\N
485aefe5-8dca-4329-96e8-88a368985d02	5e1e9967-e3c0-4875-9980-abeea850803d	025c49a4-08e6-4057-b79f-2dc439f6799b	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	449ee91c-f52f-4661-abd4-ebfd556c37c3	2	1	\N	\N	j1	1	t	\N	\N
f7699f51-66f5-40ad-bb09-8e7fddc2ffa4	5e1e9967-e3c0-4875-9980-abeea850803d	00dce6ca-e6c7-4177-acd6-52b58ab0ce1f	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	45ef0325-e165-4aef-8836-03099f1d7bd9	3	1	\N	\N	j1	1	t	\N	\N
77b9c497-b603-4e0c-a4c0-a78cfb2a7232	5e1e9967-e3c0-4875-9980-abeea850803d	133484b4-e555-4157-9d71-9e545ec04521	4d3815fd-7460-4eb3-a435-257850cd58ca	2f58705a-25ad-42c9-b953-5137532b3584	4	5	\N	\N	j1	1	t	\N	\N
\.


--
-- Data for Name: extra_playoffs_matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extra_playoffs_matches (id, playoff_extra_id, numero_jornada, player1_id, group_id_p1, posicion_p1, player2_id, group_id_p2, posicion_p2, score1, score2, is_played, created_at, p1_from_match_id, p2_from_match_id, stream_url, stream_updated_at) FROM stdin;
16	5e1e9967-e3c0-4875-9980-abeea850803d	CUARTOS IDA	2549f3dd-74dd-473b-be44-d5983b70e1ba	0db3e9a4-f193-4e4c-b97f-1e01997cb6f5	1	\N	\N	\N	\N	\N	t	2026-03-17 12:22:57.686877+00	\N	\N	\N	\N
19	5e1e9967-e3c0-4875-9980-abeea850803d	CUARTOS VUELTA	\N	\N	\N	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	376a502e-31a3-49b4-9506-b098a096e6fd	1	\N	\N	t	2026-03-17 12:22:57.686877+00	\N	\N	\N	\N
13	5e1e9967-e3c0-4875-9980-abeea850803d	CUARTOS VUELTA	\N	\N	\N	c06aa55d-9cd6-4f14-8d85-6c5739913994	025c49a4-08e6-4057-b79f-2dc439f6799b	1	\N	\N	t	2026-03-17 12:22:57.686877+00	\N	\N	\N	\N
18	5e1e9967-e3c0-4875-9980-abeea850803d	CUARTOS IDA	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	376a502e-31a3-49b4-9506-b098a096e6fd	1	\N	\N	\N	\N	\N	t	2026-03-17 12:22:57.686877+00	\N	\N	\N	\N
17	5e1e9967-e3c0-4875-9980-abeea850803d	CUARTOS VUELTA	\N	\N	\N	2549f3dd-74dd-473b-be44-d5983b70e1ba	0db3e9a4-f193-4e4c-b97f-1e01997cb6f5	1	\N	\N	t	2026-03-17 12:22:57.686877+00	\N	\N	\N	\N
12	5e1e9967-e3c0-4875-9980-abeea850803d	CUARTOS IDA	c06aa55d-9cd6-4f14-8d85-6c5739913994	025c49a4-08e6-4057-b79f-2dc439f6799b	1	\N	\N	\N	\N	\N	t	2026-03-17 12:22:57.686877+00	\N	\N	\N	\N
14	5e1e9967-e3c0-4875-9980-abeea850803d	CUARTOS IDA	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	00dce6ca-e6c7-4177-acd6-52b58ab0ce1f	1	2f58705a-25ad-42c9-b953-5137532b3584	133484b4-e555-4157-9d71-9e545ec04521	1	1	3	t	2026-03-17 12:22:57.686877+00	\N	\N	\N	\N
15	5e1e9967-e3c0-4875-9980-abeea850803d	CUARTOS VUELTA	2f58705a-25ad-42c9-b953-5137532b3584	133484b4-e555-4157-9d71-9e545ec04521	1	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	00dce6ca-e6c7-4177-acd6-52b58ab0ce1f	1	2	1	t	2026-03-17 12:22:57.686877+00	\N	\N	\N	\N
20	5e1e9967-e3c0-4875-9980-abeea850803d	SEMIS	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	2f58705a-25ad-42c9-b953-5137532b3584	\N	\N	2	1	t	2026-03-17 12:22:57.820638+00	12	14	http://www.google.com	\N
21	5e1e9967-e3c0-4875-9980-abeea850803d	SEMIS	2549f3dd-74dd-473b-be44-d5983b70e1ba	\N	\N	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	\N	\N	2	1	t	2026-03-17 12:22:57.820638+00	16	18	\N	\N
22	5e1e9967-e3c0-4875-9980-abeea850803d	FINAL	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	2549f3dd-74dd-473b-be44-d5983b70e1ba	\N	\N	\N	\N	f	2026-03-17 12:22:57.92439+00	20	21	\N	\N
\.


--
-- Data for Name: match_playoff_streams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.match_playoff_streams (playoff_match_id, stream_url, updated_at) FROM stdin;
\.


--
-- Data for Name: match_streams; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.match_streams (match_id, stream_url, updated_at) FROM stdin;
29	https://www.twitch.tv/deasisfrancis/v/2718182905?sr=a	2026-03-09 20:32:40.389+00
31	https://discord.gg/YazeEmXE	2026-03-09 21:22:07.694+00
1	https://www.twitch.tv/iakksadj?sr=a	2026-03-09 20:54:25.823+00
3	https://www.twitch.tv/videos/2721544829	2026-03-13 21:32:29.265+00
\.


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matches (id, home_team, away_team, home_score, away_score, week, is_played, created_at, season, division) FROM stdin;
5	ff1dccb8-00bc-4042-a869-3a55773f3701	2f58705a-25ad-42c9-b953-5137532b3584	\N	\N	2	f	2026-03-05 09:55:52.787837+00	1	1
8	943a493d-044c-4c88-babc-e64804553bb4	16f4402c-a1b5-4431-8d98-c454f52a6284	\N	\N	2	f	2026-03-05 09:55:52.787837+00	1	1
9	2f58705a-25ad-42c9-b953-5137532b3584	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	3	f	2026-03-05 09:55:52.787837+00	1	1
11	8c1c7bba-636d-42f2-820a-ac1131897e84	943a493d-044c-4c88-babc-e64804553bb4	\N	\N	3	f	2026-03-05 09:55:52.787837+00	1	1
12	b5d23981-469b-4353-a615-9e4d6c8d8daf	16f4402c-a1b5-4431-8d98-c454f52a6284	\N	\N	3	f	2026-03-05 09:55:52.787837+00	1	1
14	943a493d-044c-4c88-babc-e64804553bb4	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	4	f	2026-03-05 09:55:52.787837+00	1	1
15	16f4402c-a1b5-4431-8d98-c454f52a6284	ff1dccb8-00bc-4042-a869-3a55773f3701	\N	\N	4	f	2026-03-05 09:55:52.787837+00	1	1
16	b5d23981-469b-4353-a615-9e4d6c8d8daf	8c1c7bba-636d-42f2-820a-ac1131897e84	\N	\N	4	f	2026-03-05 09:55:52.787837+00	1	1
17	2f58705a-25ad-42c9-b953-5137532b3584	943a493d-044c-4c88-babc-e64804553bb4	\N	\N	5	f	2026-03-05 09:55:52.787837+00	1	1
19	c06aa55d-9cd6-4f14-8d85-6c5739913994	b5d23981-469b-4353-a615-9e4d6c8d8daf	\N	\N	5	f	2026-03-05 09:55:52.787837+00	1	1
20	ff1dccb8-00bc-4042-a869-3a55773f3701	8c1c7bba-636d-42f2-820a-ac1131897e84	\N	\N	5	f	2026-03-05 09:55:52.787837+00	1	1
21	16f4402c-a1b5-4431-8d98-c454f52a6284	2f58705a-25ad-42c9-b953-5137532b3584	\N	\N	6	f	2026-03-05 09:55:52.787837+00	1	1
22	b5d23981-469b-4353-a615-9e4d6c8d8daf	943a493d-044c-4c88-babc-e64804553bb4	\N	\N	6	f	2026-03-05 09:55:52.787837+00	1	1
24	ff1dccb8-00bc-4042-a869-3a55773f3701	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	6	f	2026-03-05 09:55:52.787837+00	1	1
25	2f58705a-25ad-42c9-b953-5137532b3584	b5d23981-469b-4353-a615-9e4d6c8d8daf	\N	\N	7	f	2026-03-05 09:55:52.787837+00	1	1
26	16f4402c-a1b5-4431-8d98-c454f52a6284	8c1c7bba-636d-42f2-820a-ac1131897e84	\N	\N	7	f	2026-03-05 09:55:52.787837+00	1	1
27	943a493d-044c-4c88-babc-e64804553bb4	ff1dccb8-00bc-4042-a869-3a55773f3701	\N	\N	7	f	2026-03-05 09:55:52.787837+00	1	1
33	449ee91c-f52f-4661-abd4-ebfd556c37c3	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	\N	\N	2	f	2026-03-05 09:55:52.787837+00	1	2
34	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	2549f3dd-74dd-473b-be44-d5983b70e1ba	\N	\N	2	f	2026-03-05 09:55:52.787837+00	1	2
35	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	4d3815fd-7460-4eb3-a435-257850cd58ca	\N	\N	2	f	2026-03-05 09:55:52.787837+00	1	2
37	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	\N	\N	3	f	2026-03-05 09:55:52.787837+00	1	2
38	449ee91c-f52f-4661-abd4-ebfd556c37c3	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	\N	\N	3	f	2026-03-05 09:55:52.787837+00	1	2
40	4d3815fd-7460-4eb3-a435-257850cd58ca	00872e2b-9e9c-442f-810c-bfd62ee8a524	\N	\N	3	f	2026-03-05 09:55:52.787837+00	1	2
41	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	\N	\N	4	f	2026-03-05 09:55:52.787837+00	1	2
43	00872e2b-9e9c-442f-810c-bfd62ee8a524	449ee91c-f52f-4661-abd4-ebfd556c37c3	\N	\N	4	f	2026-03-05 09:55:52.787837+00	1	2
44	4d3815fd-7460-4eb3-a435-257850cd58ca	2549f3dd-74dd-473b-be44-d5983b70e1ba	\N	\N	4	f	2026-03-05 09:55:52.787837+00	1	2
46	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	00872e2b-9e9c-442f-810c-bfd62ee8a524	\N	\N	5	f	2026-03-05 09:55:52.787837+00	1	2
47	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	4d3815fd-7460-4eb3-a435-257850cd58ca	\N	\N	5	f	2026-03-05 09:55:52.787837+00	1	2
48	449ee91c-f52f-4661-abd4-ebfd556c37c3	2549f3dd-74dd-473b-be44-d5983b70e1ba	\N	\N	5	f	2026-03-05 09:55:52.787837+00	1	2
49	00872e2b-9e9c-442f-810c-bfd62ee8a524	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	\N	\N	6	f	2026-03-05 09:55:52.787837+00	1	2
51	2549f3dd-74dd-473b-be44-d5983b70e1ba	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	\N	\N	6	f	2026-03-05 09:55:52.787837+00	1	2
52	449ee91c-f52f-4661-abd4-ebfd556c37c3	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	\N	\N	6	f	2026-03-05 09:55:52.787837+00	1	2
53	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	4d3815fd-7460-4eb3-a435-257850cd58ca	\N	\N	7	f	2026-03-05 09:55:52.787837+00	1	2
54	00872e2b-9e9c-442f-810c-bfd62ee8a524	2549f3dd-74dd-473b-be44-d5983b70e1ba	\N	\N	7	f	2026-03-05 09:55:52.787837+00	1	2
56	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	\N	\N	7	f	2026-03-05 09:55:52.787837+00	1	2
29	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	2549f3dd-74dd-473b-be44-d5983b70e1ba	7	4	1	t	2026-03-05 09:55:52.787837+00	1	2
7	45ef0325-e165-4aef-8836-03099f1d7bd9	b5d23981-469b-4353-a615-9e4d6c8d8daf	\N	\N	2	f	2026-03-05 09:55:52.787837+00	1	1
31	00872e2b-9e9c-442f-810c-bfd62ee8a524	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	6	3	1	t	2026-03-05 09:55:52.787837+00	1	2
13	45ef0325-e165-4aef-8836-03099f1d7bd9	2f58705a-25ad-42c9-b953-5137532b3584	\N	\N	4	f	2026-03-05 09:55:52.787837+00	1	1
1	2f58705a-25ad-42c9-b953-5137532b3584	8c1c7bba-636d-42f2-820a-ac1131897e84	4	1	1	t	2026-03-05 09:55:52.787837+00	1	1
30	4d3815fd-7460-4eb3-a435-257850cd58ca	449ee91c-f52f-4661-abd4-ebfd556c37c3	1	4	1	t	2026-03-05 09:55:52.787837+00	1	2
18	45ef0325-e165-4aef-8836-03099f1d7bd9	16f4402c-a1b5-4431-8d98-c454f52a6284	\N	\N	5	f	2026-03-05 09:55:52.787837+00	1	1
36	c96625ad-9941-423c-8b5a-6fdc1b54ac20	00872e2b-9e9c-442f-810c-bfd62ee8a524	\N	\N	2	f	2026-03-05 09:55:52.787837+00	1	2
42	c96625ad-9941-423c-8b5a-6fdc1b54ac20	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	\N	\N	4	f	2026-03-05 09:55:52.787837+00	1	2
55	c96625ad-9941-423c-8b5a-6fdc1b54ac20	449ee91c-f52f-4661-abd4-ebfd556c37c3	\N	\N	7	f	2026-03-05 09:55:52.787837+00	1	2
39	2549f3dd-74dd-473b-be44-d5983b70e1ba	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	3	f	2026-03-05 09:55:52.787837+00	1	2
45	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	5	f	2026-03-05 09:55:52.787837+00	1	2
50	4d3815fd-7460-4eb3-a435-257850cd58ca	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	6	f	2026-03-05 09:55:52.787837+00	1	2
32	c96625ad-9941-423c-8b5a-6fdc1b54ac20	a9757a54-7b1b-4e90-a88e-2f03cc0ca478	3	6	1	t	2026-03-05 09:55:52.787837+00	1	2
2	b5d23981-469b-4353-a615-9e4d6c8d8daf	ff1dccb8-00bc-4042-a869-3a55773f3701	3	1	1	t	2026-03-05 09:55:52.787837+00	1	1
28	45ef0325-e165-4aef-8836-03099f1d7bd9	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	7	f	2026-03-05 09:55:52.787837+00	1	1
6	c06aa55d-9cd6-4f14-8d85-6c5739913994	8c1c7bba-636d-42f2-820a-ac1131897e84	\N	\N	2	f	2026-03-05 09:55:52.787837+00	1	1
4	943a493d-044c-4c88-babc-e64804553bb4	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	1	f	2026-03-05 09:55:52.787837+00	1	1
10	ff1dccb8-00bc-4042-a869-3a55773f3701	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	3	f	2026-03-05 09:55:52.787837+00	1	1
23	8c1c7bba-636d-42f2-820a-ac1131897e84	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	6	f	2026-03-05 09:55:52.787837+00	1	1
3	16f4402c-a1b5-4431-8d98-c454f52a6284	c06aa55d-9cd6-4f14-8d85-6c5739913994	4	3	1	t	2026-03-05 09:55:52.787837+00	1	1
\.


--
-- Data for Name: playoff_matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.playoff_matches (id, playoff_id, round, match_order, home_team, away_team, home_score, away_score, winner_id, next_match_id, played, start_date, end_date) FROM stdin;
\.


--
-- Data for Name: playoffs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.playoffs (id, created_at, name, season, is_active, settings, current_round, limit_ga_enabled, max_ga_playoff) FROM stdin;
\.


--
-- Data for Name: playoffs_extra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.playoffs_extra (id, season_id, nombre, tipo_format, jugadores_por_grupo, estado, created_at, config_eliminatorias, config_fechas, num_grupos, pasan_por_grupo, current_round, use_auto_round, stream_puntos) FROM stdin;
5e1e9967-e3c0-4875-9980-abeea850803d	1	rrrrrr	ida	4	activo	2026-03-17 12:22:56.219417+00	{"final": "ida", "semis": "ida", "cuartos": "ida_vuelta", "octavos": "ida", "dieciseisavos": "ida"}	{"j1": {"end_at": "2026-03-24T11:22:00.000Z", "start_at": "2026-03-17T11:22:00.000Z"}, "final": {"end_at": "2026-04-21T11:22:00.000Z", "start_at": "2026-04-14T11:22:00.000Z"}, "semis": {"end_at": "2026-04-14T11:22:00.000Z", "start_at": "2026-04-07T11:22:00.000Z"}, "cuartos_ida": {"end_at": "2026-03-31T11:22:00.000Z", "start_at": "2026-03-24T11:22:00.000Z"}, "cuartos_vuelta": {"end_at": "2026-04-07T11:22:00.000Z", "start_at": "2026-03-31T11:22:00.000Z"}}	5	1	semis	f	t
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, nick, email, avatar_url, is_confirmed, created_at, telegram_user, phone, is_admin, last_seen, is_colaborador) FROM stdin;
a9757a54-7b1b-4e90-a88e-2f03cc0ca478	payo_malo_89	mendyvillacity@gmail.com	\N	f	2026-02-19 23:23:42.876383+00		+34671998795	f	2026-03-14 15:13:48.132+00	f
b5d23981-469b-4353-a615-9e4d6c8d8daf	AdriWins	adrianruizmartos16@gmail.com	\N	f	2026-02-21 18:35:14.188818+00	\N	+34601520647	f	2026-03-15 11:26:43.674+00	f
38f98f64-f2db-47bf-a5ea-dcd1804ce00a	themule089	david.cvega89@gmail.com	\N	f	2026-03-01 09:34:43.210041+00		+34692675304	f	2026-03-16 08:53:55.57+00	f
8d16ce77-1836-4ce6-a462-b9d16358fb3f	Rubens_saga	muycontento10@hotmail.com	\N	f	2026-03-11 13:13:38.093043+00	\N	+34653038031	f	2026-03-16 19:27:15.401+00	f
00872e2b-9e9c-442f-810c-bfd62ee8a524	MELIODAS	mineclavelo11@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/00872e2b-9e9c-442f-810c-bfd62ee8a524.webp?t=1772270955942	f	2026-02-28 09:22:43.119146+00	@Carlos200593	+34641653508	f	2026-03-16 11:34:31.583+00	f
45ef0325-e165-4aef-8836-03099f1d7bd9	Chava_14	Luischava1234@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/45ef0325-e165-4aef-8836-03099f1d7bd9.webp?t=1773058181740	f	2026-03-09 11:59:20.35744+00	@chava_10	+34632657178	f	2026-03-09 16:51:59.391+00	f
c96625ad-9941-423c-8b5a-6fdc1b54ac20	SharkD	dari970417@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/c96625ad-9941-423c-8b5a-6fdc1b54ac20.webp?t=1773055989449	f	2026-03-09 11:32:15.759243+00		+34603377326	f	2026-03-16 12:09:04.375+00	f
16f4402c-a1b5-4431-8d98-c454f52a6284	Iker	ikerxu1985@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/16f4402c-a1b5-4431-8d98-c454f52a6284.webp?t=1773441143926	f	2026-03-02 22:26:22.572768+00		+34619776212	f	2026-03-17 01:06:55.542+00	f
2549f3dd-74dd-473b-be44-d5983b70e1ba	Franchesco	francisaditrap@gmail.com	\N	f	2026-02-25 11:51:26.140575+00	\N	+34692547413	f	2026-03-09 20:39:07.096+00	f
2f58705a-25ad-42c9-b953-5137532b3584	Selu 	Jluisdiazmaroto@gmail.com	\N	f	2026-03-01 19:03:49.128611+00	\N	+34684218724	f	2026-03-15 19:07:50.264+00	f
449ee91c-f52f-4661-abd4-ebfd556c37c3	Hukha	hukha221@gmail.com	\N	f	2026-02-25 11:50:01.84082+00	@JamesDevG	\N	f	2026-03-10 18:41:02.091+00	f
eae8c25a-a99d-480f-8e3e-854d36c5c8dc	Jeybiss	57juanjose57@gmail.com	\N	f	2026-02-26 13:49:18.323124+00	\N	+48511397460	f	2026-03-15 19:16:26.683+00	f
4d3815fd-7460-4eb3-a435-257850cd58ca	Piedr4hita11	santipiedrahita7@gmail.com	\N	f	2026-02-26 17:35:59.322688+00	\N	+573172699704	f	2026-03-15 13:08:22.468+00	f
943a493d-044c-4c88-babc-e64804553bb4	Angel_Rico	Angel_fgrico@hotmail.com	\N	f	2026-02-25 19:24:06.029584+00	@angelvk	+34626179294	f	2026-03-16 15:53:44.198+00	f
84cdd50e-ef22-4022-aeca-60bfe32b6018	Retirado (Seventowers)	retirado_1773650490028@liga.com	\N	f	2026-03-04 14:14:20.10833+00	\N	\N	f	2026-03-04 14:46:53.979+00	f
e2c0c4df-3aba-4f3e-9511-49df6b02b87b	Retirado (Javi GT)	retirado_1773650523716@liga.com	\N	f	2026-02-17 15:36:20.287975+00	\N	\N	f	2026-03-15 13:22:16.321+00	f
8c1c7bba-636d-42f2-820a-ac1131897e84	Don Ptr Squad	pedrorodriguezmoya83@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/8c1c7bba-636d-42f2-820a-ac1131897e84.webp?t=1772706351861	f	2026-02-28 11:22:16.409045+00	@donptrsquad	+34615475002	f	2026-03-16 08:45:17.671+00	f
ff1dccb8-00bc-4042-a869-3a55773f3701	errejota	rjgcolino@gmail.com	\N	f	2026-02-16 15:24:06.155978+00	@rrjjggcc	+34665957216	f	2026-03-16 16:18:17.344+00	f
c06aa55d-9cd6-4f14-8d85-6c5739913994	Mr.Macson	jhortolano@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/c06aa55d-9cd6-4f14-8d85-6c5739913994.webp?t=1771253637914	f	2026-02-16 14:41:52.426307+00	@jl_hvv	+34655391764	t	2026-03-17 13:53:56.448+00	f
\.


--
-- Data for Name: season_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.season_rules (season, bonus_enabled, bonus_min_percentage, bonus_points, updated_at, limit_ga_enabled, max_ga_league) FROM stdin;
1	t	80	2	2026-03-01 20:09:45.744502+00	t	3
\.


--
-- Data for Name: votos_encuesta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.votos_encuesta (id, encuesta_id, usuario_id, opcion_index, created_at) FROM stdin;
7b033e1a-a3b2-4e5d-a746-3fb190adc118	d222b220-a0c5-4783-bc0c-03a827e0f888	c06aa55d-9cd6-4f14-8d85-6c5739913994	0	2026-03-15 10:00:43.545139+00
42f3f103-3298-44fc-8f0a-ae7f8afb6420	d222b220-a0c5-4783-bc0c-03a827e0f888	c96625ad-9941-423c-8b5a-6fdc1b54ac20	0	2026-03-15 10:00:43.70634+00
9ea5142b-53d1-44cb-baa4-2530001d27eb	d222b220-a0c5-4783-bc0c-03a827e0f888	16f4402c-a1b5-4431-8d98-c454f52a6284	0	2026-03-15 10:09:38.914376+00
8c193dd2-34e6-4e6b-965a-89a47c777506	d222b220-a0c5-4783-bc0c-03a827e0f888	00872e2b-9e9c-442f-810c-bfd62ee8a524	0	2026-03-15 10:38:58.457927+00
319a09d9-30ad-4048-ad7d-21a10e546d45	d222b220-a0c5-4783-bc0c-03a827e0f888	ff1dccb8-00bc-4042-a869-3a55773f3701	0	2026-03-15 11:53:38.782662+00
cf041a0d-7f7b-423d-ae8e-9299bf5a8b10	d222b220-a0c5-4783-bc0c-03a827e0f888	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	0	2026-03-15 12:37:58.140284+00
c1af288a-1476-4c1e-a77d-835b7df9a71c	d222b220-a0c5-4783-bc0c-03a827e0f888	4d3815fd-7460-4eb3-a435-257850cd58ca	0	2026-03-15 13:04:31.367371+00
4b4199ab-55b4-4998-ad64-6ea977a39093	d222b220-a0c5-4783-bc0c-03a827e0f888	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	0	2026-03-16 08:28:07.002025+00
94f7599f-9dc4-4d4f-8eca-48c6dcb95058	d222b220-a0c5-4783-bc0c-03a827e0f888	8d16ce77-1836-4ce6-a462-b9d16358fb3f	0	2026-03-16 15:07:47.293199+00
0e3c47a4-a67e-4bf0-a2c5-1bd9322d192b	d222b220-a0c5-4783-bc0c-03a827e0f888	943a493d-044c-4c88-babc-e64804553bb4	0	2026-03-16 15:53:50.022757+00
\.


--
-- Data for Name: weeks_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weeks_schedule (id, season, week, start_at, end_at, is_linked) FROM stdin;
47	1	1	2026-03-08 23:00:00+00	2026-03-15 23:00:00+00	f
48	1	2	2026-03-15 23:00:00+00	2026-03-22 23:00:00+00	f
49	1	3	2026-03-22 23:00:00+00	2026-03-29 22:00:00+00	f
50	1	4	2026-03-29 22:00:00+00	2026-04-05 22:00:00+00	f
51	1	5	2026-04-05 22:00:00+00	2026-04-12 22:00:00+00	f
52	1	6	2026-04-12 22:00:00+00	2026-04-19 22:00:00+00	f
53	1	7	2026-04-19 22:00:00+00	2026-04-26 22:00:00+00	f
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-02-15 15:33:44
20211116045059	2026-02-15 15:33:44
20211116050929	2026-02-16 12:00:48
20211116051442	2026-02-16 12:00:48
20211116212300	2026-02-16 12:00:48
20211116213355	2026-02-16 12:00:49
20211116213934	2026-02-16 12:00:49
20211116214523	2026-02-16 12:00:50
20211122062447	2026-02-16 12:00:50
20211124070109	2026-02-16 12:00:51
20211202204204	2026-02-16 12:00:51
20211202204605	2026-02-16 12:00:51
20211210212804	2026-02-16 12:00:53
20211228014915	2026-02-16 12:00:53
20220107221237	2026-02-16 12:00:54
20220228202821	2026-02-16 12:00:54
20220312004840	2026-02-16 12:00:54
20220603231003	2026-02-16 12:00:55
20220603232444	2026-02-16 12:00:55
20220615214548	2026-02-16 12:00:56
20220712093339	2026-02-16 12:00:56
20220908172859	2026-02-16 12:00:57
20220916233421	2026-02-16 12:00:57
20230119133233	2026-02-16 12:00:57
20230128025114	2026-02-16 12:00:58
20230128025212	2026-02-16 12:00:58
20230227211149	2026-02-16 12:00:59
20230228184745	2026-02-16 12:00:59
20230308225145	2026-02-16 12:00:59
20230328144023	2026-02-16 12:01:00
20231018144023	2026-02-16 12:01:00
20231204144023	2026-02-16 12:01:01
20231204144024	2026-02-16 12:01:01
20231204144025	2026-02-16 12:01:02
20240108234812	2026-02-16 12:01:02
20240109165339	2026-02-16 12:01:02
20240227174441	2026-02-16 12:01:03
20240311171622	2026-02-16 12:01:04
20240321100241	2026-02-16 12:01:04
20240401105812	2026-02-16 12:01:05
20240418121054	2026-02-16 12:01:06
20240523004032	2026-02-16 12:01:07
20240618124746	2026-02-16 12:01:08
20240801235015	2026-02-16 12:01:08
20240805133720	2026-02-16 12:01:08
20240827160934	2026-02-16 12:01:09
20240919163303	2026-02-16 12:01:09
20240919163305	2026-02-16 12:01:10
20241019105805	2026-02-16 12:01:10
20241030150047	2026-02-16 12:01:12
20241108114728	2026-02-16 12:01:12
20241121104152	2026-02-16 12:01:12
20241130184212	2026-02-16 12:01:13
20241220035512	2026-02-16 12:01:13
20241220123912	2026-02-16 12:01:14
20241224161212	2026-02-16 12:01:14
20250107150512	2026-02-16 12:01:14
20250110162412	2026-02-16 12:01:15
20250123174212	2026-02-16 12:01:15
20250128220012	2026-02-16 12:01:16
20250506224012	2026-02-16 12:01:16
20250523164012	2026-02-16 12:01:16
20250714121412	2026-02-16 12:01:17
20250905041441	2026-02-16 12:01:17
20251103001201	2026-02-16 12:01:17
20251120212548	2026-02-16 12:01:18
20251120215549	2026-02-16 12:01:18
20260218120000	2026-03-01 19:16:46
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
avatars	avatars	\N	2026-02-04 13:50:38.631077+00	2026-02-04 13:50:38.631077+00	t	f	\N	\N	\N	STANDARD
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-02-15 15:33:45.136952
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-02-15 15:33:45.1459
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-02-15 15:33:46.70283
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-02-15 15:33:46.760376
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-02-15 15:33:46.774194
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-02-15 15:33:46.781947
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-02-15 15:33:46.79051
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-02-15 15:33:46.798806
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-02-15 15:33:46.806808
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-02-15 15:33:46.815122
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-02-15 15:33:46.823371
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-02-15 15:33:46.832533
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-02-15 15:33:46.841046
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-02-15 15:33:46.849438
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-02-15 15:33:46.857703
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-02-15 15:33:46.890583
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-02-15 15:33:46.898938
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-02-15 15:33:46.907736
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-02-15 15:33:46.915713
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-02-15 15:33:46.926253
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-02-15 15:33:46.934503
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-02-15 15:33:46.944359
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-02-15 15:33:46.960456
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-02-15 15:33:46.973794
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-02-15 15:33:46.982052
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-02-15 15:33:46.990222
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-02-15 15:33:46.998802
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-02-15 15:33:47.006647
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-02-15 15:33:47.014234
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-02-15 15:33:47.02199
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-02-15 15:33:47.029676
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-02-15 15:33:47.03739
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-02-15 15:33:47.045012
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-02-15 15:33:47.052692
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-02-15 15:33:47.06041
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-02-15 15:33:47.068233
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-02-15 15:33:47.076027
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-02-15 15:33:47.083886
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-02-15 15:33:47.092644
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-02-15 15:33:47.105165
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-02-15 15:33:47.112789
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-02-15 15:33:47.120393
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-02-15 15:33:47.128105
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-02-15 15:33:47.135808
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-02-15 15:33:47.143633
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-02-15 15:33:47.152065
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-02-15 15:33:47.166771
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-02-15 15:33:47.175165
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-02-15 15:33:47.183062
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-02-15 15:33:47.200767
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-02-15 15:33:47.209202
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-02-15 15:33:47.433721
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-02-15 15:33:47.436752
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-02-15 15:33:47.451912
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-02-15 15:33:47.4568
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-02-15 15:33:47.45961
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-02-15 15:33:47.468508
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 643, true);


--
-- Name: config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.config_id_seq', 1, false);


--
-- Name: extra_playoffs_matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.extra_playoffs_matches_id_seq', 22, true);


--
-- Name: matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matches_id_seq', 56, true);


--
-- Name: weeks_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weeks_schedule_id_seq', 53, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: supabase_admin
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: avisos avisos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.avisos
    ADD CONSTRAINT avisos_pkey PRIMARY KEY (id);


--
-- Name: config config_current_season_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config
    ADD CONSTRAINT config_current_season_unique UNIQUE (current_season);


--
-- Name: config config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.config
    ADD CONSTRAINT config_pkey PRIMARY KEY (id);


--
-- Name: encuestas encuestas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encuestas
    ADD CONSTRAINT encuestas_pkey PRIMARY KEY (id);


--
-- Name: extra_groups extra_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_groups
    ADD CONSTRAINT extra_groups_pkey PRIMARY KEY (id);


--
-- Name: extra_matches extra_matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_matches
    ADD CONSTRAINT extra_matches_pkey PRIMARY KEY (id);


--
-- Name: extra_playoffs_matches extra_playoffs_matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_playoffs_matches
    ADD CONSTRAINT extra_playoffs_matches_pkey PRIMARY KEY (id);


--
-- Name: match_playoff_streams match_playoff_streams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_playoff_streams
    ADD CONSTRAINT match_playoff_streams_pkey PRIMARY KEY (playoff_match_id);


--
-- Name: match_streams match_streams_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_streams
    ADD CONSTRAINT match_streams_pkey PRIMARY KEY (match_id);


--
-- Name: matches matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_pkey PRIMARY KEY (id);


--
-- Name: match_playoff_streams playoff_match_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_playoff_streams
    ADD CONSTRAINT playoff_match_id_unique UNIQUE (playoff_match_id);


--
-- Name: playoff_matches playoff_matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playoff_matches
    ADD CONSTRAINT playoff_matches_pkey PRIMARY KEY (id);


--
-- Name: playoffs_extra playoffs_extra_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playoffs_extra
    ADD CONSTRAINT playoffs_extra_pkey PRIMARY KEY (id);


--
-- Name: playoffs playoffs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playoffs
    ADD CONSTRAINT playoffs_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_nick_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_nick_key UNIQUE (nick);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: season_rules season_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.season_rules
    ADD CONSTRAINT season_rules_pkey PRIMARY KEY (season);


--
-- Name: extra_playoffs_matches unique_match_path; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_playoffs_matches
    ADD CONSTRAINT unique_match_path UNIQUE (playoff_extra_id, numero_jornada, p1_from_match_id, p2_from_match_id);


--
-- Name: playoff_matches unique_match_per_round; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playoff_matches
    ADD CONSTRAINT unique_match_per_round UNIQUE (playoff_id, round, match_order);


--
-- Name: votos_encuesta votos_encuesta_encuesta_id_usuario_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votos_encuesta
    ADD CONSTRAINT votos_encuesta_encuesta_id_usuario_id_key UNIQUE (encuesta_id, usuario_id);


--
-- Name: votos_encuesta votos_encuesta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votos_encuesta
    ADD CONSTRAINT votos_encuesta_pkey PRIMARY KEY (id);


--
-- Name: weeks_schedule weeks_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weeks_schedule
    ADD CONSTRAINT weeks_schedule_pkey PRIMARY KEY (id);


--
-- Name: weeks_schedule weeks_schedule_season_week_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weeks_schedule
    ADD CONSTRAINT weeks_schedule_season_week_key UNIQUE (season, week);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: supabase_admin
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: idx_profiles_last_seen; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_profiles_last_seen ON public.profiles USING btree (last_seen);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: supabase_realtime_admin
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: supabase_auth_admin
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: supabase_admin
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: encuestas encuestas_creador_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.encuestas
    ADD CONSTRAINT encuestas_creador_id_fkey FOREIGN KEY (creador_id) REFERENCES auth.users(id);


--
-- Name: extra_groups extra_groups_extra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_groups
    ADD CONSTRAINT extra_groups_extra_id_fkey FOREIGN KEY (extra_id) REFERENCES public.playoffs_extra(id) ON DELETE CASCADE;


--
-- Name: extra_matches extra_matches_extra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_matches
    ADD CONSTRAINT extra_matches_extra_id_fkey FOREIGN KEY (extra_id) REFERENCES public.playoffs_extra(id) ON DELETE CASCADE;


--
-- Name: extra_matches extra_matches_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_matches
    ADD CONSTRAINT extra_matches_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.extra_groups(id) ON DELETE SET NULL;


--
-- Name: extra_matches extra_matches_next_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_matches
    ADD CONSTRAINT extra_matches_next_match_id_fkey FOREIGN KEY (next_match_id) REFERENCES public.extra_matches(id);


--
-- Name: extra_matches extra_matches_player1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_matches
    ADD CONSTRAINT extra_matches_player1_id_fkey FOREIGN KEY (player1_id) REFERENCES public.profiles(id);


--
-- Name: extra_matches extra_matches_player2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_matches
    ADD CONSTRAINT extra_matches_player2_id_fkey FOREIGN KEY (player2_id) REFERENCES public.profiles(id);


--
-- Name: extra_playoffs_matches extra_playoffs_matches_group_id_p1_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_playoffs_matches
    ADD CONSTRAINT extra_playoffs_matches_group_id_p1_fkey FOREIGN KEY (group_id_p1) REFERENCES public.extra_groups(id);


--
-- Name: extra_playoffs_matches extra_playoffs_matches_group_id_p2_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_playoffs_matches
    ADD CONSTRAINT extra_playoffs_matches_group_id_p2_fkey FOREIGN KEY (group_id_p2) REFERENCES public.extra_groups(id);


--
-- Name: extra_playoffs_matches extra_playoffs_matches_p1_from_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_playoffs_matches
    ADD CONSTRAINT extra_playoffs_matches_p1_from_match_id_fkey FOREIGN KEY (p1_from_match_id) REFERENCES public.extra_playoffs_matches(id);


--
-- Name: extra_playoffs_matches extra_playoffs_matches_p2_from_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_playoffs_matches
    ADD CONSTRAINT extra_playoffs_matches_p2_from_match_id_fkey FOREIGN KEY (p2_from_match_id) REFERENCES public.extra_playoffs_matches(id);


--
-- Name: extra_playoffs_matches extra_playoffs_matches_player1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_playoffs_matches
    ADD CONSTRAINT extra_playoffs_matches_player1_id_fkey FOREIGN KEY (player1_id) REFERENCES public.profiles(id);


--
-- Name: extra_playoffs_matches extra_playoffs_matches_player2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_playoffs_matches
    ADD CONSTRAINT extra_playoffs_matches_player2_id_fkey FOREIGN KEY (player2_id) REFERENCES public.profiles(id);


--
-- Name: extra_playoffs_matches extra_playoffs_matches_playoff_extra_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.extra_playoffs_matches
    ADD CONSTRAINT extra_playoffs_matches_playoff_extra_id_fkey FOREIGN KEY (playoff_extra_id) REFERENCES public.playoffs_extra(id) ON DELETE CASCADE;


--
-- Name: match_playoff_streams fk_match_playoff; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_playoff_streams
    ADD CONSTRAINT fk_match_playoff FOREIGN KEY (playoff_match_id) REFERENCES public.playoff_matches(id) ON DELETE CASCADE;


--
-- Name: match_playoff_streams match_playoff_streams_playoff_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_playoff_streams
    ADD CONSTRAINT match_playoff_streams_playoff_match_id_fkey FOREIGN KEY (playoff_match_id) REFERENCES public.playoff_matches(id) ON DELETE CASCADE;


--
-- Name: match_streams match_streams_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.match_streams
    ADD CONSTRAINT match_streams_match_id_fkey FOREIGN KEY (match_id) REFERENCES public.matches(id) ON DELETE CASCADE;


--
-- Name: matches matches_away_team_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_away_team_fkey FOREIGN KEY (away_team) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: matches matches_home_team_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches
    ADD CONSTRAINT matches_home_team_fkey FOREIGN KEY (home_team) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: playoff_matches playoff_matches_away_team_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playoff_matches
    ADD CONSTRAINT playoff_matches_away_team_fkey FOREIGN KEY (away_team) REFERENCES public.profiles(id);


--
-- Name: playoff_matches playoff_matches_home_team_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playoff_matches
    ADD CONSTRAINT playoff_matches_home_team_fkey FOREIGN KEY (home_team) REFERENCES public.profiles(id);


--
-- Name: playoff_matches playoff_matches_next_match_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playoff_matches
    ADD CONSTRAINT playoff_matches_next_match_id_fkey FOREIGN KEY (next_match_id) REFERENCES public.playoff_matches(id);


--
-- Name: playoff_matches playoff_matches_playoff_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playoff_matches
    ADD CONSTRAINT playoff_matches_playoff_id_fkey FOREIGN KEY (playoff_id) REFERENCES public.playoffs(id) ON DELETE CASCADE;


--
-- Name: playoff_matches playoff_matches_winner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playoff_matches
    ADD CONSTRAINT playoff_matches_winner_id_fkey FOREIGN KEY (winner_id) REFERENCES public.profiles(id);


--
-- Name: playoffs_extra playoffs_extra_season_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.playoffs_extra
    ADD CONSTRAINT playoffs_extra_season_id_fkey FOREIGN KEY (season_id) REFERENCES public.season_rules(season) ON DELETE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: votos_encuesta votos_encuesta_encuesta_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votos_encuesta
    ADD CONSTRAINT votos_encuesta_encuesta_id_fkey FOREIGN KEY (encuesta_id) REFERENCES public.encuestas(id) ON DELETE CASCADE;


--
-- Name: votos_encuesta votos_encuesta_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.votos_encuesta
    ADD CONSTRAINT votos_encuesta_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: match_streams Acceso autenticados; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Acceso autenticados" ON public.match_streams USING ((auth.role() = 'authenticated'::text));


--
-- Name: avisos Acceso total para usuarios autenticados; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Acceso total para usuarios autenticados" ON public.avisos TO authenticated USING (true) WITH CHECK (true);


--
-- Name: playoffs_extra Admin delete extra; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin delete extra" ON public.playoffs_extra FOR DELETE USING ((auth.role() = 'authenticated'::text));


--
-- Name: extra_groups Admin gestión grupos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin gestión grupos" ON public.extra_groups USING ((auth.role() = 'authenticated'::text));


--
-- Name: extra_matches Admin gestión partidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin gestión partidos" ON public.extra_matches USING ((auth.role() = 'authenticated'::text));


--
-- Name: playoffs_extra Admin insert extra; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin insert extra" ON public.playoffs_extra FOR INSERT WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: playoffs_extra Admin update extra; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin update extra" ON public.playoffs_extra FOR UPDATE USING ((auth.role() = 'authenticated'::text));


--
-- Name: playoff_matches Admins gestionan partidos de playoff; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins gestionan partidos de playoff" ON public.playoff_matches TO authenticated USING ((auth.uid() IN ( SELECT profiles.id
   FROM public.profiles
  WHERE (profiles.is_admin = true))));


--
-- Name: playoffs Admins gestionan playoffs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins gestionan playoffs" ON public.playoffs TO authenticated USING ((auth.uid() IN ( SELECT profiles.id
   FROM public.profiles
  WHERE (profiles.is_admin = true))));


--
-- Name: config Admins pueden actualizar config; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins pueden actualizar config" ON public.config FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))));


--
-- Name: matches Admins pueden insertar partidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admins pueden insertar partidos" ON public.matches FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))));


--
-- Name: matches Colaboradores pueden actualizar resultados; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Colaboradores pueden actualizar resultados" ON public.matches FOR UPDATE TO authenticated USING (((( SELECT profiles.is_admin
   FROM public.profiles
  WHERE (profiles.id = auth.uid())) = true) OR (( SELECT profiles.is_colaborador
   FROM public.profiles
  WHERE (profiles.id = auth.uid())) = true)));


--
-- Name: match_streams Lectura pública; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública" ON public.match_streams FOR SELECT USING (true);


--
-- Name: profiles Lectura pública; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública" ON public.profiles FOR SELECT TO authenticated, anon USING (true);


--
-- Name: config Lectura pública de configuración; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública de configuración" ON public.config FOR SELECT USING (true);


--
-- Name: profiles Lectura pública de perfiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública de perfiles" ON public.profiles FOR SELECT USING (true);


--
-- Name: playoffs_extra Lectura pública extra; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública extra" ON public.playoffs_extra FOR SELECT USING (true);


--
-- Name: extra_matches Lectura pública extra_matches; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública extra_matches" ON public.extra_matches FOR SELECT USING (true);


--
-- Name: extra_groups Lectura pública grupos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública grupos" ON public.extra_groups FOR SELECT USING (true);


--
-- Name: extra_matches Lectura pública partidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública partidos" ON public.extra_matches FOR SELECT USING (true);


--
-- Name: profiles Lectura pública profiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública profiles" ON public.profiles FOR SELECT USING (true);


--
-- Name: avisos Lectura pública si está activo; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública si está activo" ON public.avisos FOR SELECT TO authenticated, anon USING ((mostrar = true));


--
-- Name: profiles Los perfiles son visibles para todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Los perfiles son visibles para todos" ON public.profiles FOR SELECT USING (true);


--
-- Name: profiles Los usuarios solo pueden editar su propio perfil; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Los usuarios solo pueden editar su propio perfil" ON public.profiles FOR UPDATE TO authenticated USING ((auth.uid() = id)) WITH CHECK ((auth.uid() = id));


--
-- Name: matches Matches visibles para todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Matches visibles para todos" ON public.matches FOR SELECT USING (true);


--
-- Name: playoff_matches Partidos de playoff visibles para todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Partidos de playoff visibles para todos" ON public.playoff_matches FOR SELECT USING (true);


--
-- Name: profiles Permitir actualización de perfiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir actualización de perfiles" ON public.profiles FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: matches Permitir borrar a todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir borrar a todos" ON public.matches FOR DELETE USING (true);


--
-- Name: weeks_schedule Permitir borrar semanas; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir borrar semanas" ON public.weeks_schedule FOR DELETE USING (true);


--
-- Name: profiles Permitir inserción; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir inserción" ON public.profiles FOR INSERT TO authenticated WITH CHECK ((auth.uid() = id));


--
-- Name: match_playoff_streams Permitir inserción y actualización de streams de playoff; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir inserción y actualización de streams de playoff" ON public.match_playoff_streams TO authenticated, anon USING (true) WITH CHECK (true);


--
-- Name: playoff_matches Permitir insertar ganador en siguiente fase; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir insertar ganador en siguiente fase" ON public.playoff_matches FOR UPDATE TO authenticated USING (true) WITH CHECK (((home_team IS NULL) OR (away_team IS NULL) OR (auth.uid() = home_team) OR (auth.uid() = away_team)));


--
-- Name: extra_playoffs_matches Permitir lectura a todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura a todos" ON public.extra_playoffs_matches FOR SELECT TO authenticated, anon USING (true);


--
-- Name: matches Permitir lectura pública de partidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura pública de partidos" ON public.matches FOR SELECT TO anon USING (true);


--
-- Name: profiles Permitir lectura pública de perfiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura pública de perfiles" ON public.profiles FOR SELECT TO anon USING (true);


--
-- Name: match_playoff_streams Permitir lectura pública de streams de playoff; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura pública de streams de playoff" ON public.match_playoff_streams FOR SELECT USING (true);


--
-- Name: profiles Permitir registro inicial; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir registro inicial" ON public.profiles FOR INSERT WITH CHECK (true);


--
-- Name: extra_playoffs_matches Permitir todo a autenticados; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir todo a autenticados" ON public.extra_playoffs_matches TO authenticated USING (true) WITH CHECK (true);


--
-- Name: weeks_schedule Permitir todo a autenticados; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir todo a autenticados" ON public.weeks_schedule TO authenticated USING (true) WITH CHECK (true);


--
-- Name: season_rules Permitir todo a usuarios autenticados; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir todo a usuarios autenticados" ON public.season_rules TO authenticated USING (true) WITH CHECK (true);


--
-- Name: profiles Permitir update; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir update" ON public.profiles FOR UPDATE TO authenticated USING ((auth.uid() = id));


--
-- Name: matches Permitir update a todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir update a todos" ON public.matches FOR UPDATE USING (true) WITH CHECK (true);


--
-- Name: profiles Permitir update propio; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir update propio" ON public.profiles FOR UPDATE USING ((auth.uid() = id));


--
-- Name: playoff_matches Permitir_Posteo_Y_Promocion; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir_Posteo_Y_Promocion" ON public.playoff_matches FOR UPDATE TO authenticated USING (((auth.uid() = home_team) OR (auth.uid() = away_team) OR (home_team IS NULL) OR (away_team IS NULL))) WITH CHECK (true);


--
-- Name: playoffs Playoffs visibles para todos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Playoffs visibles para todos" ON public.playoffs FOR SELECT USING (true);


--
-- Name: encuestas Solo admins pueden gestionar encuestas; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Solo admins pueden gestionar encuestas" ON public.encuestas TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.profiles
  WHERE ((profiles.id = auth.uid()) AND (profiles.is_admin = true)))));


--
-- Name: weeks_schedule Solo usuarios autenticados ven semanas; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Solo usuarios autenticados ven semanas" ON public.weeks_schedule FOR SELECT TO authenticated USING (true);


--
-- Name: encuestas Todo el mundo puede ver encuestas activas; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Todo el mundo puede ver encuestas activas" ON public.encuestas FOR SELECT USING (true);


--
-- Name: votos_encuesta Usuarios pueden ver todos los votos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios pueden ver todos los votos" ON public.votos_encuesta FOR SELECT USING (true);


--
-- Name: votos_encuesta Usuarios pueden votar; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios pueden votar" ON public.votos_encuesta FOR INSERT TO authenticated WITH CHECK ((auth.uid() = usuario_id));


--
-- Name: votos_encuesta Usuarios pueden votar y cambiar su voto; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Usuarios pueden votar y cambiar su voto" ON public.votos_encuesta TO authenticated USING ((auth.uid() = usuario_id)) WITH CHECK ((auth.uid() = usuario_id));


--
-- Name: avisos; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.avisos ENABLE ROW LEVEL SECURITY;

--
-- Name: config; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.config ENABLE ROW LEVEL SECURITY;

--
-- Name: encuestas; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.encuestas ENABLE ROW LEVEL SECURITY;

--
-- Name: extra_groups; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.extra_groups ENABLE ROW LEVEL SECURITY;

--
-- Name: extra_matches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.extra_matches ENABLE ROW LEVEL SECURITY;

--
-- Name: match_playoff_streams; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.match_playoff_streams ENABLE ROW LEVEL SECURITY;

--
-- Name: match_streams; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.match_streams ENABLE ROW LEVEL SECURITY;

--
-- Name: matches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.matches ENABLE ROW LEVEL SECURITY;

--
-- Name: playoff_matches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.playoff_matches ENABLE ROW LEVEL SECURITY;

--
-- Name: playoffs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.playoffs ENABLE ROW LEVEL SECURITY;

--
-- Name: playoffs_extra; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.playoffs_extra ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: season_rules; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.season_rules ENABLE ROW LEVEL SECURITY;

--
-- Name: votos_encuesta; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.votos_encuesta ENABLE ROW LEVEL SECURITY;

--
-- Name: weeks_schedule; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.weeks_schedule ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: supabase_realtime_admin
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Acceso publico de lectura 1oj01fe_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Acceso publico de lectura 1oj01fe_0" ON storage.objects FOR SELECT USING (true);


--
-- Name: objects Subida para usuarios autenticados 1oj01fe_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Subida para usuarios autenticados 1oj01fe_0" ON storage.objects FOR INSERT TO authenticated WITH CHECK ((auth.role() = 'authenticated'::text));


--
-- Name: objects Subida para usuarios autenticados 1oj01fe_1; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Subida para usuarios autenticados 1oj01fe_1" ON storage.objects FOR UPDATE TO authenticated USING ((auth.role() = 'authenticated'::text));


--
-- Name: objects Subida para usuarios autenticados 1oj01fe_2; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Subida para usuarios autenticados 1oj01fe_2" ON storage.objects FOR SELECT TO authenticated USING ((auth.role() = 'authenticated'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO anon;
GRANT ALL ON SCHEMA public TO authenticated;
GRANT ALL ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA storage TO anon;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA storage TO authenticated;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA storage TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA storage TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;
SET SESSION AUTHORIZATION postgres;
GRANT USAGE ON SCHEMA vault TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: supabase_admin
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.flow_state TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.flow_state TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.identities TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.identities TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.identities TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.instances TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.instances TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.instances TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_providers TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_providers TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.schema_migrations TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.schema_migrations TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sessions TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sessions TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_domains TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_domains TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_providers TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_providers TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.users TO dashboard_user;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.users TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.users TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE avisos; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.avisos TO anon;
GRANT ALL ON TABLE public.avisos TO authenticated;
GRANT ALL ON TABLE public.avisos TO service_role;


--
-- Name: TABLE matches; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.matches TO anon;
GRANT ALL ON TABLE public.matches TO authenticated;
GRANT ALL ON TABLE public.matches TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE clasificacion; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.clasificacion TO anon;
GRANT ALL ON TABLE public.clasificacion TO authenticated;
GRANT ALL ON TABLE public.clasificacion TO service_role;


--
-- Name: TABLE config; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.config TO anon;
GRANT ALL ON TABLE public.config TO authenticated;
GRANT ALL ON TABLE public.config TO service_role;


--
-- Name: SEQUENCE config_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.config_id_seq TO anon;
GRANT ALL ON SEQUENCE public.config_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.config_id_seq TO service_role;


--
-- Name: TABLE encuestas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.encuestas TO anon;
GRANT ALL ON TABLE public.encuestas TO authenticated;
GRANT ALL ON TABLE public.encuestas TO service_role;


--
-- Name: TABLE extra_groups; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.extra_groups TO anon;
GRANT ALL ON TABLE public.extra_groups TO authenticated;
GRANT ALL ON TABLE public.extra_groups TO service_role;


--
-- Name: TABLE extra_matches; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.extra_matches TO anon;
GRANT ALL ON TABLE public.extra_matches TO authenticated;
GRANT ALL ON TABLE public.extra_matches TO service_role;


--
-- Name: TABLE extra_playoffs_clasificacion; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.extra_playoffs_clasificacion TO anon;
GRANT ALL ON TABLE public.extra_playoffs_clasificacion TO authenticated;
GRANT ALL ON TABLE public.extra_playoffs_clasificacion TO service_role;


--
-- Name: TABLE extra_playoffs_matches; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.extra_playoffs_matches TO anon;
GRANT ALL ON TABLE public.extra_playoffs_matches TO authenticated;
GRANT ALL ON TABLE public.extra_playoffs_matches TO service_role;


--
-- Name: SEQUENCE extra_playoffs_matches_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.extra_playoffs_matches_id_seq TO anon;
GRANT ALL ON SEQUENCE public.extra_playoffs_matches_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.extra_playoffs_matches_id_seq TO service_role;


--
-- Name: TABLE match_playoff_streams; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.match_playoff_streams TO anon;
GRANT ALL ON TABLE public.match_playoff_streams TO authenticated;
GRANT ALL ON TABLE public.match_playoff_streams TO service_role;


--
-- Name: TABLE match_streams; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.match_streams TO anon;
GRANT ALL ON TABLE public.match_streams TO authenticated;
GRANT ALL ON TABLE public.match_streams TO service_role;


--
-- Name: SEQUENCE matches_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.matches_id_seq TO anon;
GRANT ALL ON SEQUENCE public.matches_id_seq TO authenticated;


--
-- Name: TABLE partidos_detallados; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.partidos_detallados TO anon;
GRANT ALL ON TABLE public.partidos_detallados TO authenticated;
GRANT ALL ON TABLE public.partidos_detallados TO service_role;


--
-- Name: TABLE playoff_matches; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.playoff_matches TO anon;
GRANT ALL ON TABLE public.playoff_matches TO authenticated;
GRANT ALL ON TABLE public.playoff_matches TO service_role;


--
-- Name: TABLE playoff_matches_detallados; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.playoff_matches_detallados TO anon;
GRANT ALL ON TABLE public.playoff_matches_detallados TO authenticated;
GRANT ALL ON TABLE public.playoff_matches_detallados TO service_role;


--
-- Name: TABLE playoffs; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.playoffs TO anon;
GRANT ALL ON TABLE public.playoffs TO authenticated;
GRANT ALL ON TABLE public.playoffs TO service_role;


--
-- Name: TABLE playoffs_extra; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.playoffs_extra TO anon;
GRANT ALL ON TABLE public.playoffs_extra TO authenticated;
GRANT ALL ON TABLE public.playoffs_extra TO service_role;


--
-- Name: TABLE season_rules; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.season_rules TO anon;
GRANT ALL ON TABLE public.season_rules TO authenticated;
GRANT ALL ON TABLE public.season_rules TO service_role;


--
-- Name: TABLE v_extra_playoffs_bracket_dinamico; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_extra_playoffs_bracket_dinamico TO anon;
GRANT ALL ON TABLE public.v_extra_playoffs_bracket_dinamico TO authenticated;
GRANT ALL ON TABLE public.v_extra_playoffs_bracket_dinamico TO service_role;


--
-- Name: TABLE v_posiciones_dinamicas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_posiciones_dinamicas TO anon;
GRANT ALL ON TABLE public.v_posiciones_dinamicas TO authenticated;
GRANT ALL ON TABLE public.v_posiciones_dinamicas TO service_role;


--
-- Name: TABLE votos_encuesta; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.votos_encuesta TO anon;
GRANT ALL ON TABLE public.votos_encuesta TO authenticated;
GRANT ALL ON TABLE public.votos_encuesta TO service_role;


--
-- Name: TABLE weeks_schedule; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.weeks_schedule TO anon;
GRANT ALL ON TABLE public.weeks_schedule TO authenticated;
GRANT ALL ON TABLE public.weeks_schedule TO service_role;


--
-- Name: SEQUENCE weeks_schedule_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.weeks_schedule_id_seq TO anon;
GRANT ALL ON SEQUENCE public.weeks_schedule_id_seq TO authenticated;
GRANT SELECT,USAGE ON SEQUENCE public.weeks_schedule_id_seq TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: supabase_realtime_admin
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO authenticated;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO anon;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO authenticated;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO anon;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: supabase_admin
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;
RESET SESSION AUTHORIZATION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: ensure_rls; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER ensure_rls ON ddl_command_end
         WHEN TAG IN ('CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO')
   EXECUTE FUNCTION public.rls_auto_enable();


ALTER EVENT TRIGGER ensure_rls OWNER TO postgres;

--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO supabase_admin;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO supabase_admin;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

\unrestrict hnykzxKLEcDwA7jSxNvkj1Z3RNoVt8IAZ0UjZKcLhd2EiYKqLIddbQ4uaZNi0Gh

