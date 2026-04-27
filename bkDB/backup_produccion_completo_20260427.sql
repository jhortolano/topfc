--
-- PostgreSQL database dump
--

\restrict ggdXxpnpYrAwqBLorfQvENL8xg4UQXakvciRX23pK81XWd84jCAe90C7GJxtyKG

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
-- Name: is_admin_or_collab(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.is_admin_or_collab() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM profiles 
    WHERE id = auth.uid() 
    AND (is_admin = true OR is_colaborador = true)
  );
END;
$$;


ALTER FUNCTION public.is_admin_or_collab() OWNER TO postgres;

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
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

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

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS TABLE(wal jsonb, is_rls_enabled boolean, subscription_ids uuid[], errors text[], slot_changes_count bigint)
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
  WITH pub AS (
    SELECT
      concat_ws(
        ',',
        CASE WHEN bool_or(pubinsert) THEN 'insert' ELSE NULL END,
        CASE WHEN bool_or(pubupdate) THEN 'update' ELSE NULL END,
        CASE WHEN bool_or(pubdelete) THEN 'delete' ELSE NULL END
      ) AS w2j_actions,
      coalesce(
        string_agg(
          realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
          ','
        ) filter (WHERE ppt.tablename IS NOT NULL AND ppt.tablename NOT LIKE '% %'),
        ''
      ) AS w2j_add_tables
    FROM pg_publication pp
    LEFT JOIN pg_publication_tables ppt ON pp.pubname = ppt.pubname
    WHERE pp.pubname = publication
    GROUP BY pp.pubname
    LIMIT 1
  ),
  -- MATERIALIZED ensures pg_logical_slot_get_changes is called exactly once
  w2j AS MATERIALIZED (
    SELECT x.*, pub.w2j_add_tables
    FROM pub,
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
  ),
  -- Count raw slot entries before apply_rls/subscription filter
  slot_count AS (
    SELECT count(*)::bigint AS cnt
    FROM w2j
    WHERE w2j.w2j_add_tables <> ''
  ),
  -- Apply RLS and filter as before
  rls_filtered AS (
    SELECT xyz.wal, xyz.is_rls_enabled, xyz.subscription_ids, xyz.errors
    FROM w2j,
         realtime.apply_rls(
           wal := w2j.data::jsonb,
           max_record_bytes := max_record_bytes
         ) xyz(wal, is_rls_enabled, subscription_ids, errors)
    WHERE w2j.w2j_add_tables <> ''
      AND xyz.subscription_ids[1] IS NOT NULL
  )
  -- Real rows with slot count attached
  SELECT rf.wal, rf.is_rls_enabled, rf.subscription_ids, rf.errors, sc.cnt
  FROM rls_filtered rf, slot_count sc

  UNION ALL

  -- Sentinel row: always returned when no real rows exist so Elixir can
  -- always read slot_changes_count. Identified by wal IS NULL.
  SELECT null, null, null, null, sc.cnt
  FROM slot_count sc
  WHERE NOT EXISTS (SELECT 1 FROM rls_filtered)
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
-- Name: allow_any_operation(text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_any_operation(expected_operations text[]) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT CASE
      WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
      ELSE raw_operation
    END AS current_operation
    FROM current_operation
  )
  SELECT EXISTS (
    SELECT 1
    FROM normalized n
    CROSS JOIN LATERAL unnest(expected_operations) AS expected_operation
    WHERE expected_operation IS NOT NULL
      AND expected_operation <> ''
      AND n.current_operation = CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END
  );
$$;


ALTER FUNCTION storage.allow_any_operation(expected_operations text[]) OWNER TO supabase_storage_admin;

--
-- Name: allow_only_operation(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.allow_only_operation(expected_operation text) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$
  WITH current_operation AS (
    SELECT storage.operation() AS raw_operation
  ),
  normalized AS (
    SELECT
      CASE
        WHEN raw_operation LIKE 'storage.%' THEN substr(raw_operation, 9)
        ELSE raw_operation
      END AS current_operation,
      CASE
        WHEN expected_operation LIKE 'storage.%' THEN substr(expected_operation, 9)
        ELSE expected_operation
      END AS requested_operation
    FROM current_operation
  )
  SELECT CASE
    WHEN requested_operation IS NULL OR requested_operation = '' THEN FALSE
    ELSE COALESCE(current_operation = requested_operation, FALSE)
  END
  FROM normalized;
$$;


ALTER FUNCTION storage.allow_only_operation(expected_operation text) OWNER TO supabase_storage_admin;

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
-- Name: delete_leaf_prefixes(text[], text[]); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    v_rows_deleted integer;
BEGIN
    LOOP
        WITH candidates AS (
            SELECT DISTINCT
                t.bucket_id,
                unnest(storage.get_prefixes(t.name)) AS name
            FROM unnest(bucket_ids, names) AS t(bucket_id, name)
        ),
        uniq AS (
             SELECT
                 bucket_id,
                 name,
                 storage.get_level(name) AS level
             FROM candidates
             WHERE name <> ''
             GROUP BY bucket_id, name
        ),
        leaf AS (
             SELECT
                 p.bucket_id,
                 p.name,
                 p.level
             FROM storage.prefixes AS p
                  JOIN uniq AS u
                       ON u.bucket_id = p.bucket_id
                           AND u.name = p.name
                           AND u.level = p.level
             WHERE NOT EXISTS (
                 SELECT 1
                 FROM storage.objects AS o
                 WHERE o.bucket_id = p.bucket_id
                   AND o.level = p.level + 1
                   AND o.name COLLATE "C" LIKE p.name || '/%'
             )
             AND NOT EXISTS (
                 SELECT 1
                 FROM storage.prefixes AS c
                 WHERE c.bucket_id = p.bucket_id
                   AND c.level = p.level + 1
                   AND c.name COLLATE "C" LIKE p.name || '/%'
             )
        )
        DELETE
        FROM storage.prefixes AS p
            USING leaf AS l
        WHERE p.bucket_id = l.bucket_id
          AND p.name = l.name
          AND p.level = l.level;

        GET DIAGNOSTICS v_rows_deleted = ROW_COUNT;
        EXIT WHEN v_rows_deleted = 0;
    END LOOP;
END;
$$;


ALTER FUNCTION storage.delete_leaf_prefixes(bucket_ids text[], names text[]) OWNER TO supabase_storage_admin;

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
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
    _filename text;
BEGIN
    SELECT string_to_array(name, '/') INTO _parts;
    SELECT _parts[array_length(_parts,1)] INTO _filename;
    RETURN reverse(split_part(reverse(_filename), '.', 1));
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
    LANGUAGE plpgsql IMMUTABLE
    AS $$
DECLARE
    _parts text[];
BEGIN
    -- Split on "/" to get path segments
    SELECT string_to_array(name, '/') INTO _parts;
    -- Return everything except the last segment
    RETURN _parts[1 : array_length(_parts,1) - 1];
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
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


ALTER FUNCTION storage.get_level(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


ALTER FUNCTION storage.get_prefix(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


ALTER FUNCTION storage.get_prefixes(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::bigint) as size, obj.bucket_id
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
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

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
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


ALTER TABLE auth.webauthn_challenges OWNER TO supabase_auth_admin;

--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


ALTER TABLE auth.webauthn_credentials OWNER TO supabase_auth_admin;

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
    division integer DEFAULT 1,
    updated_at timestamp with time zone DEFAULT now()
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
    is_colaborador boolean DEFAULT false,
    eafc_user text
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
    stream_url text,
    updated_at timestamp with time zone DEFAULT now()
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
    stream_updated_at timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now()
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
-- Name: matches_rescheduled; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matches_rescheduled (
    id bigint NOT NULL,
    match_id bigint,
    match_id_uid uuid,
    tipo_partido text NOT NULL,
    player1_id uuid,
    player2_id uuid,
    fecha_inicio timestamp with time zone NOT NULL,
    fecha_fin timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.matches_rescheduled OWNER TO postgres;

--
-- Name: matches_rescheduled_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.matches_rescheduled ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.matches_rescheduled_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: notificaciones_enviadas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notificaciones_enviadas (
    id text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE public.notificaciones_enviadas OWNER TO postgres;

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
    end_date timestamp with time zone,
    updated_at timestamp with time zone DEFAULT now()
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
    stream_puntos boolean DEFAULT false,
    limit_ga_enabled boolean DEFAULT false,
    max_ga_playoff integer DEFAULT 5
);


ALTER TABLE public.playoffs_extra OWNER TO postgres;

--
-- Name: promo_matches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promo_matches (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    player1_id uuid,
    player2_id uuid,
    score1 integer DEFAULT 0,
    score2 integer DEFAULT 0,
    is_played boolean DEFAULT false,
    season integer NOT NULL,
    division integer NOT NULL,
    idavuelta text,
    label_info text,
    stream_url text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    divplayer1 integer,
    divplayer2 integer,
    CONSTRAINT promo_matches_idavuelta_check CHECK ((idavuelta = ANY (ARRAY['ida'::text, 'vuelta'::text])))
);


ALTER TABLE public.promo_matches OWNER TO postgres;

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
    max_ga_league integer DEFAULT 3,
    auto_week_by_date boolean DEFAULT false,
    auto_playoff_by_date boolean DEFAULT false,
    bonus_min_porcentageb integer DEFAULT 0,
    bonus_min_porcentagec integer DEFAULT 0,
    bonus_pointsb integer DEFAULT 0,
    bonus_pointsc integer DEFAULT 0
);


ALTER TABLE public.season_rules OWNER TO postgres;

--
-- Name: v_extra_playoffs_bracket_dinamico; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_extra_playoffs_bracket_dinamico WITH (security_invoker='on') AS
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
    stream_url,
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

CREATE VIEW public.v_posiciones_dinamicas WITH (security_invoker='on') AS
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
-- Name: weeks_promo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.weeks_promo (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    season integer NOT NULL,
    start_at timestamp with time zone NOT NULL,
    end_at timestamp with time zone NOT NULL,
    idavuelta text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT weeks_promo_idavuelta_check CHECK ((idavuelta = ANY (ARRAY['ida'::text, 'vuelta'::text])))
);


ALTER TABLE public.weeks_promo OWNER TO postgres;

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
    user_metadata jsonb,
    metadata jsonb
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
b5d23981-469b-4353-a615-9e4d6c8d8daf	b5d23981-469b-4353-a615-9e4d6c8d8daf	{"sub": "b5d23981-469b-4353-a615-9e4d6c8d8daf", "nick": "AdriWins", "email": "adrianruizmartos16@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-21 18:35:14.281994+00	2026-02-21 18:35:14.283198+00	2026-02-21 18:35:14.283198+00	c2323181-9463-47b6-8022-b518654a096a
449ee91c-f52f-4661-abd4-ebfd556c37c3	449ee91c-f52f-4661-abd4-ebfd556c37c3	{"sub": "449ee91c-f52f-4661-abd4-ebfd556c37c3", "nick": "Hukha", "email": "hukha221@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-25 11:50:01.917419+00	2026-02-25 11:50:01.917477+00	2026-02-25 11:50:01.917477+00	25e3ce3b-d667-4c2b-a3b6-f7bcc78cca5b
2549f3dd-74dd-473b-be44-d5983b70e1ba	2549f3dd-74dd-473b-be44-d5983b70e1ba	{"sub": "2549f3dd-74dd-473b-be44-d5983b70e1ba", "nick": "Franchesco", "email": "francisaditrap@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-25 11:51:26.153319+00	2026-02-25 11:51:26.153367+00	2026-02-25 11:51:26.153367+00	9b1c947b-3abc-4ba0-9394-561c407218f5
943a493d-044c-4c88-babc-e64804553bb4	943a493d-044c-4c88-babc-e64804553bb4	{"sub": "943a493d-044c-4c88-babc-e64804553bb4", "nick": "Angel_Rico", "email": "angel_fgrico@hotmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-25 19:24:06.120852+00	2026-02-25 19:24:06.12154+00	2026-02-25 19:24:06.12154+00	d924fe3d-1890-471c-bb5f-3f0f812c7148
eae8c25a-a99d-480f-8e3e-854d36c5c8dc	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	{"sub": "eae8c25a-a99d-480f-8e3e-854d36c5c8dc", "nick": "Jeybiss", "email": "57juanjose57@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-26 13:49:18.386427+00	2026-02-26 13:49:18.386483+00	2026-02-26 13:49:18.386483+00	1033493a-a4df-44c6-948a-e9a2084ba578
8c1c7bba-636d-42f2-820a-ac1131897e84	8c1c7bba-636d-42f2-820a-ac1131897e84	{"sub": "8c1c7bba-636d-42f2-820a-ac1131897e84", "nick": "Don Ptr Squad", "email": "pedrorodriguezmoya83@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-02-28 11:22:16.490936+00	2026-02-28 11:22:16.490986+00	2026-02-28 11:22:16.490986+00	97fde2e0-a1e0-4521-909b-2a11b881953e
38f98f64-f2db-47bf-a5ea-dcd1804ce00a	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	{"sub": "38f98f64-f2db-47bf-a5ea-dcd1804ce00a", "nick": "themule089", "email": "david.cvega89@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-01 09:34:43.303239+00	2026-03-01 09:34:43.303294+00	2026-03-01 09:34:43.303294+00	f53590c9-0400-44ce-a2d4-0b9b9d2cfd04
2f58705a-25ad-42c9-b953-5137532b3584	2f58705a-25ad-42c9-b953-5137532b3584	{"sub": "2f58705a-25ad-42c9-b953-5137532b3584", "nick": "Selu ", "email": "jluisdiazmaroto@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-01 19:03:49.225077+00	2026-03-01 19:03:49.225133+00	2026-03-01 19:03:49.225133+00	9d7e3810-3f22-4feb-a742-cb3446e5500d
16f4402c-a1b5-4431-8d98-c454f52a6284	16f4402c-a1b5-4431-8d98-c454f52a6284	{"sub": "16f4402c-a1b5-4431-8d98-c454f52a6284", "nick": "Iker", "email": "ikerxu1985@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-02 22:26:22.691135+00	2026-03-02 22:26:22.691188+00	2026-03-02 22:26:22.691188+00	6282a820-367e-45ba-915b-de2f0d3e0c8a
c96625ad-9941-423c-8b5a-6fdc1b54ac20	c96625ad-9941-423c-8b5a-6fdc1b54ac20	{"sub": "c96625ad-9941-423c-8b5a-6fdc1b54ac20", "nick": "SharkD", "email": "dari970417@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-09 11:32:15.835569+00	2026-03-09 11:32:15.835619+00	2026-03-09 11:32:15.835619+00	9c733f8a-3eec-4ef3-a5ea-75f5784e26ce
45ef0325-e165-4aef-8836-03099f1d7bd9	45ef0325-e165-4aef-8836-03099f1d7bd9	{"sub": "45ef0325-e165-4aef-8836-03099f1d7bd9", "nick": "Chava_14", "email": "luischava1234@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-09 11:59:20.426085+00	2026-03-09 11:59:20.426136+00	2026-03-09 11:59:20.426136+00	facfb59d-d88c-4a0b-9b99-f679145c5642
8d16ce77-1836-4ce6-a462-b9d16358fb3f	8d16ce77-1836-4ce6-a462-b9d16358fb3f	{"sub": "8d16ce77-1836-4ce6-a462-b9d16358fb3f", "nick": "Rubens_saga", "email": "muycontento10@hotmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-11 13:13:38.166838+00	2026-03-11 13:13:38.166887+00	2026-03-11 13:13:38.166887+00	e9d487b9-27c2-491b-9244-ccb3fa6b2531
0e9bdb55-a555-467d-995a-62d64ab8a509	0e9bdb55-a555-467d-995a-62d64ab8a509	{"sub": "0e9bdb55-a555-467d-995a-62d64ab8a509", "nick": "libertojeans", "email": "libertogil@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-19 10:04:47.34459+00	2026-03-19 10:04:47.344641+00	2026-03-19 10:04:47.344641+00	402cd7d7-6ae6-4e53-952f-3dd2528332f5
e92aa512-c44f-48c8-b983-7c7705e36a6f	e92aa512-c44f-48c8-b983-7c7705e36a6f	{"sub": "e92aa512-c44f-48c8-b983-7c7705e36a6f", "nick": "Excobar1208", "email": "escobarelkin@coruniamericana.edu.co", "email_verified": true, "phone_verified": false}	email	2026-03-19 11:35:33.545783+00	2026-03-19 11:35:33.545831+00	2026-03-19 11:35:33.545831+00	a2aad260-4e55-48e7-90cd-a98f7e9b5ee5
4f008550-7b28-4437-923b-3438f4aed317	4f008550-7b28-4437-923b-3438f4aed317	{"sub": "4f008550-7b28-4437-923b-3438f4aed317", "nick": "L1amAiram", "email": "l14mkrls@icloud.com", "email_verified": true, "phone_verified": false}	email	2026-03-19 11:47:53.548447+00	2026-03-19 11:47:53.548504+00	2026-03-19 11:47:53.548504+00	cf69c6e6-8981-442b-a0ad-33c2bea6748e
31984a41-8b67-441c-abd6-2b3880940b87	31984a41-8b67-441c-abd6-2b3880940b87	{"sub": "31984a41-8b67-441c-abd6-2b3880940b87", "nick": "LlaveringL", "email": "sergiollaverogomez@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-19 13:35:47.461327+00	2026-03-19 13:35:47.461378+00	2026-03-19 13:35:47.461378+00	3919d303-9c06-4981-83ce-54b6985c120e
74d1cfe5-421b-4be6-a055-0b7693ff2f1c	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	{"sub": "74d1cfe5-421b-4be6-a055-0b7693ff2f1c", "nick": "Kapi_86", "email": "kapi_86@hotmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-19 17:01:34.4432+00	2026-03-19 17:01:34.443254+00	2026-03-19 17:01:34.443254+00	da6ff530-d323-40f4-abc7-ba80b8a74a7c
af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	{"sub": "af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76", "nick": "Fernando92", "email": "fernandoguardado04@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-19 17:06:58.667833+00	2026-03-19 17:06:58.667882+00	2026-03-19 17:06:58.667882+00	c9effdef-2b57-4a75-a43c-cf0660df7fac
05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	{"sub": "05fcf0a8-e2f1-46b3-bad4-8d3b267fd003", "nick": "Egea", "email": "infoalbertoegea@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-20 09:12:32.937796+00	2026-03-20 09:12:32.942365+00	2026-03-20 09:12:32.942365+00	f5175a35-13b5-4e9b-bc58-4613ede2243d
be618b84-342d-454e-844d-fef4c2970891	be618b84-342d-454e-844d-fef4c2970891	{"sub": "be618b84-342d-454e-844d-fef4c2970891", "nick": "Davidsvo96", "email": "davidsvalencia.o1@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-20 12:40:01.277066+00	2026-03-20 12:40:01.277125+00	2026-03-20 12:40:01.277125+00	545ee62e-a295-47aa-81ba-c40ae04f39e2
4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	{"sub": "4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd", "nick": "Ocarvallo15", "email": "ocarvallo23@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-21 13:28:47.214581+00	2026-03-21 13:28:47.214635+00	2026-03-21 13:28:47.214635+00	06712790-2001-469b-bc81-8f288df05294
ec1c03bd-6b21-4574-aff7-39deac5e25bf	ec1c03bd-6b21-4574-aff7-39deac5e25bf	{"sub": "ec1c03bd-6b21-4574-aff7-39deac5e25bf", "nick": "Acrazun", "email": "antoniocruzp80@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-04-11 12:32:48.313715+00	2026-04-11 12:32:48.313771+00	2026-04-11 12:32:48.313771+00	96b294da-d53e-4115-abf8-3f3129d9c0b4
4408336b-259c-437a-9f78-c4a664506756	4408336b-259c-437a-9f78-c4a664506756	{"sub": "4408336b-259c-437a-9f78-c4a664506756", "nick": "FelixRG", "email": "felixrg1703@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-24 17:18:04.029233+00	2026-03-24 17:18:04.029285+00	2026-03-24 17:18:04.029285+00	a8ecc1e4-78ab-4324-8eda-2da199d7dd3a
81a8640c-85be-4c54-9e36-9a5ac9c98e4a	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	{"sub": "81a8640c-85be-4c54-9e36-9a5ac9c98e4a", "nick": "Santi", "email": "kokoncholopez@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-04-24 13:17:38.001231+00	2026-04-24 13:17:38.001287+00	2026-04-24 13:17:38.001287+00	8f67efa5-6a6b-4c51-b4cd-8c2645b16df0
1459c5f5-7c55-4f8c-86a0-f049234706a1	1459c5f5-7c55-4f8c-86a0-f049234706a1	{"sub": "1459c5f5-7c55-4f8c-86a0-f049234706a1", "nick": "Juanka13Games", "email": "juanka13games@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-27 13:45:43.625285+00	2026-03-27 13:45:43.625331+00	2026-03-27 13:45:43.625331+00	d2565d50-1e35-4e6d-b553-9232e71fe53f
39b4f188-96fa-4fc8-8d91-4d954f67c5d3	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	{"sub": "39b4f188-96fa-4fc8-8d91-4d954f67c5d3", "nick": "melliot1990", "email": "melliot001@hotmail.com", "email_verified": true, "phone_verified": false}	email	2026-03-31 13:00:35.912166+00	2026-03-31 13:00:35.912221+00	2026-03-31 13:00:35.912221+00	e797b72b-d4fa-4d03-b399-9cae8a51610f
9d852873-3b29-4018-adde-c6244679e312	9d852873-3b29-4018-adde-c6244679e312	{"sub": "9d852873-3b29-4018-adde-c6244679e312", "nick": "CharGie29", "email": "charlie29948@hotmail.com", "email_verified": true, "phone_verified": false}	email	2026-04-01 11:44:07.055338+00	2026-04-01 11:44:07.055391+00	2026-04-01 11:44:07.055391+00	954a1e48-361b-4236-bd0d-7c534af714af
f1932726-f713-4b61-8650-bf04f45d5b09	f1932726-f713-4b61-8650-bf04f45d5b09	{"sub": "f1932726-f713-4b61-8650-bf04f45d5b09", "nick": "payomalo89", "email": "mendyvillacity@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-04-06 10:05:58.534135+00	2026-04-06 10:05:58.534189+00	2026-04-06 10:05:58.534189+00	2b67eddd-abe5-43f3-923f-16070404f48d
56f68d15-9c80-4b6a-9537-d8f5e8c1f021	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	{"sub": "56f68d15-9c80-4b6a-9537-d8f5e8c1f021", "nick": "GreekVE", "email": "efstathioski@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-04-15 19:27:47.29854+00	2026-04-15 19:27:47.298591+00	2026-04-15 19:27:47.298591+00	d73f491a-db8b-4fc8-8c58-9ceab9469905
7d59efea-fc42-4117-a34b-3937905456db	7d59efea-fc42-4117-a34b-3937905456db	{"sub": "7d59efea-fc42-4117-a34b-3937905456db", "nick": "Sueldo analogo", "email": "pedrocanosanchez1@gmail.com", "email_verified": true, "phone_verified": false}	email	2026-04-19 13:14:01.573235+00	2026-04-19 13:14:01.573283+00	2026-04-19 13:14:01.573283+00	d4bb6f2c-fe3c-44cf-b0d5-96dfc4223717
10920fad-ebd2-4be2-8e82-4604204f6139	10920fad-ebd2-4be2-8e82-4604204f6139	{"sub": "10920fad-ebd2-4be2-8e82-4604204f6139", "nick": "jonny_black83", "email": "joni_esnaider@hotmail.com", "email_verified": true, "phone_verified": false}	email	2026-04-19 13:30:06.932955+00	2026-04-19 13:30:06.933006+00	2026-04-19 13:30:06.933006+00	eb33920c-8e99-4d12-9b8b-a4a8643bd581
e804e0cf-72af-449e-9816-46518b271b84	e804e0cf-72af-449e-9816-46518b271b84	{"sub": "e804e0cf-72af-449e-9816-46518b271b84", "nick": "Judas", "email": "daniel_moruno@hotmail.com", "email_verified": true, "phone_verified": false}	email	2026-04-21 11:41:07.221431+00	2026-04-21 11:41:07.221497+00	2026-04-21 11:41:07.221497+00	6c68b0d0-4b2b-4f97-a293-65120c98dfbc
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
9952d18a-a0af-4cbd-98dc-15844d29d1ed	2026-02-21 18:35:43.846545+00	2026-02-21 18:35:43.846545+00	otp	611685d1-2dd5-4152-adeb-517f4b211e03
8572d9fe-586e-4d40-b93c-2042b9d36650	2026-02-25 11:51:07.603159+00	2026-02-25 11:51:07.603159+00	otp	443610dd-9fff-4fc1-afb2-9ecb192ece71
dc5e3fbe-b5d0-475a-811e-9761f35394ae	2026-02-25 11:51:51.268339+00	2026-02-25 11:51:51.268339+00	otp	d7d72bc4-cdec-4dac-a26f-a1f5b57f4f75
f5e23156-f5ae-48ef-acdc-e813d7be5ebb	2026-02-25 19:24:42.914273+00	2026-02-25 19:24:42.914273+00	otp	f8b7f27a-2af0-4144-9842-990f1ce9963b
e0e7c041-bae0-4c4a-a1ed-d865801366b9	2026-02-26 13:49:28.545848+00	2026-02-26 13:49:28.545848+00	otp	d781d3bc-dd29-4ba4-8b73-343710a61ae4
d9684c6e-99ba-4147-add5-ab40d1ed36e9	2026-02-28 09:27:58.68427+00	2026-02-28 09:27:58.68427+00	otp	50dba03d-8acc-4fcb-8574-8107e95a37d1
6a00599b-d3f6-4fba-8097-dadcbf0a8f29	2026-02-28 09:28:41.590839+00	2026-02-28 09:28:41.590839+00	password	ecc8a45d-4760-41cd-8b33-3d555e6955e9
2d9ac9cb-6b87-4ced-b0fe-0587b45397d9	2026-02-28 11:22:27.701419+00	2026-02-28 11:22:27.701419+00	otp	0b4c58e4-1c7f-400b-82f3-13b6cb41dc9c
b76b4f7f-4424-49ef-ac70-28adfb124c3d	2026-03-01 09:34:58.345832+00	2026-03-01 09:34:58.345832+00	otp	ce9f1ebf-4476-4a01-9fd2-0594cf4a6286
0b4a81c9-70a8-489e-a4b1-b11817ad3070	2026-03-01 19:14:31.377766+00	2026-03-01 19:14:31.377766+00	otp	2f2ef82c-6bcc-466e-beb1-3be6269fbc52
2080d919-8941-487a-9911-23ed6ebe6c37	2026-03-02 11:01:55.212986+00	2026-03-02 11:01:55.212986+00	password	b1eb5a63-4766-4002-931a-7d6ed2bd30f4
6fd39da8-325e-4ed7-9734-d80e23d837f7	2026-03-02 22:26:38.775119+00	2026-03-02 22:26:38.775119+00	otp	c45b0091-951f-410d-b8cf-55db299e27b5
7824e9c7-5f6e-440d-8339-27a5105385cc	2026-03-02 22:41:23.084874+00	2026-03-02 22:41:23.084874+00	password	88658f90-c44d-4787-a3ce-a8a68ab926b6
b1d00248-1278-4fa0-97be-da56fa5926a5	2026-03-07 11:33:17.556917+00	2026-03-07 11:33:17.556917+00	password	5bf2ff3a-3b16-4f16-b1c4-4d3a7b5a9c5c
1b59da56-646e-48d2-bd35-e145b3703d7c	2026-03-08 20:08:11.817624+00	2026-03-08 20:08:11.817624+00	otp	5396b33c-ba05-4307-8535-ba6aea3acc11
bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93	2026-03-09 11:32:37.170486+00	2026-03-09 11:32:37.170486+00	otp	cf339529-73c1-4e24-9e0f-89f9333b2ac9
6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7	2026-03-09 11:59:31.875819+00	2026-03-09 11:59:31.875819+00	otp	b7fe55a8-0e32-435a-acf6-8e6c827f66fb
a78dc683-0189-4b2b-a3c7-3ea7f965f60c	2026-03-11 13:14:34.247489+00	2026-03-11 13:14:34.247489+00	otp	fd58402b-cdfe-4e8f-9c12-1251a7e290f4
8d645adf-06c6-40c0-a754-d51f12342b4e	2026-03-16 15:26:52.244186+00	2026-03-16 15:26:52.244186+00	password	32bf1a12-7330-4ae1-9e4a-f6d6813cfb16
38a7e050-8748-456e-94fe-6d81e4775134	2026-03-16 15:53:44.133448+00	2026-03-16 15:53:44.133448+00	password	6d4aff9f-d68b-484f-bebc-d8f1bbfa1542
2e10e97f-dc00-44ed-bba3-6c10816000dd	2026-03-19 10:05:01.466043+00	2026-03-19 10:05:01.466043+00	otp	f38399bd-8b99-45ad-ab65-3fb533bed2a6
081a1ba2-f2b2-4359-b2a7-eb90d1281bc4	2026-03-19 11:35:59.440143+00	2026-03-19 11:35:59.440143+00	otp	9b403a50-60a7-4db7-8d8e-d8043eff02f2
25e25d91-a833-42c0-8357-44d5e76a5b5b	2026-03-19 11:55:36.644452+00	2026-03-19 11:55:36.644452+00	otp	f9772389-2909-481e-80cf-a1f21807c3df
88dfd653-2835-4f26-bd15-7c0eeb6241ab	2026-03-19 13:38:05.527653+00	2026-03-19 13:38:05.527653+00	otp	4c7e9cc8-07f7-4be5-a067-e12a47bdbec8
e6251a1f-86e9-408e-8f4c-ea3cac1eb435	2026-03-19 17:02:05.323977+00	2026-03-19 17:02:05.323977+00	otp	b7602928-d15d-48f6-a2b6-9a243741c482
70a887fe-cbf5-435c-85c9-3691006bbab8	2026-03-19 17:07:22.14054+00	2026-03-19 17:07:22.14054+00	otp	163db4c3-272d-4836-a45b-563acba35297
eb06df08-bb8f-4413-962c-db927135684a	2026-03-20 09:12:44.709044+00	2026-03-20 09:12:44.709044+00	otp	09c86a90-069b-4dfb-aef7-7ef131531d41
3d684789-2e64-4a53-89d4-6bc3c902f25e	2026-03-20 12:41:46.909873+00	2026-03-20 12:41:46.909873+00	otp	63aef3af-7632-45c7-a152-a6f353286797
6eae37ff-2205-437e-88d1-9cd43a3f1345	2026-03-20 13:19:36.770228+00	2026-03-20 13:19:36.770228+00	password	747ed0f2-5b48-4b3d-98df-eb771c8ccc4e
391d2633-351e-4334-b952-2e1d8eaad788	2026-03-21 13:32:47.934446+00	2026-03-21 13:32:47.934446+00	otp	ccdd6e08-0beb-4bc3-8b05-2c1be5937d2b
2a702674-f270-4024-b5a3-48a39b7c072c	2026-03-22 09:04:35.550972+00	2026-03-22 09:04:35.550972+00	password	2e2f8e2c-b3c9-4dea-9dec-9fd9d6ba8292
b18ad4a5-a8fe-46b6-8855-7d907cfcaf2a	2026-03-22 19:53:28.598744+00	2026-03-22 19:53:28.598744+00	password	86b30467-4ab9-44f3-b25f-8d64f8c9903d
10f5facc-ee28-42cd-a394-3e24f9b750dc	2026-03-23 11:06:26.427329+00	2026-03-23 11:06:26.427329+00	password	3e9b85f5-297e-456b-a536-acb0bb1595af
4741f457-f865-4699-9a78-d7d7ccb1bb3c	2026-03-23 11:27:55.311284+00	2026-03-23 11:27:55.311284+00	password	37ec0c8e-1a6f-4df8-9a2f-68a727656231
f71d0adb-1658-4567-b4b3-628ac114c07a	2026-03-23 16:55:44.814551+00	2026-03-23 16:55:44.814551+00	password	3b1bcefc-abe1-45b5-9253-d684e40aad0f
e67fe040-3b84-4afe-97fe-21952174c254	2026-03-24 17:18:17.413837+00	2026-03-24 17:18:17.413837+00	otp	87682eeb-3e14-4938-8fe6-0e3c18516f34
016e7651-84f8-4f4e-8675-2ad1e5ce0531	2026-03-27 11:25:21.0278+00	2026-03-27 11:25:21.0278+00	password	e2b2cd62-36cd-4331-83a5-916871caec1a
ae2f476b-5f97-401c-9608-90b7590b52b5	2026-03-27 13:45:55.313651+00	2026-03-27 13:45:55.313651+00	otp	b150c2d1-c5af-456a-b80f-a2fb540feb6e
3fd849d4-ea83-4a25-aa5f-e509ff20adf8	2026-03-28 12:48:59.912924+00	2026-03-28 12:48:59.912924+00	password	4c1fb155-92cf-4dcf-83b7-9463a77117f1
3e47eab9-3399-4435-a104-8c22ce536768	2026-03-28 16:43:55.873759+00	2026-03-28 16:43:55.873759+00	password	5e23777c-b9da-4ed5-9727-b328b52b9e3b
57a95f55-f4e7-4e58-9a02-64c9586203b8	2026-03-30 08:30:27.922387+00	2026-03-30 08:30:27.922387+00	password	f5cfa09d-c83d-44e6-8c60-015cce8fbd46
ff598b2e-0a7b-42cb-b33a-746c7efe59e1	2026-03-30 12:32:57.490259+00	2026-03-30 12:32:57.490259+00	password	d70c488e-3b8f-4adb-96a1-d07e6176a0b5
9a6a4ee2-41d5-48b9-8156-0df660cea663	2026-03-31 07:26:41.769812+00	2026-03-31 07:26:41.769812+00	password	d692a13f-c06f-4634-a335-ad78e7c70450
bb65e12f-dfc1-480b-936a-8fa12ebb8e04	2026-03-31 13:01:49.802444+00	2026-03-31 13:01:49.802444+00	otp	8bc4b94a-22bd-4c9b-b781-4684e93f4f96
9b377b5d-4d4a-4b07-8050-93bbb595c7c1	2026-04-01 11:44:20.660624+00	2026-04-01 11:44:20.660624+00	otp	ac781b2b-e286-4c2f-b849-30262a01515e
7c46fbb4-b165-4db6-8ed5-64399b8c3bba	2026-04-02 11:35:39.141318+00	2026-04-02 11:35:39.141318+00	password	8aa64431-3c53-483f-859a-0fe41b1cd390
7918091c-cb18-4b5d-9de8-d38a747ae765	2026-04-03 14:25:33.179695+00	2026-04-03 14:25:33.179695+00	password	203da436-5b91-46dd-a349-4ba3d912d487
9ce1e1c0-e99f-463e-9d96-5b502b42f126	2026-04-03 18:28:22.458618+00	2026-04-03 18:28:22.458618+00	password	21c83a12-f6da-4a77-a604-8c52ee3c9a4d
bd2ae24d-c3c7-4ac8-b7e5-3295e75a76f9	2026-04-05 21:06:13.842616+00	2026-04-05 21:06:13.842616+00	password	992a2479-5a37-4939-ad7d-3971422ff9d5
aac4e3e2-5a85-4f33-bb6e-c56a7cae0649	2026-04-06 10:07:38.463037+00	2026-04-06 10:07:38.463037+00	otp	ee4c54c6-b5b2-4e73-8210-8466cd31a3f9
b2442d92-4f90-4a83-b448-a3d333644716	2026-04-08 09:30:04.793962+00	2026-04-08 09:30:04.793962+00	password	9d31b9db-e88e-426d-838c-c564b119c281
ef6ddb62-61bb-4763-ab3e-d58a0bc353d3	2026-04-11 12:33:04.246299+00	2026-04-11 12:33:04.246299+00	otp	4b41e77b-3617-4d22-8760-308ff92e5119
03665399-c6f6-41b4-8800-627c97ec6444	2026-04-11 17:12:42.427343+00	2026-04-11 17:12:42.427343+00	password	a33300b3-6632-481d-b775-39ae56e125ac
908decdf-2f7e-4917-82bd-8fb252ea1cc0	2026-04-12 19:57:43.715963+00	2026-04-12 19:57:43.715963+00	password	8736ee22-1643-4316-aab2-fd15350ca96d
f2eba057-a1b4-4019-bf68-2840bf276030	2026-04-13 18:48:41.792158+00	2026-04-13 18:48:41.792158+00	password	386069da-a61a-48b1-8f58-687d68085be5
ad78a9b8-42b9-422d-86f1-4519e61f2c7f	2026-04-15 11:57:21.555093+00	2026-04-15 11:57:21.555093+00	password	1901f80d-7e30-487e-887b-308791ccc14c
0ba74217-fba2-4fd7-ba36-bf963c26d9b1	2026-04-15 15:03:24.312328+00	2026-04-15 15:03:24.312328+00	password	9d4dde4c-14e7-4ea1-a45d-2fa7684254e3
57481a16-2ec8-4a04-871a-094886569940	2026-04-15 16:58:51.404005+00	2026-04-15 16:58:51.404005+00	password	ee7c3951-92b0-4c76-9fb4-47e9a87579d5
00ef3d37-9ca9-41cd-96b6-b3752fe69e42	2026-04-15 19:27:58.655409+00	2026-04-15 19:27:58.655409+00	otp	00cab7b7-5463-4f8a-b229-50e61a14ab6b
ea57d49d-21b7-4301-a465-5a6a9df57ff0	2026-04-16 13:54:02.291159+00	2026-04-16 13:54:02.291159+00	password	d5764979-ce2f-4cb0-aea2-cda4f16a07d3
28177b15-1cfd-4994-80c3-23d1d59dcb10	2026-04-16 14:44:47.915548+00	2026-04-16 14:44:47.915548+00	password	c21720c5-eaa5-4e81-a8a6-e8d614b1a219
c24099c9-b494-4ec2-b3a6-fa81a76d96ab	2026-04-17 12:10:25.557285+00	2026-04-17 12:10:25.557285+00	password	feeb5abd-5081-4689-922f-f97dfb46281a
f10256a0-940b-4f2c-8e9d-7fe45cebcfd5	2026-04-18 17:26:15.434904+00	2026-04-18 17:26:15.434904+00	password	35545fc8-a436-4813-a496-881a7d96d68d
6d8a9303-996f-499b-9d91-83925a0313ca	2026-04-19 13:14:29.439747+00	2026-04-19 13:14:29.439747+00	otp	75520c0a-a07e-42c6-b1dd-312e33a077b1
8c61ff8a-0c83-449b-95ea-a05f92488895	2026-04-19 13:31:37.820523+00	2026-04-19 13:31:37.820523+00	otp	8be6aa13-e65d-4074-88f2-52a9818767e1
e0ef1413-c2d1-4a43-8823-f5fba0f268a9	2026-04-19 13:32:05.610029+00	2026-04-19 13:32:05.610029+00	password	554c57c2-6563-4ad5-9dc0-855168870727
6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902	2026-04-20 10:12:01.202674+00	2026-04-20 10:12:01.202674+00	password	e60d4524-155c-4c23-a474-8b2a67e1698d
3bc6fd1d-2320-4366-91f6-a1291b117b9f	2026-04-20 15:39:53.986631+00	2026-04-20 15:39:53.986631+00	password	f711031e-0edd-4cf8-864d-285e919b79dc
da99741b-fb99-4474-9fa9-fd3e49543738	2026-04-21 11:41:40.548097+00	2026-04-21 11:41:40.548097+00	otp	6c7187ed-887d-47ea-92a1-9167be105e1b
52af80ca-d377-4926-a0e9-0e8afbd62198	2026-04-24 08:05:16.627591+00	2026-04-24 08:05:16.627591+00	password	65067992-d4af-45ed-9170-11058741e8b8
49e49799-b664-4fb4-bef7-a5bb6346168b	2026-04-24 13:17:54.483904+00	2026-04-24 13:17:54.483904+00	otp	c0a3784b-7017-40bc-a2ae-d889628de648
a20c7498-82e9-49ac-a51e-fdb78a554ba5	2026-04-24 13:20:19.853951+00	2026-04-24 13:20:19.853951+00	password	52782299-3ba3-4053-a47b-59a107a1237c
7562ee6f-9b69-4bec-af3b-426c2034b24e	2026-04-24 18:18:17.044754+00	2026-04-24 18:18:17.044754+00	password	b3cdf7a3-a544-409c-9511-781206193fde
f96b554f-e06a-4162-9da1-d4c39c097093	2026-04-27 08:08:28.328636+00	2026-04-27 08:08:28.328636+00	password	f75f473d-5c4d-408c-a385-676492320ff9
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
00000000-0000-0000-0000-000000000000	421	36q66ajw3gna	2549f3dd-74dd-473b-be44-d5983b70e1ba	t	2026-03-05 10:24:03.068278+00	2026-03-09 20:31:52.306968+00	tjy6ql5uy3z7	dc5e3fbe-b5d0-475a-811e-9761f35394ae
00000000-0000-0000-0000-000000000000	725	opp2mlezm72a	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-20 06:07:03.835528+00	2026-03-21 16:33:25.021596+00	4w2ez5kc63b5	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	352	4h64zynwlsju	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-02-28 09:28:41.589596+00	2026-03-05 10:31:00.839962+00	\N	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	351	thc4wkhzm7sg	00872e2b-9e9c-442f-810c-bfd62ee8a524	f	2026-02-28 09:27:58.668778+00	2026-02-28 09:27:58.668778+00	\N	d9684c6e-99ba-4147-add5-ab40d1ed36e9
00000000-0000-0000-0000-000000000000	612	ih3f45mf4m3l	ff1dccb8-00bc-4042-a869-3a55773f3701	f	2026-03-15 14:23:51.03362+00	2026-03-15 14:23:51.03362+00	ddrsca2bepxk	1b59da56-646e-48d2-bd35-e145b3703d7c
00000000-0000-0000-0000-000000000000	331	agd7rgl4zlt5	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-02-26 16:55:50.19275+00	2026-02-28 09:31:29.502763+00	h47lzyfurdtw	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	781	7m5ub2axou45	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-21 16:33:25.033084+00	2026-03-21 17:57:49.077733+00	opp2mlezm72a	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	681	vxjwb2a6cgyt	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-19 09:31:03.351432+00	2026-03-19 12:54:03.500756+00	3x5jza3m2r2u	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	688	krxvrfz25kiy	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-03-19 12:35:53.074232+00	2026-03-19 15:33:24.025647+00	ktc2l2zpt3xk	081a1ba2-f2b2-4359-b2a7-eb90d1281bc4
00000000-0000-0000-0000-000000000000	358	q553j3j6aa35	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-02-28 14:28:46.1977+00	2026-02-28 17:18:02.820602+00	b6hadqzauvz6	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	695	be4rz6f4onah	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-03-19 15:33:24.043509+00	2026-03-19 16:36:10.951854+00	krxvrfz25kiy	081a1ba2-f2b2-4359-b2a7-eb90d1281bc4
00000000-0000-0000-0000-000000000000	509	3srsd4uiharx	2549f3dd-74dd-473b-be44-d5983b70e1ba	t	2026-03-09 20:31:52.313181+00	2026-03-19 17:46:08.284902+00	36q66ajw3gna	dc5e3fbe-b5d0-475a-811e-9761f35394ae
00000000-0000-0000-0000-000000000000	704	tha35gva32hg	2549f3dd-74dd-473b-be44-d5983b70e1ba	f	2026-03-19 17:46:08.288688+00	2026-03-19 17:46:08.288688+00	3srsd4uiharx	dc5e3fbe-b5d0-475a-811e-9761f35394ae
00000000-0000-0000-0000-000000000000	422	aasclrxantuw	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-05 10:25:51.741875+00	2026-03-05 12:10:45.442452+00	qrktkycxqqhw	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	374	jjqx5fpobrdp	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-01 19:14:31.347655+00	2026-03-06 18:13:37.465495+00	\N	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	310	fod7hk2kvnwn	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-02-25 11:51:07.566807+00	2026-03-07 11:23:04.38012+00	\N	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1812	rf3fdepnldfg	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-20 10:12:01.199954+00	2026-04-20 11:14:00.755142+00	\N	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	322	2owhxzrnjjqa	943a493d-044c-4c88-babc-e64804553bb4	f	2026-02-25 19:24:42.894515+00	2026-02-25 19:24:42.894515+00	\N	f5e23156-f5ae-48ef-acdc-e813d7be5ebb
00000000-0000-0000-0000-000000000000	364	22mtg4gytb4q	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-01 09:04:29.969207+00	2026-03-01 16:31:30.043512+00	27iynpwo2by3	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1839	w6ttaxgb566d	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-21 05:53:45.251015+00	2026-04-21 10:14:59.263172+00	lo3vnb24b6sy	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	428	mv5zrrkbnrdz	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-05 11:56:07.126221+00	2026-03-07 11:49:12.560084+00	lndzqbtlwd2g	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	370	uhljvx5l2fbb	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-01 16:21:23.98866+00	2026-03-01 18:15:20.651086+00	knxohbbfycx2	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1247	slpksd7mtcsi	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-03 20:38:24.797814+00	2026-04-04 18:11:24.149814+00	iup56z3vsy3m	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	311	gkogw7zjfmun	2549f3dd-74dd-473b-be44-d5983b70e1ba	t	2026-02-25 11:51:51.266508+00	2026-02-26 10:55:21.365183+00	\N	dc5e3fbe-b5d0-475a-811e-9761f35394ae
00000000-0000-0000-0000-000000000000	380	xnfplbgrzhbj	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-02 11:01:55.17472+00	2026-03-08 08:30:27.271298+00	\N	2080d919-8941-487a-9911-23ed6ebe6c37
00000000-0000-0000-0000-000000000000	302	lma6e5jjxd7i	b5d23981-469b-4353-a615-9e4d6c8d8daf	t	2026-02-21 18:35:43.818319+00	2026-03-08 20:25:06.135558+00	\N	9952d18a-a0af-4cbd-98dc-15844d29d1ed
00000000-0000-0000-0000-000000000000	1865	df7p5pkw325h	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-21 17:41:34.542893+00	2026-04-21 19:01:27.422587+00	oicbnor5sfq2	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	426	ujwravtrtuy6	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-05 11:09:28.645222+00	2026-03-09 11:37:53.737244+00	j4rircruo2vp	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	802	7v5udmqgo4ez	4f008550-7b28-4437-923b-3438f4aed317	t	2026-03-22 06:29:36.88635+00	2026-03-22 12:56:14.795443+00	wrf2j4i4m5th	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1891	2pcbhduckafw	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 05:05:16.783576+00	2026-04-22 06:27:27.868534+00	44pdiehdehlu	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	809	oxzs7ohbpg6w	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-22 10:42:16.618027+00	2026-03-22 13:49:02.653271+00	lkf7vevsboa2	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	718	ziafj3keiiek	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-03-19 21:29:01.152898+00	2026-03-20 22:14:02.921177+00	dnax2uetqbcq	081a1ba2-f2b2-4359-b2a7-eb90d1281bc4
00000000-0000-0000-0000-000000000000	776	e7sejzozxz5e	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-21 16:16:29.401277+00	2026-03-22 15:40:52.469548+00	3nijkpbqbfvr	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	328	h47lzyfurdtw	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-02-26 13:49:28.53714+00	2026-02-26 16:55:50.167808+00	\N	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	1892	q67amrzqzhwy	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-22 05:06:02.664133+00	2026-04-22 19:43:11.312393+00	5dpyojjvme2v	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1944	e2yujkwirrjz	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-22 19:50:06.678614+00	2026-04-23 08:00:25.788811+00	afoo53m2fe2g	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1918	7iv2lk6ss2ka	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-22 12:18:25.25388+00	2026-04-23 09:54:29.945518+00	eyoxqdewp453	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	747	3nijkpbqbfvr	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-20 19:58:53.113579+00	2026-03-21 16:16:29.399684+00	6pj3vfpintq3	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1970	ovbv4gd6gt6z	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-23 16:43:23.700517+00	2026-04-23 19:24:32.69327+00	2m5viz3oc3xo	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	2032	sic5aas7jgbh	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-25 07:42:53.778887+00	2026-04-25 14:53:01.79651+00	njypiktxk7vg	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	2057	odnqerzam3dh	c06aa55d-9cd6-4f14-8d85-6c5739913994	f	2026-04-27 07:22:26.138775+00	2026-04-27 07:22:26.138775+00	buydantsaiuj	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1997	cz2r4itq3uzt	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-24 15:39:22.609357+00	2026-04-27 07:27:34.083317+00	4umhx2cyi74u	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	390	rd47thwqofdj	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-02 22:41:23.073677+00	2026-03-03 22:22:59.757361+00	\N	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	845	2ioxbcneisbi	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-23 10:17:23.752591+00	2026-03-23 11:23:48.641758+00	exvbqdrbzakw	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	823	eono46z54dko	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-22 19:19:06.784902+00	2026-03-23 13:36:27.716383+00	gl45rpfimspm	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	849	sjkroi6rrdwt	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-23 11:16:55.664357+00	2026-03-23 17:20:56.093532+00	4nhjud6mhkjl	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	788	f7wemkepmmwi	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-21 19:58:27.763744+00	2026-03-23 18:58:23.968792+00	zwnqlxnducos	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	326	ltnuap275xkl	2549f3dd-74dd-473b-be44-d5983b70e1ba	t	2026-02-26 10:55:21.382661+00	2026-03-04 17:07:07.619355+00	gkogw7zjfmun	dc5e3fbe-b5d0-475a-811e-9761f35394ae
00000000-0000-0000-0000-000000000000	417	jr45hfagthiz	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-05 07:23:56.708131+00	2026-03-05 09:27:22.229331+00	4qkpriojedkf	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	418	qrktkycxqqhw	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-05 09:27:22.261645+00	2026-03-05 10:25:51.740307+00	jr45hfagthiz	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	769	yy7pngbzjceo	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-03-21 13:32:47.898003+00	2026-03-21 16:49:45.31439+00	\N	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	510	dyjdkm3dov3s	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-09 20:53:59.141496+00	2026-03-11 16:49:41.667899+00	5rqsdeen6pjy	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1067	gw7l3l3tfxl7	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-30 08:18:05.605831+00	2026-03-30 10:58:38.27648+00	odga226u7a3d	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	402	5mejvra5si7q	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-03 22:22:59.785006+00	2026-03-05 11:07:31.736824+00	rd47thwqofdj	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	396	ipx62bj5krp4	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-03 15:42:46.875572+00	2026-03-15 09:27:05.080827+00	qv3hwuxvojnv	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	355	b6hadqzauvz6	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-02-28 11:22:27.68552+00	2026-02-28 14:28:46.177377+00	\N	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	373	j4rircruo2vp	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-01 18:15:20.668985+00	2026-03-05 11:09:28.643362+00	uhljvx5l2fbb	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	359	rckmrcznecb5	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-02-28 17:18:02.850298+00	2026-02-28 23:34:06.655983+00	q553j3j6aa35	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1814	3a4cp2rg7zaf	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-20 10:57:36.918033+00	2026-04-20 11:57:38.389889+00	dxravzcliiqp	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	423	lndzqbtlwd2g	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-05 10:31:00.842792+00	2026-03-05 11:56:07.104359+00	4h64zynwlsju	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	689	5ogqcprfxfjy	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-19 12:54:03.523094+00	2026-03-19 17:09:50.453086+00	vxjwb2a6cgyt	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	361	27iynpwo2by3	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-02-28 23:34:06.670642+00	2026-03-01 09:04:29.945505+00	rckmrcznecb5	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	782	7sp3aedmsmhw	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-03-21 16:49:45.324706+00	2026-03-21 20:44:12.712615+00	yy7pngbzjceo	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	682	vilet66s3hwi	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-19 10:05:01.439963+00	2026-03-19 18:27:33.294272+00	\N	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1840	pnxitrxmqroo	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 06:58:38.868029+00	2026-04-21 09:32:31.857128+00	h6hnbtnktcm2	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1813	q3zem4z6x3eo	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-20 10:57:12.584478+00	2026-04-21 11:04:08.867106+00	buda6hdykx76	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	365	knxohbbfycx2	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-01 09:34:58.312399+00	2026-03-01 16:21:23.966515+00	\N	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1455	n5ouoga4ypde	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-04-11 16:29:10.959095+00	2026-04-15 10:51:58.255572+00	y4ib2jssta6e	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	733	nryqjzp7yxm3	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-03-20 10:55:01.889128+00	2026-03-20 10:55:01.889128+00	at3vgsxcevfq	eb06df08-bb8f-4413-962c-db927135684a
00000000-0000-0000-0000-000000000000	353	pjkyv5h5n226	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-02-28 09:31:29.504723+00	2026-03-05 12:47:31.97298+00	agd7rgl4zlt5	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	1893	sb3eel3qgtn5	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-22 05:55:41.640021+00	2026-04-22 07:15:46.922084+00	ipft4sejwekx	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	741	6pj3vfpintq3	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-20 14:51:11.642334+00	2026-03-20 19:58:53.091019+00	5uiolz7v73lb	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1919	mfdgudco2fds	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-04-22 12:32:13.045461+00	2026-04-22 14:39:37.501681+00	pg45inespv7a	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	1945	4gxuk4k7u53b	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 19:51:57.136863+00	2026-04-22 20:51:58.298367+00	xxzlp3rdq6ya	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1971	hmbgkgfkcp7d	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 16:50:00.816406+00	2026-04-23 17:50:01.586316+00	bh5mbjprbun7	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	371	f3ltuy725gaz	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-01 16:31:30.056597+00	2026-03-02 14:11:44.614743+00	22mtg4gytb4q	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1998	zndy5joa4tz5	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-24 15:50:16.801296+00	2026-04-24 17:24:30.839949+00	5mab2d5fxseq	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1866	bfa6jumzx4wf	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-04-21 18:01:25.182927+00	2026-04-25 08:23:34.01099+00	7n5vgazjvm5i	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	2033	xwcdltdyvqj3	2f58705a-25ad-42c9-b953-5137532b3584	f	2026-04-25 08:23:34.034893+00	2026-04-25 08:23:34.034893+00	bfa6jumzx4wf	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	2058	ulrt2cw74d5d	c06aa55d-9cd6-4f14-8d85-6c5739913994	f	2026-04-27 07:27:34.091713+00	2026-04-27 07:27:34.091713+00	cz2r4itq3uzt	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	389	pqs6pkk433uk	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-02 22:26:38.753324+00	2026-03-03 12:37:28.705062+00	\N	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	433	heqwh3x4h422	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-05 12:47:31.987443+00	2026-03-05 14:29:04.597003+00	pjkyv5h5n226	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	393	qv3hwuxvojnv	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-03 12:37:28.727961+00	2026-03-03 15:42:46.874026+00	pqs6pkk433uk	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	387	inr6hzjmjj7t	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-02 14:11:44.632446+00	2026-03-03 16:06:24.890668+00	f3ltuy725gaz	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	778	yrz5wvmr63it	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-03-21 16:20:11.322083+00	2026-03-23 15:14:46.219525+00	gb5o6joei2ax	88dfd653-2835-4f26-bd15-7c0eeb6241ab
00000000-0000-0000-0000-000000000000	777	hey2amwwv6oj	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	t	2026-03-21 16:19:38.945264+00	2026-03-23 18:23:03.483104+00	4q3w6cdlyuw4	70a887fe-cbf5-435c-85c9-3691006bbab8
00000000-0000-0000-0000-000000000000	810	ohggjzjgwrln	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-22 10:51:22.935691+00	2026-03-24 11:26:40.69016+00	rdyg5iqpqi4y	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	712	3px3rcod75hw	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-19 19:31:09.666239+00	2026-03-25 08:14:41.064042+00	3ly7x4gfy23q	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	437	w7dzlvw3bsby	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-05 14:29:04.60753+00	2026-03-05 16:10:20.732594+00	heqwh3x4h422	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	398	btsvu36q3bco	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-03 16:06:24.904798+00	2026-03-05 01:22:49.679895+00	inr6hzjmjj7t	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	416	4qkpriojedkf	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-05 01:22:49.70874+00	2026-03-05 07:23:56.683821+00	btsvu36q3bco	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	414	tjy6ql5uy3z7	2549f3dd-74dd-473b-be44-d5983b70e1ba	t	2026-03-04 17:07:07.637854+00	2026-03-05 10:24:03.058453+00	ltnuap275xkl	dc5e3fbe-b5d0-475a-811e-9761f35394ae
00000000-0000-0000-0000-000000000000	440	ll6e65jcmkeg	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-05 16:10:20.754004+00	2026-03-05 17:19:27.130588+00	w7dzlvw3bsby	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	431	zpsdzrbhq3r5	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-05 12:10:45.443243+00	2026-03-05 19:54:31.134537+00	aasclrxantuw	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	425	2v2ejoemhpck	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-05 11:07:31.74839+00	2026-03-05 22:00:06.916733+00	5mejvra5si7q	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	488	5rqsdeen6pjy	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-09 01:43:01.221212+00	2026-03-09 20:53:59.127399+00	y2ycpqewwu7i	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	469	y2pzkjq6bo47	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-07 15:03:45.511025+00	2026-03-09 21:16:11.77038+00	gsefngz2so2n	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	487	jibxcdhp4oqw	b5d23981-469b-4353-a615-9e4d6c8d8daf	t	2026-03-09 00:27:49.732242+00	2026-03-10 02:33:01.381103+00	pguqsjzcx5gx	9952d18a-a0af-4cbd-98dc-15844d29d1ed
00000000-0000-0000-0000-000000000000	448	423jlotmc4sa	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-05 22:00:06.938954+00	2026-03-10 14:23:39.201159+00	2v2ejoemhpck	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	915	k5bvfcqikde6	8d16ce77-1836-4ce6-a462-b9d16358fb3f	f	2026-03-25 13:16:00.794641+00	2026-03-25 13:16:00.794641+00	2kgrqioeu27k	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	462	mrdllzqwuav2	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-07 12:25:08.902924+00	2026-03-10 18:37:02.030295+00	uvxxwv6ra6d6	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	477	oimfrjxq2sel	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-08 08:30:27.30143+00	2026-03-11 16:39:06.663224+00	xnfplbgrzhbj	2080d919-8941-487a-9911-23ed6ebe6c37
00000000-0000-0000-0000-000000000000	475	oiagsp7jcuzb	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-07 22:04:55.499408+00	2026-03-11 20:17:42.640152+00	xs74kb3pi6c7	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	1815	tnl7f5dseop4	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-20 11:11:51.061728+00	2026-04-20 18:44:52.133801+00	rken2ldhtlzk	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1841	567gogeyc5lg	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 08:32:07.388314+00	2026-04-21 09:31:53.383439+00	ibkblci4a77y	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	697	etwgluyxnays	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-03-19 16:36:10.963448+00	2026-03-19 17:38:25.231463+00	be4rz6f4onah	081a1ba2-f2b2-4359-b2a7-eb90d1281bc4
00000000-0000-0000-0000-000000000000	780	64oatokenbwq	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-21 16:23:46.411223+00	2026-03-21 21:40:02.208529+00	mizhu4kbsnos	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1867	fhinv3iavnbj	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 18:05:09.574663+00	2026-04-21 22:16:09.440828+00	sdr7rhfc7mxq	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	713	xc4cxihvk3li	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-19 19:38:36.810664+00	2026-03-19 21:43:26.564323+00	krvtsq76ghxb	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1894	mncrhemd7ddi	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 06:27:27.888889+00	2026-04-22 07:29:28.911164+00	2pcbhduckafw	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	453	enp2dgrlcprp	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-06 18:13:37.485795+00	2026-03-06 19:45:39.775549+00	jjqx5fpobrdp	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	1920	5mxdurcwogy3	e804e0cf-72af-449e-9816-46518b271b84	f	2026-04-22 12:35:14.578316+00	2026-04-22 12:35:14.578316+00	io3nkecssj3x	da99741b-fb99-4474-9fa9-fd3e49543738
00000000-0000-0000-0000-000000000000	1946	36zm3xkqyb3m	16f4402c-a1b5-4431-8d98-c454f52a6284	f	2026-04-22 20:20:50.24594+00	2026-04-22 20:20:50.24594+00	vr5xewf4bz3e	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1972	6bpuwyx4gai4	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 17:50:01.603163+00	2026-04-23 18:50:02.650943+00	hmbgkgfkcp7d	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	458	nmg3pnvsnjxz	943a493d-044c-4c88-babc-e64804553bb4	f	2026-03-07 11:33:17.542791+00	2026-03-07 11:33:17.542791+00	\N	b1d00248-1278-4fa0-97be-da56fa5926a5
00000000-0000-0000-0000-000000000000	446	23gwcmga3uvr	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-05 19:54:31.151514+00	2026-03-07 11:36:34.338859+00	zpsdzrbhq3r5	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	457	uvxxwv6ra6d6	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-07 11:23:04.401511+00	2026-03-07 12:25:08.882818+00	fod7hk2kvnwn	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	2004	iryqwfs7cgre	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	f	2026-04-24 15:58:15.846719+00	2026-04-24 15:58:15.846719+00	nen6vh7wmrox	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	459	jbxm5h34yyye	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-07 11:36:34.346427+00	2026-03-07 12:48:17.549111+00	23gwcmga3uvr	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	2003	fcguqabcim77	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-04-24 15:58:14.667531+00	2026-04-24 17:10:49.119175+00	qgc5edwodgtw	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	2002	ssqntv7qrgkh	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-24 15:57:27.744999+00	2026-04-24 19:51:58.889097+00	hr4qfy2xzyfs	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	818	gl45rpfimspm	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-22 16:53:13.749875+00	2026-03-22 19:19:06.769916+00	cusflggzwo6h	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	461	e6rmwyechpfx	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-07 11:49:12.561987+00	2026-03-07 13:06:04.515628+00	mv5zrrkbnrdz	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	444	qeuhhky76vve	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-05 17:19:27.140909+00	2026-03-07 13:40:40.025906+00	ll6e65jcmkeg	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	2001	eg44yv2scrvs	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-24 15:55:28.97718+00	2026-04-25 10:18:17.8498+00	gdvt6yxjae2y	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	465	npmb6glenrlt	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-07 13:06:04.516421+00	2026-03-07 14:04:26.214909+00	e6rmwyechpfx	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	2000	a66g4oro3x45	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	t	2026-04-24 15:55:05.248719+00	2026-04-26 19:52:54.153694+00	rvmeqkqesx5i	a20c7498-82e9-49ac-a51e-fdb78a554ba5
00000000-0000-0000-0000-000000000000	825	z4amquzxvwyz	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-03-22 19:53:28.582453+00	2026-03-22 19:53:28.582453+00	\N	b18ad4a5-a8fe-46b6-8855-7d907cfcaf2a
00000000-0000-0000-0000-000000000000	720	flauy6fdwhm6	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-19 21:43:26.572516+00	2026-03-22 20:51:43.516515+00	xc4cxihvk3li	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	467	gsefngz2so2n	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-07 14:04:26.223334+00	2026-03-07 15:03:45.496638+00	npmb6glenrlt	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	790	jwdhpgo6o7hy	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-21 20:13:32.131652+00	2026-03-22 20:52:24.309748+00	rd72tqoelemk	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	463	4izfxwgkxem7	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-07 12:48:17.559339+00	2026-03-07 15:44:12.92455+00	jbxm5h34yyye	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	466	fspjkxzze2wd	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-07 13:40:40.037538+00	2026-03-07 16:28:36.586249+00	qeuhhky76vve	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	2034	nmenc4s3ow3s	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-25 09:29:14.182519+00	2026-04-27 08:16:48.103776+00	gbjfg6psgzjx	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1999	4foirhxnaogw	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-24 15:52:56.921363+00	2026-04-27 08:20:12.594146+00	msdp3m4t32j3	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	2059	tkqrbq5h33dn	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-04-27 08:02:36.633258+00	2026-04-27 09:05:25.363896+00	rsi5dqjuqxaa	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	471	tmru3zlxuipm	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-07 16:28:36.60141+00	2026-03-07 18:39:54.063246+00	fspjkxzze2wd	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	473	xs74kb3pi6c7	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-07 18:39:54.085844+00	2026-03-07 22:04:55.465018+00	tmru3zlxuipm	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	470	5u2ncayzb6xe	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-07 15:44:12.942731+00	2026-03-08 15:01:29.860602+00	4izfxwgkxem7	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	479	2vv7gosnwd6t	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-08 15:01:29.873581+00	2026-03-08 19:55:21.60264+00	5u2ncayzb6xe	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	480	wo3c7lb74kme	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-08 19:55:21.629368+00	2026-03-08 21:34:57.40795+00	2vv7gosnwd6t	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	485	pguqsjzcx5gx	b5d23981-469b-4353-a615-9e4d6c8d8daf	t	2026-03-08 20:25:06.154118+00	2026-03-09 00:27:49.71254+00	lma6e5jjxd7i	9952d18a-a0af-4cbd-98dc-15844d29d1ed
00000000-0000-0000-0000-000000000000	486	y2ycpqewwu7i	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-08 21:34:57.429462+00	2026-03-09 01:43:01.20887+00	wo3c7lb74kme	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	484	rk6ps4sg67nh	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-08 20:08:11.816441+00	2026-03-09 17:20:57.453771+00	\N	1b59da56-646e-48d2-bd35-e145b3703d7c
00000000-0000-0000-0000-000000000000	454	64w4hvjfx4t5	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-06 19:45:39.797764+00	2026-03-09 20:21:17.141204+00	enp2dgrlcprp	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	521	ub6tghatpjlz	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-10 10:55:52.761763+00	2026-03-15 19:07:50.21533+00	rc34f47ss2bb	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	515	y3u76ajr7lkb	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-09 23:46:14.867928+00	2026-03-16 08:27:29.210804+00	dra3w7alevey	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1816	lpizjz3lwoex	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-20 11:14:00.770696+00	2026-04-20 12:16:08.24946+00	rf3fdepnldfg	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	524	7mfaxdb3uk3t	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-10 18:37:02.057117+00	2026-03-18 11:53:21.530373+00	mrdllzqwuav2	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	691	lwfghvciqwqx	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-03-19 13:38:05.514088+00	2026-03-19 15:07:00.314052+00	\N	88dfd653-2835-4f26-bd15-7c0eeb6241ab
00000000-0000-0000-0000-000000000000	495	cwaunp6bqs4b	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-09 11:37:53.743528+00	2026-03-09 13:31:35.08619+00	ujwravtrtuy6	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1842	tx2n5kpdp67n	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-21 08:40:50.19345+00	2026-04-21 15:59:43.25021+00	32ogl3c2xfd3	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	501	dra3w7alevey	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-09 14:55:28.663887+00	2026-03-09 23:46:14.84659+00	lsp2izmdlj75	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1868	3osp225myykx	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 18:43:35.813609+00	2026-04-21 19:43:30.107817+00	bfft5mekfa2o	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	498	lsp2izmdlj75	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-09 13:31:35.115565+00	2026-03-09 14:55:28.658485+00	cwaunp6bqs4b	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1921	lkqhkbdioool	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 12:51:50.226673+00	2026-04-22 13:51:51.075369+00	z2hymkzjplbv	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1250	4foljkutuesm	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-03 21:24:15.732674+00	2026-04-03 22:58:16.21899+00	th536mzebykz	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1895	2yu4olmxrgob	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-22 06:34:25.304288+00	2026-04-22 19:47:38.468287+00	wzpgshocihkr	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	714	rdyg5iqpqi4y	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-19 19:39:57.135944+00	2026-03-22 10:51:22.917781+00	gqop6gw3gkcz	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	496	ayhyvr7qowpe	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-09 11:59:31.85884+00	2026-03-09 16:51:59.367742+00	\N	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1947	2rpjbz7ihfdy	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 20:40:13.394119+00	2026-04-23 07:19:52.470558+00	wpxzanyvx63f	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1248	ihrdixk2uw5g	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-03 21:07:04.327278+00	2026-04-04 11:27:39.10791+00	oioyj5gadc4c	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1251	hjlsivdk4os3	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-03 22:51:10.216072+00	2026-04-04 16:48:09.444972+00	iaxn5ntjblmr	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1973	36szhrs3k5r6	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 18:50:02.676528+00	2026-04-23 19:50:03.307388+00	6bpuwyx4gai4	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2005	kqmcpwqarzc6	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-24 16:01:40.80085+00	2026-04-24 20:42:17.635997+00	5ys2hrq5w3ru	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	750	yrsowyp4otry	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-03-20 22:14:02.944134+00	2026-03-21 10:41:25.855575+00	ziafj3keiiek	081a1ba2-f2b2-4359-b2a7-eb90d1281bc4
00000000-0000-0000-0000-000000000000	2060	hjl5d3jlqiny	0e9bdb55-a555-467d-995a-62d64ab8a509	f	2026-04-27 08:03:51.457162+00	2026-04-27 08:03:51.457162+00	zxskho3ua6vk	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	507	ibdp6p5sv2h2	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-09 20:21:17.171979+00	2026-03-10 09:02:24.034018+00	64w4hvjfx4t5	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	826	exvbqdrbzakw	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-22 20:36:15.277315+00	2026-03-23 10:17:23.743205+00	qj7zxbsb27eo	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	520	rc34f47ss2bb	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-10 09:02:24.036159+00	2026-03-10 10:55:52.729409+00	ibdp6p5sv2h2	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	2061	nz7wnyc24unl	7d59efea-fc42-4117-a34b-3937905456db	f	2026-04-27 08:04:48.874175+00	2026-04-27 08:04:48.874175+00	6rj3f7hj2xhy	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	698	35a5vp4espdx	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-03-19 17:02:05.30608+00	2026-03-21 16:14:46.564249+00	\N	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	2035	bonq7e2v42ks	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-25 10:18:17.865453+00	2026-04-27 08:04:54.225696+00	eg44yv2scrvs	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	2062	kn7q2rslie2d	449ee91c-f52f-4661-abd4-ebfd556c37c3	f	2026-04-27 08:04:54.238362+00	2026-04-27 08:04:54.238362+00	bonq7e2v42ks	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	505	m5ur5p7vz24e	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-09 16:51:59.386069+00	2026-03-23 18:12:07.496811+00	ayhyvr7qowpe	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	784	hqm4aoilse3g	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-21 17:49:31.601431+00	2026-03-23 21:05:45.049788+00	rwzsbx5bytdn	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	506	frcfzqsmervs	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-09 17:20:57.475688+00	2026-03-10 18:52:48.562495+00	rk6ps4sg67nh	1b59da56-646e-48d2-bd35-e145b3703d7c
00000000-0000-0000-0000-000000000000	812	crspqc27godt	4f008550-7b28-4437-923b-3438f4aed317	t	2026-03-22 12:56:14.811781+00	2026-03-25 08:04:35.632536+00	7v5udmqgo4ez	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	2063	akbwyqh3h7bw	ec1c03bd-6b21-4574-aff7-39deac5e25bf	f	2026-04-27 08:06:11.65178+00	2026-04-27 08:06:11.65178+00	pouqgw433bom	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	511	szoyjm5uvzon	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-09 21:16:11.778228+00	2026-03-11 13:43:55.312692+00	y2pzkjq6bo47	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	531	rhuzqthw2mtg	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-11 13:43:55.338415+00	2026-03-11 16:41:55.456361+00	szoyjm5uvzon	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	534	x3qahht752rn	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-11 16:41:55.459078+00	2026-03-11 20:52:58.07292+00	rhuzqthw2mtg	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	538	zfqglxhp7lqc	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-11 20:52:58.089965+00	2026-03-11 21:53:24.531502+00	x3qahht752rn	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	539	yum6apesmxdw	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-11 21:53:24.556314+00	2026-03-12 09:29:32.821912+00	zfqglxhp7lqc	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	540	eago65jpdbcd	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-12 09:29:32.853574+00	2026-03-12 10:28:26.30719+00	yum6apesmxdw	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	541	kown3muiqlwx	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-12 10:28:26.326852+00	2026-03-12 17:17:33.858283+00	eago65jpdbcd	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	543	ggqeszdu7u4v	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-12 17:17:33.890429+00	2026-03-12 18:17:34.033816+00	kown3muiqlwx	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	530	a5b7pr763q4f	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-11 13:14:34.202437+00	2026-03-13 16:46:48.073871+00	\N	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	535	cosm73wvo3eh	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-11 16:49:41.676009+00	2026-03-13 17:12:32.651837+00	dyjdkm3dov3s	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	494	eblxsqb3zf7l	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-09 11:32:37.159297+00	2026-03-13 17:33:31.676841+00	\N	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	522	m3ek56gztrw4	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-10 14:23:39.230141+00	2026-03-13 22:29:59.171211+00	423jlotmc4sa	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	537	hof4cjdkj63d	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-11 20:17:42.652679+00	2026-03-14 08:45:47.01941+00	oiagsp7jcuzb	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	533	3rckzbocv4jk	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-11 16:39:06.667756+00	2026-03-14 13:50:21.147836+00	oimfrjxq2sel	2080d919-8941-487a-9911-23ed6ebe6c37
00000000-0000-0000-0000-000000000000	516	n4yukuufsxps	b5d23981-469b-4353-a615-9e4d6c8d8daf	t	2026-03-10 02:33:01.446351+00	2026-03-14 20:35:38.873306+00	jibxcdhp4oqw	9952d18a-a0af-4cbd-98dc-15844d29d1ed
00000000-0000-0000-0000-000000000000	526	rhqghhdhp744	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-10 18:52:48.573252+00	2026-03-14 20:36:19.63839+00	frcfzqsmervs	1b59da56-646e-48d2-bd35-e145b3703d7c
00000000-0000-0000-0000-000000000000	545	rdz3ws3sc6hs	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-12 18:17:34.040252+00	2026-03-12 21:43:27.349126+00	ggqeszdu7u4v	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	592	67jaeqdce5b6	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-14 20:59:47.933163+00	2026-03-16 08:45:17.339063+00	fngnuctfe2oc	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	582	5dhkqsp5ivgm	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-14 13:50:21.17304+00	2026-03-16 11:34:31.461032+00	3rckzbocv4jk	2080d919-8941-487a-9911-23ed6ebe6c37
00000000-0000-0000-0000-000000000000	685	ktc2l2zpt3xk	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-03-19 11:35:59.41268+00	2026-03-19 12:35:53.06122+00	\N	081a1ba2-f2b2-4359-b2a7-eb90d1281bc4
00000000-0000-0000-0000-000000000000	587	rfysek6zitfr	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-14 17:45:43.846757+00	2026-03-16 15:07:37.197639+00	4wpxhj2wxx4x	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	1817	2vniwbzoocmf	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-20 11:57:38.410372+00	2026-04-20 12:57:39.031717+00	3a4cp2rg7zaf	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1245	pyimkvsdl242	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-04-03 18:28:22.429892+00	2026-04-03 18:28:22.429892+00	\N	9ce1e1c0-e99f-463e-9d96-5b502b42f126
00000000-0000-0000-0000-000000000000	1240	5wr5ys4to7v4	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-03 15:37:28.532337+00	2026-04-03 21:09:24.906906+00	63z7fzx7nlyh	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1069	ph5tqwjw4hl5	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	t	2026-03-30 08:30:27.916248+00	2026-03-30 09:30:38.484345+00	\N	57a95f55-f4e7-4e58-9a02-64c9586203b8
00000000-0000-0000-0000-000000000000	785	zxvuxmmb4dxr	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-21 17:57:49.086891+00	2026-03-21 21:01:39.807413+00	7m5ub2axou45	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	792	z2m67c7cgmgw	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-03-21 20:44:12.737852+00	2026-03-25 22:18:21.206903+00	7sp3aedmsmhw	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1843	azf4ce357uzz	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 09:31:53.407132+00	2026-04-21 10:31:30.411384+00	567gogeyc5lg	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1844	icboj5lhdgrs	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 09:32:31.858911+00	2026-04-21 10:43:13.44014+00	pnxitrxmqroo	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	715	ppictth52jyu	b5d23981-469b-4353-a615-9e4d6c8d8daf	f	2026-03-19 20:21:02.861793+00	2026-03-19 20:21:02.861793+00	qxo3r4gjqopi	9952d18a-a0af-4cbd-98dc-15844d29d1ed
00000000-0000-0000-0000-000000000000	708	ijt7crz7jmyd	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-19 18:22:06.646006+00	2026-03-19 22:30:58.610118+00	afshdy3hezko	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	806	3wdizz2dwgsf	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-03-22 09:04:35.532134+00	2026-03-22 09:04:35.532134+00	\N	2a702674-f270-4024-b5a3-48a39b7c072c
00000000-0000-0000-0000-000000000000	1249	5ghz3pgllswp	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-03 21:09:24.910352+00	2026-04-06 10:12:29.362557+00	5wr5ys4to7v4	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1870	tkrxewuvos5c	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-21 19:01:27.424685+00	2026-04-21 20:01:28.42943+00	df7p5pkw325h	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1869	6a4uxeyeqter	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-21 19:01:00.943103+00	2026-04-21 22:24:24.333955+00	zddckbbbge5x	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	547	dshttgrsbdmj	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-13 16:46:48.099343+00	2026-03-13 22:35:30.706632+00	a5b7pr763q4f	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	736	5uiolz7v73lb	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-20 12:41:46.873502+00	2026-03-20 14:51:11.612986+00	\N	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1896	gl6i67uyihfw	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-22 06:46:52.21132+00	2026-04-22 09:11:25.038484+00	r6xne4uzp3ae	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1922	2w25nxmulsf6	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 13:25:45.136484+00	2026-04-22 14:47:12.502119+00	hz4sr2m5q6wn	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	553	oqx3emo7k72x	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-13 17:33:31.692434+00	2026-03-13 23:29:23.480033+00	eblxsqb3zf7l	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1948	aec4wdag7sya	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 20:51:58.322529+00	2026-04-22 21:51:58.824459+00	4gxuk4k7u53b	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	549	3bbxkruuirdk	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-13 17:12:32.660826+00	2026-03-13 23:29:44.099592+00	cosm73wvo3eh	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	559	57pnmcvlrizm	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-13 22:29:59.187512+00	2026-03-13 23:55:51.129691+00	m3ek56gztrw4	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	765	icdkxbckuct2	e92aa512-c44f-48c8-b983-7c7705e36a6f	f	2026-03-21 10:41:25.874756+00	2026-03-21 10:41:25.874756+00	yrsowyp4otry	081a1ba2-f2b2-4359-b2a7-eb90d1281bc4
00000000-0000-0000-0000-000000000000	1974	ruhwuwvf66tu	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-23 19:24:32.715176+00	2026-04-23 20:42:58.538602+00	ovbv4gd6gt6z	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	699	4q3w6cdlyuw4	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	t	2026-03-19 17:07:22.126604+00	2026-03-21 16:19:38.943787+00	\N	70a887fe-cbf5-435c-85c9-3691006bbab8
00000000-0000-0000-0000-000000000000	722	mizhu4kbsnos	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-19 22:30:58.625055+00	2026-03-21 16:23:46.410778+00	ijt7crz7jmyd	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	2006	6l6kwqql27j2	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	f	2026-04-24 16:03:33.595846+00	2026-04-24 16:03:33.595846+00	y5ckax75taso	70a887fe-cbf5-435c-85c9-3691006bbab8
00000000-0000-0000-0000-000000000000	2007	2ffnswc27gae	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-04-24 16:04:07.665583+00	2026-04-24 19:21:38.520535+00	6ctfdk5uenpl	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	820	7urmakg76wzl	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-22 18:09:24.588525+00	2026-03-23 15:17:57.432028+00	l6mx6nlsdrbj	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	2036	h6cw7uozw4yq	45ef0325-e165-4aef-8836-03099f1d7bd9	f	2026-04-25 13:51:49.118818+00	2026-04-25 13:51:49.118818+00	rvalbqekf2j5	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	2064	dgk5pebgjeb5	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-04-27 08:08:28.304357+00	2026-04-27 08:08:28.304357+00	\N	f96b554f-e06a-4162-9da1-d4c39c097093
00000000-0000-0000-0000-000000000000	2065	6kgcsh5ittrs	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	t	2026-04-27 08:11:04.686368+00	2026-04-27 09:46:28.019933+00	kzs3xafuo3wz	a20c7498-82e9-49ac-a51e-fdb78a554ba5
00000000-0000-0000-0000-000000000000	546	k6wjrwwhbtek	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-12 21:43:27.374358+00	2026-03-14 13:00:23.857369+00	rdz3ws3sc6hs	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	566	m2k45aa3b6vt	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-13 23:29:44.100799+00	2026-03-14 15:23:03.792974+00	3bbxkruuirdk	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	561	myx4o6vkeha3	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-13 22:35:30.711715+00	2026-03-14 16:17:36.387528+00	dshttgrsbdmj	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	578	ligbvb2urac3	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-14 08:45:47.03321+00	2026-03-14 16:23:27.846596+00	hof4cjdkj63d	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	585	4wpxhj2wxx4x	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-14 16:17:36.413569+00	2026-03-14 17:45:43.830405+00	myx4o6vkeha3	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	584	fngnuctfe2oc	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-14 15:23:03.809587+00	2026-03-14 20:59:47.921253+00	m2k45aa3b6vt	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	589	ai6dpgnkgg22	b5d23981-469b-4353-a615-9e4d6c8d8daf	t	2026-03-14 20:35:38.885158+00	2026-03-14 23:09:01.095548+00	n4yukuufsxps	9952d18a-a0af-4cbd-98dc-15844d29d1ed
00000000-0000-0000-0000-000000000000	567	xayybyudcevj	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-13 23:55:51.144888+00	2026-03-14 23:30:18.324483+00	57pnmcvlrizm	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	565	njvth3z4nq7m	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-13 23:29:23.483334+00	2026-03-15 10:00:36.889388+00	oqx3emo7k72x	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	581	fi4rtwfmt2yw	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-14 13:00:23.870529+00	2026-03-15 10:38:41.811112+00	k6wjrwwhbtek	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	593	5ugltfftr5v5	b5d23981-469b-4353-a615-9e4d6c8d8daf	t	2026-03-14 23:09:01.112058+00	2026-03-15 11:26:43.823245+00	ai6dpgnkgg22	9952d18a-a0af-4cbd-98dc-15844d29d1ed
00000000-0000-0000-0000-000000000000	590	kbrvvntkay7a	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-14 20:36:19.639504+00	2026-03-15 11:53:29.767291+00	rhqghhdhp744	1b59da56-646e-48d2-bd35-e145b3703d7c
00000000-0000-0000-0000-000000000000	586	ljl6llu7kq62	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-14 16:23:27.856388+00	2026-03-15 12:37:49.374513+00	ligbvb2urac3	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	605	ddrsca2bepxk	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-15 11:53:29.781109+00	2026-03-15 14:23:51.011341+00	kbrvvntkay7a	1b59da56-646e-48d2-bd35-e145b3703d7c
00000000-0000-0000-0000-000000000000	1818	ap73rnpkjdcp	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-20 12:04:05.872273+00	2026-04-20 15:11:06.346683+00	bqpwt52lswr5	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1459	vinnetviz3r5	943a493d-044c-4c88-babc-e64804553bb4	f	2026-04-11 17:12:42.406443+00	2026-04-11 17:12:42.406443+00	\N	03665399-c6f6-41b4-8800-627c97ec6444
00000000-0000-0000-0000-000000000000	1845	futv26gmwxq4	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-21 10:14:59.294836+00	2026-04-21 15:53:16.852506+00	w6ttaxgb566d	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	607	dcivvttevj44	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-15 12:37:49.380042+00	2026-03-15 16:21:01.749784+00	ljl6llu7kq62	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	625	afshdy3hezko	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-16 08:27:29.216161+00	2026-03-19 18:22:06.629726+00	y3u76ajr7lkb	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1235	63z7fzx7nlyh	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-03 14:00:21.839607+00	2026-04-03 15:37:28.526873+00	iufmpliuk7wt	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	606	vtc2doxpf3ki	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-15 12:28:44.614905+00	2026-03-19 18:40:49.292015+00	ootfbigiyiqv	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	709	3ly7x4gfy23q	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-19 18:27:33.30395+00	2026-03-19 19:31:09.646685+00	vilet66s3hwi	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	628	krvtsq76ghxb	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-16 12:09:04.352583+00	2026-03-19 19:38:36.805109+00	jeaoqnn2ljhg	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	597	qoj45uhbw3nm	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-15 09:27:05.087157+00	2026-03-15 16:58:22.183335+00	ipx62bj5krp4	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	644	ywkh4ieo4isw	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-17 20:35:42.497447+00	2026-03-19 20:55:47.127212+00	sgh2vvf3r5a6	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	1871	egsqwdd5jjmn	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-21 19:38:49.146378+00	2026-04-22 03:29:58.243307+00	a373zjswebeg	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	601	ootfbigiyiqv	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-15 10:38:41.818498+00	2026-03-15 12:28:44.594412+00	fi4rtwfmt2yw	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	1246	kz2xzrzlpaje	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-03 19:43:00.37685+00	2026-04-04 14:17:08.959831+00	kpig3scu6uor	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	637	lkf7vevsboa2	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-16 19:27:15.259751+00	2026-03-22 10:42:16.61115+00	bnk4xgxjqwmj	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	1897	fqcaytnlldd6	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-22 07:15:46.948112+00	2026-04-22 08:42:15.277253+00	sb3eel3qgtn5	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	702	4w2ez5kc63b5	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-19 17:09:50.45416+00	2026-03-20 06:07:03.815954+00	5ogqcprfxfjy	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	645	d3ocj3r6rvt6	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-18 03:55:56.783567+00	2026-03-20 08:48:46.968248+00	iwaklr6jobxk	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1923	35nj3abl4yn6	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 13:39:43.633227+00	2026-04-22 14:48:55.748336+00	4mndzihud6gl	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	738	dcohlf2tc5vo	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-03-20 13:19:36.733145+00	2026-03-20 13:19:36.733145+00	\N	6eae37ff-2205-437e-88d1-9cd43a3f1345
00000000-0000-0000-0000-000000000000	730	7zw5hfyzn3fv	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-20 08:48:46.969799+00	2026-03-20 13:28:59.76166+00	d3ocj3r6rvt6	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	598	7xeyzossv2m5	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-15 10:00:36.913803+00	2026-03-15 17:59:30.235609+00	njvth3z4nq7m	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	627	d4cosrlx4l66	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-16 11:34:31.476612+00	2026-03-20 17:06:45.910009+00	5dhkqsp5ivgm	2080d919-8941-487a-9911-23ed6ebe6c37
00000000-0000-0000-0000-000000000000	745	2chvvuxxcimf	00872e2b-9e9c-442f-810c-bfd62ee8a524	f	2026-03-20 17:06:45.925081+00	2026-03-20 17:06:45.925081+00	d4cosrlx4l66	2080d919-8941-487a-9911-23ed6ebe6c37
00000000-0000-0000-0000-000000000000	1949	zyd3xq7j5nzd	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-22 21:47:30.043417+00	2026-04-23 13:45:10.460291+00	x26fzie53zxa	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	615	lno7haudwdg6	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-15 16:21:01.765312+00	2026-03-15 19:16:26.631328+00	dcivvttevj44	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	814	l6mx6nlsdrbj	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-22 13:49:02.665901+00	2026-03-22 18:09:24.570443+00	oxzs7ohbpg6w	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	1975	bgm5pazqcoos	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 19:50:03.325424+00	2026-04-23 20:50:04.241826+00	36szhrs3k5r6	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2008	yys7iczd2jd4	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-24 16:06:58.172801+00	2026-04-24 17:59:07.416151+00	5jlslytcdr3x	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	2037	fu6fmm2c6ybh	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-25 14:53:01.816623+00	2026-04-25 16:46:34.655435+00	sic5aas7jgbh	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	793	qj7zxbsb27eo	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-21 21:01:39.818539+00	2026-03-22 20:36:15.256258+00	zxvuxmmb4dxr	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	619	jeaoqnn2ljhg	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-15 17:59:30.246482+00	2026-03-16 12:09:04.325565+00	7xeyzossv2m5	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	2066	mvyys3p7ubfp	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	f	2026-04-27 08:13:13.759733+00	2026-04-27 08:13:13.759733+00	y5cpty7nrhll	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	828	rgpgjsbdvkf6	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-22 20:51:43.532758+00	2026-03-23 08:25:47.735819+00	flauy6fdwhm6	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	634	cqngixlzdrtu	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-16 15:26:52.24088+00	2026-03-23 11:18:47.094343+00	\N	8d645adf-06c6-40c0-a754-d51f12342b4e
00000000-0000-0000-0000-000000000000	635	h43v3ljlmnvd	943a493d-044c-4c88-babc-e64804553bb4	f	2026-03-16 15:53:44.107614+00	2026-03-16 15:53:44.107614+00	\N	38a7e050-8748-456e-94fe-6d81e4775134
00000000-0000-0000-0000-000000000000	843	dtrbis3qrd55	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-23 09:46:44.14085+00	2026-03-23 11:45:28.734724+00	wzs4kryh244r	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	632	bnk4xgxjqwmj	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-16 15:07:37.221842+00	2026-03-16 19:27:15.238011+00	rfysek6zitfr	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	622	jvwtitdwec6d	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-15 19:16:26.642153+00	2026-03-24 13:42:13.510527+00	lno7haudwdg6	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	829	fz5ecft5pkxx	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-22 20:52:24.310918+00	2026-03-24 22:56:49.336437+00	jwdhpgo6o7hy	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	594	rbs4dynapsak	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-14 23:30:18.338957+00	2026-03-17 01:05:30.203259+00	xayybyudcevj	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	621	sgh2vvf3r5a6	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-15 19:07:50.216156+00	2026-03-17 20:35:42.472106+00	ub6tghatpjlz	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	617	iwaklr6jobxk	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-15 16:58:22.190306+00	2026-03-18 03:55:56.759314+00	qoj45uhbw3nm	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	602	ket7uvsaq7xe	b5d23981-469b-4353-a615-9e4d6c8d8daf	t	2026-03-15 11:26:43.841699+00	2026-03-18 10:46:16.739505+00	5ugltfftr5v5	9952d18a-a0af-4cbd-98dc-15844d29d1ed
00000000-0000-0000-0000-000000000000	640	ioplp3gj7q3s	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-17 01:05:30.220613+00	2026-03-18 14:51:17.437179+00	rbs4dynapsak	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	626	nfp2zfstwblj	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-16 08:45:17.35695+00	2026-03-19 06:05:00.858405+00	67jaeqdce5b6	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	674	3x5jza3m2r2u	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-19 06:05:00.88745+00	2026-03-19 09:31:03.322889+00	nfp2zfstwblj	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1819	ibkblci4a77y	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-20 12:16:08.267597+00	2026-04-21 08:32:07.37145+00	lpizjz3lwoex	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	717	rwzsbx5bytdn	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-19 20:55:47.147538+00	2026-03-21 17:49:31.590729+00	ywkh4ieo4isw	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	652	zwnqlxnducos	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-18 11:53:21.565185+00	2026-03-21 19:58:27.740319+00	7mfaxdb3uk3t	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	753	rd72tqoelemk	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-20 22:49:51.290142+00	2026-03-21 20:13:32.123434+00	usqva6sjodnb	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	710	gqop6gw3gkcz	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-19 18:40:49.305952+00	2026-03-19 19:39:57.133842+00	vtc2doxpf3ki	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	650	qxo3r4gjqopi	b5d23981-469b-4353-a615-9e4d6c8d8daf	t	2026-03-18 10:46:16.758631+00	2026-03-19 20:21:02.831554+00	ket7uvsaq7xe	9952d18a-a0af-4cbd-98dc-15844d29d1ed
00000000-0000-0000-0000-000000000000	1846	msmilztsxzpj	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 10:31:30.422782+00	2026-04-21 11:48:23.991193+00	azf4ce357uzz	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	916	h7ss4jyvof4t	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-25 13:56:38.574711+00	2026-03-25 15:47:32.786294+00	wlsnljww7cvz	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	703	dnax2uetqbcq	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-03-19 17:38:25.253732+00	2026-03-19 21:29:01.131067+00	etwgluyxnays	081a1ba2-f2b2-4359-b2a7-eb90d1281bc4
00000000-0000-0000-0000-000000000000	1872	gysh3up6okbg	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 19:43:30.113682+00	2026-04-21 20:43:00.817722+00	3osp225myykx	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1074	4hcas6sjr57j	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-30 09:35:13.413549+00	2026-03-30 10:58:03.251441+00	xtpoblfwhczx	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	731	at3vgsxcevfq	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	t	2026-03-20 09:12:44.687952+00	2026-03-20 10:55:01.85787+00	\N	eb06df08-bb8f-4413-962c-db927135684a
00000000-0000-0000-0000-000000000000	1898	vr5xewf4bz3e	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-22 07:19:06.602418+00	2026-04-22 20:20:50.227292+00	ssxluzenpe5j	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1237	2kjbsq6wnvoy	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-04-03 14:25:33.156341+00	2026-04-04 10:53:05.138244+00	\N	7918091c-cb18-4b5d-9de8-d38a747ae765
00000000-0000-0000-0000-000000000000	664	usqva6sjodnb	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-18 19:21:08.577384+00	2026-03-20 22:49:51.284622+00	eupzxe7loo2s	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1070	cg5kytxm6dip	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-30 09:05:24.830537+00	2026-03-30 19:54:14.831544+00	7pvlj76rttqw	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	687	wrf2j4i4m5th	4f008550-7b28-4437-923b-3438f4aed317	t	2026-03-19 11:55:36.620649+00	2026-03-22 06:29:36.862338+00	\N	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1924	x26fzie53zxa	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-22 13:42:06.7095+00	2026-04-22 21:47:30.027527+00	zve536itwdrb	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1950	pba4j7g6zy66	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 21:51:58.828726+00	2026-04-22 22:51:59.997744+00	aec4wdag7sya	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	922	gvjymkkwct4n	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-25 15:47:32.800183+00	2026-03-25 18:00:30.622841+00	h7ss4jyvof4t	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	694	gb5o6joei2ax	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-03-19 15:07:00.319426+00	2026-03-21 16:20:11.320135+00	lwfghvciqwqx	88dfd653-2835-4f26-bd15-7c0eeb6241ab
00000000-0000-0000-0000-000000000000	930	zlge24rmcbsu	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-25 18:34:25.786971+00	2026-03-31 12:57:42.977768+00	b7smssjm73vn	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	657	eupzxe7loo2s	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-18 14:51:17.465639+00	2026-03-18 19:21:08.562034+00	ioplp3gj7q3s	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	940	r3oefjys7nkn	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-25 21:53:11.295627+00	2026-04-08 19:50:49.178368+00	rnma4w7jrtxs	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	815	cusflggzwo6h	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-22 15:40:52.49876+00	2026-03-22 16:53:13.743948+00	e7sejzozxz5e	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1976	lbxv2mw2dck5	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-23 20:42:58.559132+00	2026-04-24 09:11:52.831614+00	ruhwuwvf66tu	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	2009	khv6rqbff4jq	c96625ad-9941-423c-8b5a-6fdc1b54ac20	f	2026-04-24 16:24:37.457849+00	2026-04-24 16:24:37.457849+00	ibeoyj3xttik	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	2010	w4klzpwokpek	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-24 16:25:40.139426+00	2026-04-24 21:14:27.305739+00	wh4gklt3scjr	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	2038	4pnxa7jbwtqa	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-25 15:19:05.816875+00	2026-04-25 16:19:07.202702+00	if5xn7bjb7jt	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2067	gqxcuflcqs4a	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	f	2026-04-27 08:16:48.110607+00	2026-04-27 08:16:48.110607+00	nmenc4s3ow3s	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	850	i4tkbicxs7ob	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-23 11:18:47.095857+00	2026-04-27 09:22:53.182332+00	cqngixlzdrtu	8d645adf-06c6-40c0-a754-d51f12342b4e
00000000-0000-0000-0000-000000000000	794	wzs4kryh244r	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-21 21:40:02.23089+00	2026-03-23 09:46:44.128807+00	64oatokenbwq	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	840	pc335wtvgoci	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-23 08:25:47.755042+00	2026-03-23 09:50:32.461843+00	rgpgjsbdvkf6	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	854	xf24esxvuadb	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-23 11:45:28.739659+00	2026-03-25 19:42:32.36993+00	dtrbis3qrd55	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	848	pz44ktgp6atd	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-03-23 11:06:26.402335+00	2026-03-23 11:06:26.402335+00	\N	10f5facc-ee28-42cd-a394-3e24f9b750dc
00000000-0000-0000-0000-000000000000	844	4nhjud6mhkjl	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-23 09:50:32.462695+00	2026-03-23 11:16:55.650401+00	pc335wtvgoci	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	934	ztymluydo5eh	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-25 19:42:32.389097+00	2026-03-25 20:43:02.155266+00	xf24esxvuadb	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	852	vm2uzaewxmlj	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-23 11:27:55.308204+00	2026-03-23 12:35:19.055266+00	\N	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	739	uydrm6y4ekty	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-20 13:28:59.774451+00	2026-03-23 12:54:40.434174+00	7zw5hfyzn3fv	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	851	eiuk2oe2fu4j	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-23 11:23:48.650614+00	2026-03-23 18:24:09.036068+00	2ioxbcneisbi	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	775	n3nxvxgdrnbo	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-03-21 16:14:46.586841+00	2026-03-23 22:33:38.649366+00	35a5vp4espdx	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	938	ctbfavz7ms6p	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-03-25 21:44:09.173016+00	2026-03-25 22:42:34.479425+00	qqbnb3o5e4v4	88dfd653-2835-4f26-bd15-7c0eeb6241ab
00000000-0000-0000-0000-000000000000	936	sxlannkphug6	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-25 20:43:02.168131+00	2026-03-27 16:31:23.133703+00	ztymluydo5eh	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	893	shxmy4tunts4	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-24 16:58:19.919287+00	2026-03-25 10:43:36.012715+00	lvjgsyjpw4xw	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	895	qgs4yeo5nrwh	4408336b-259c-437a-9f78-c4a664506756	t	2026-03-24 17:18:17.393621+00	2026-03-30 09:13:17.287931+00	\N	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	876	doh3tosa4clw	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-23 19:56:25.53468+00	2026-03-31 12:31:12.048756+00	fuelkwuealtf	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	863	2kgrqioeu27k	8d16ce77-1836-4ce6-a462-b9d16358fb3f	t	2026-03-23 15:17:57.438858+00	2026-03-25 13:16:00.777787+00	7urmakg76wzl	a78dc683-0189-4b2b-a3c7-3ea7f965f60c
00000000-0000-0000-0000-000000000000	1820	cbjceamvutqr	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-20 12:57:39.057412+00	2026-04-20 16:11:39.727078+00	2vniwbzoocmf	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	877	xaztwt3qsb2f	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	t	2026-03-23 19:58:53.076188+00	2026-03-25 16:10:01.912724+00	wbyzshpsl4fv	70a887fe-cbf5-435c-85c9-3691006bbab8
00000000-0000-0000-0000-000000000000	882	t6ezep3cagtl	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-03-23 22:33:38.667823+00	2026-03-25 18:20:16.676335+00	n3nxvxgdrnbo	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	870	wrl4zhmh6xjq	2549f3dd-74dd-473b-be44-d5983b70e1ba	t	2026-03-23 18:14:45.807036+00	2026-04-02 15:53:15.224386+00	b6ikibiex77o	f71d0adb-1658-4567-b4b3-628ac114c07a
00000000-0000-0000-0000-000000000000	859	pu3akijxtpvz	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-23 13:36:27.736961+00	2026-03-23 16:51:32.976509+00	eono46z54dko	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	902	b7smssjm73vn	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-25 04:14:15.967353+00	2026-03-25 18:34:25.780614+00	ctyqahzpkqfm	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	874	qqbnb3o5e4v4	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-03-23 19:03:41.784383+00	2026-03-25 21:44:09.149279+00	2m2cgor4fnlp	88dfd653-2835-4f26-bd15-7c0eeb6241ab
00000000-0000-0000-0000-000000000000	880	rnma4w7jrtxs	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-03-23 21:05:45.050287+00	2026-03-25 21:53:11.2897+00	hqm4aoilse3g	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	1847	dz3ebuwudpxa	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 10:43:13.463366+00	2026-04-21 16:31:06.652894+00	icboj5lhdgrs	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	888	rwanjgqbpknr	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-24 11:26:40.715701+00	2026-03-26 11:24:23.162847+00	ohggjzjgwrln	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	900	pyrgw5f3rdgc	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-24 21:52:42.082043+00	2026-03-26 21:19:41.009491+00	44lpijfoxxg2	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	865	b6ikibiex77o	2549f3dd-74dd-473b-be44-d5983b70e1ba	t	2026-03-23 16:55:44.800063+00	2026-03-23 18:14:45.801339+00	\N	f71d0adb-1658-4567-b4b3-628ac114c07a
00000000-0000-0000-0000-000000000000	1873	5wlqfycp3xtt	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-21 20:01:28.439645+00	2026-04-21 21:01:29.251563+00	tkrxewuvos5c	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	858	6mzzv7bonon5	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-23 12:54:40.44733+00	2026-03-26 21:49:13.250761+00	uydrm6y4ekty	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	904	ovqugtzmb7vh	4f008550-7b28-4437-923b-3438f4aed317	t	2026-03-25 08:04:35.64497+00	2026-03-27 11:20:24.717273+00	crspqc27godt	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	867	rotul37c3ht4	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-23 17:20:56.100812+00	2026-03-28 11:43:14.132375+00	sjkroi6rrdwt	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	861	2m2cgor4fnlp	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-03-23 15:14:46.243719+00	2026-03-23 19:03:41.779349+00	yrz5wvmr63it	88dfd653-2835-4f26-bd15-7c0eeb6241ab
00000000-0000-0000-0000-000000000000	869	igqnk7iztct5	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-23 18:12:07.497226+00	2026-03-23 19:16:28.021458+00	m5ur5p7vz24e	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1899	b7uurbbl3thj	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 07:29:28.920384+00	2026-04-22 09:01:02.21079+00	mncrhemd7ddi	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	873	fuelkwuealtf	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-23 18:58:23.987502+00	2026-03-23 19:56:25.515354+00	f7wemkepmmwi	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	871	wbyzshpsl4fv	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	t	2026-03-23 18:23:03.501896+00	2026-03-23 19:58:53.075298+00	hey2amwwv6oj	70a887fe-cbf5-435c-85c9-3691006bbab8
00000000-0000-0000-0000-000000000000	1925	jwh63sfmi7wg	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 13:51:51.082872+00	2026-04-22 14:51:51.759873+00	lkqhkbdioool	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	857	vgl7qleteeaj	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-23 12:35:19.07199+00	2026-03-28 12:32:26.205981+00	vm2uzaewxmlj	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1951	2uvfzp64w3w5	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 22:52:00.01665+00	2026-04-23 12:00:51.511971+00	pba4j7g6zy66	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	901	wlt7u4qmfw5v	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-24 22:56:49.35223+00	2026-03-28 15:53:02.294651+00	fz5ecft5pkxx	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1977	5gmdl42m3yes	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 20:50:04.245338+00	2026-04-23 21:50:05.130859+00	bgm5pazqcoos	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	875	yah7jd4xhdgj	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-23 19:16:28.02743+00	2026-03-29 11:52:36.58552+00	igqnk7iztct5	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	2011	4kdenz4ha7xn	449ee91c-f52f-4661-abd4-ebfd556c37c3	f	2026-04-24 17:02:58.143096+00	2026-04-24 17:02:58.143096+00	26gn2owa6sdc	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	872	d43jcqchub4n	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-23 18:24:09.039333+00	2026-03-24 06:41:03.507164+00	eiuk2oe2fu4j	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	2039	caz7catqrp4b	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-25 16:19:07.218821+00	2026-04-25 17:19:08.280278+00	4pnxa7jbwtqa	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2068	yymkpfrbikpx	8c1c7bba-636d-42f2-820a-ac1131897e84	f	2026-04-27 08:20:12.611846+00	2026-04-27 08:20:12.611846+00	4foirhxnaogw	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	2069	n46654osdjtf	e804e0cf-72af-449e-9816-46518b271b84	f	2026-04-27 08:20:47.422031+00	2026-04-27 08:20:47.422031+00	5wupvk7qyqtl	7562ee6f-9b69-4bec-af3b-426c2034b24e
00000000-0000-0000-0000-000000000000	890	ktbj7erdiuhu	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-24 13:42:13.531604+00	2026-03-24 14:49:18.987297+00	jvwtitdwec6d	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	883	lvjgsyjpw4xw	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-24 06:41:03.537164+00	2026-03-24 16:58:19.901548+00	d43jcqchub4n	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	864	hfbq4gp74vpp	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-23 16:51:32.99259+00	2026-03-24 20:33:47.84196+00	pu3akijxtpvz	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	898	44lpijfoxxg2	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-24 20:33:47.849963+00	2026-03-24 21:52:42.065982+00	hfbq4gp74vpp	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	892	ctyqahzpkqfm	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-24 14:49:19.005402+00	2026-03-25 04:14:15.942408+00	ktbj7erdiuhu	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	1460	5umb2zdstxjy	be618b84-342d-454e-844d-fef4c2970891	t	2026-04-11 17:15:23.885514+00	2026-04-11 18:17:45.672994+00	2jwm65526klv	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1746	vwda46daxpci	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-19 11:22:56.141935+00	2026-04-19 12:22:56.940332+00	hzuby5dwvod4	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1456	ympkpj7r5fe7	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-11 16:44:35.431833+00	2026-04-12 08:48:16.148035+00	ys2hmtpr7bun	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	941	dgdo4azsaqai	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-03-25 22:18:21.21851+00	2026-03-30 10:52:48.977447+00	z2m67c7cgmgw	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1470	pbsv2nja4thc	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-12 08:48:16.180369+00	2026-04-12 10:42:41.530455+00	ympkpj7r5fe7	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1075	z46r73ag4xlh	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-03-30 10:52:49.007447+00	2026-03-30 19:10:06.237285+00	dgdo4azsaqai	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	906	wlsnljww7cvz	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-25 08:14:41.070241+00	2026-03-25 13:56:38.559071+00	3px3rcod75hw	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	970	hy2q6qwadtyj	4f008550-7b28-4437-923b-3438f4aed317	t	2026-03-27 11:20:24.718889+00	2026-03-31 09:57:23.337572+00	ovqugtzmb7vh	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1874	ipft4sejwekx	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-21 20:11:37.496254+00	2026-04-22 05:55:41.612418+00	qom47qfhqf6h	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1071	aemfpanpmeze	4408336b-259c-437a-9f78-c4a664506756	t	2026-03-30 09:13:17.302387+00	2026-04-01 10:33:23.391933+00	qgs4yeo5nrwh	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	1471	75wrlrkrvomy	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-12 09:45:50.096322+00	2026-04-12 10:45:58.98675+00	eu6josdqstps	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	925	aq43cirl335g	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	t	2026-03-25 16:10:01.915218+00	2026-04-02 19:29:30.781515+00	xaztwt3qsb2f	70a887fe-cbf5-435c-85c9-3691006bbab8
00000000-0000-0000-0000-000000000000	1900	dfw27mvqx6pg	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-22 08:42:15.307789+00	2026-04-22 09:41:20.023546+00	fqcaytnlldd6	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1474	lizeo4ctm3a4	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-12 10:45:58.996721+00	2026-04-12 11:45:59.975711+00	75wrlrkrvomy	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1848	5gpayo46bqpl	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-21 11:04:08.887158+00	2026-04-22 11:30:13.086404+00	q3zem4z6x3eo	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1462	ilgeuxsshhmk	be618b84-342d-454e-844d-fef4c2970891	t	2026-04-11 18:17:45.706005+00	2026-04-12 17:00:47.136772+00	5umb2zdstxjy	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1952	lgcrdqauwmc5	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-23 04:23:47.394377+00	2026-04-23 10:55:43.976959+00	363xxixic4xk	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	913	b6b44rcav4qs	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-25 10:43:36.041384+00	2026-03-25 20:49:47.253169+00	shxmy4tunts4	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1978	7advnhfyb52z	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 21:50:05.146006+00	2026-04-23 22:50:06.156908+00	5gmdl42m3yes	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1926	qgc5edwodgtw	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-04-22 14:39:37.519194+00	2026-04-24 15:58:14.664615+00	mfdgudco2fds	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	942	shiofb46sthv	31984a41-8b67-441c-abd6-2b3880940b87	f	2026-03-25 22:42:34.491835+00	2026-03-25 22:42:34.491835+00	ctbfavz7ms6p	88dfd653-2835-4f26-bd15-7c0eeb6241ab
00000000-0000-0000-0000-000000000000	1821	kgpfgsueqxmv	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	t	2026-04-20 14:34:04.74989+00	2026-04-24 21:49:08.896883+00	zoqs4fcailqt	00ef3d37-9ca9-41cd-96b6-b3752fe69e42
00000000-0000-0000-0000-000000000000	2040	52bsblzj5uca	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-25 16:46:34.676206+00	2026-04-25 17:58:15.687842+00	fu6fmm2c6ybh	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	2012	rsi5dqjuqxaa	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-04-24 17:10:49.140184+00	2026-04-27 08:02:36.609212+00	fcguqabcim77	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	2070	rjurkebs3bhl	9d852873-3b29-4018-adde-c6244679e312	f	2026-04-27 09:01:55.953288+00	2026-04-27 09:01:55.953288+00	5am4ikytin32	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	927	yb6llp7zibm5	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-25 18:00:30.643143+00	2026-03-26 09:38:42.863519+00	gvjymkkwct4n	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	954	ix2fq4uu5qm3	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-26 09:38:42.891516+00	2026-03-26 12:09:18.265665+00	yb6llp7zibm5	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	956	whpoxonvnirs	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-26 11:24:23.185996+00	2026-03-26 12:28:26.831331+00	rwanjgqbpknr	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	958	rcmyxm3kunxp	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-26 12:28:26.846722+00	2026-03-26 13:26:33.1465+00	whpoxonvnirs	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	929	lg5bctps7bxc	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-03-25 18:20:16.685578+00	2026-03-26 13:54:06.968355+00	t6ezep3cagtl	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	959	wu6cw5fntgk3	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-26 13:26:33.163997+00	2026-03-26 14:28:36.770212+00	rcmyxm3kunxp	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	957	mshxnbxpxa2o	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-26 12:09:18.281581+00	2026-03-27 10:43:28.230272+00	ix2fq4uu5qm3	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	961	lznewa55vwf5	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-26 14:28:36.782904+00	2026-03-27 11:39:10.915155+00	wu6cw5fntgk3	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	960	nnfycmp7drqi	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-03-26 13:54:06.99364+00	2026-03-27 14:36:01.161541+00	lg5bctps7bxc	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	965	b4jyevgddetd	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-26 21:49:13.27158+00	2026-03-28 10:05:22.501334+00	6mzzv7bonon5	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	964	eucgdxm2ddlt	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-26 21:19:41.01951+00	2026-03-28 13:03:49.468171+00	pyrgw5f3rdgc	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	967	4u4ude4zfnus	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-27 10:43:28.250121+00	2026-03-28 14:38:49.682746+00	mshxnbxpxa2o	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	937	6sxprbtgqa3k	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-25 20:49:47.261518+00	2026-03-29 18:34:31.932516+00	b6b44rcav4qs	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1020	odga226u7a3d	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-28 20:52:52.512553+00	2026-03-30 08:18:05.604579+00	ovhihttclmb5	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1002	2jwm65526klv	be618b84-342d-454e-844d-fef4c2970891	t	2026-03-28 13:03:49.484868+00	2026-04-11 17:15:23.879048+00	eucgdxm2ddlt	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1009	4pp5lcwyq55o	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-28 15:19:18.453648+00	2026-03-30 15:02:01.490131+00	f52g73ka5uob	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	973	y43jdrpaq235	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-27 11:39:10.925925+00	2026-03-27 12:39:11.516926+00	lznewa55vwf5	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	974	fgwumemvf3wr	00872e2b-9e9c-442f-810c-bfd62ee8a524	f	2026-03-27 12:39:11.53848+00	2026-03-27 12:39:11.53848+00	y43jdrpaq235	6a00599b-d3f6-4fba-8097-dadcbf0a8f29
00000000-0000-0000-0000-000000000000	1141	iup56z3vsy3m	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-31 19:26:29.44363+00	2026-04-03 20:38:24.762312+00	ioepvr6vijvu	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	992	zu3lcq52qtuj	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-28 09:05:46.826896+00	2026-03-30 19:15:15.463361+00	rm3dswdliozd	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1822	2lmjeacsvq54	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-20 15:11:06.36876+00	2026-04-21 14:07:36.710625+00	ap73rnpkjdcp	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	981	faxecvrb35ch	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-03-27 14:36:01.180627+00	2026-04-04 10:25:56.370642+00	nnfycmp7drqi	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	1875	jgponp6usplr	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-21 20:24:18.752099+00	2026-04-22 09:35:52.145748+00	tplu6engp27l	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	971	kzide4qdsskh	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-27 11:25:21.008504+00	2026-03-27 14:52:28.034258+00	\N	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1901	fch7cpiacl2m	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 09:01:02.230552+00	2026-04-22 11:02:13.138103+00	b7uurbbl3thj	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1849	io3nkecssj3x	e804e0cf-72af-449e-9816-46518b271b84	t	2026-04-21 11:41:40.513197+00	2026-04-22 12:35:14.559675+00	\N	da99741b-fb99-4474-9fa9-fd3e49543738
00000000-0000-0000-0000-000000000000	1927	pgpzpi5dpnz7	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 14:47:12.513368+00	2026-04-22 15:46:18.272102+00	2w25nxmulsf6	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1953	2xqlpmsh7tgm	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-23 07:19:52.502971+00	2026-04-23 08:49:05.799237+00	2rpjbz7ihfdy	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	984	s2uw463abl62	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-27 16:31:23.150491+00	2026-03-27 19:21:40.281532+00	sxlannkphug6	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	978	pflh6koqzatz	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-03-27 13:45:55.282688+00	2026-03-27 20:27:51.378777+00	\N	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1979	pyztzkyg5fle	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 22:50:06.175875+00	2026-04-23 23:50:06.90091+00	7advnhfyb52z	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2013	6sf7iurrnoz5	10920fad-ebd2-4be2-8e82-4604204f6139	t	2026-04-24 17:21:35.181657+00	2026-04-24 19:21:09.74185+00	ixitfdhekjay	e0ef1413-c2d1-4a43-8823-f5fba0f268a9
00000000-0000-0000-0000-000000000000	2041	pouqgw433bom	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-25 17:03:37.489053+00	2026-04-27 08:06:11.64916+00	5axpgr4ewqst	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	2071	jn56ppjd6a2s	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	f	2026-04-27 09:05:25.388043+00	2026-04-27 09:05:25.388043+00	tkqrbq5h33dn	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	986	rm3dswdliozd	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-27 19:21:40.305165+00	2026-03-28 09:05:46.805918+00	s2uw463abl62	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	994	f7ycictdqcgt	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-28 10:05:22.527862+00	2026-03-28 11:45:49.244262+00	b4jyevgddetd	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	997	atwjw7bjese3	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-28 11:43:14.134565+00	2026-03-28 13:48:47.096533+00	rotul37c3ht4	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	982	f52g73ka5uob	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-27 14:52:28.050041+00	2026-03-28 15:19:18.452175+00	kzide4qdsskh	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1012	n2eninqvw3ow	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-03-28 16:43:55.821298+00	2026-03-28 18:34:33.481232+00	\N	3e47eab9-3399-4435-a104-8c22ce536768
00000000-0000-0000-0000-000000000000	1015	yiroz2e2ufqw	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-03-28 18:34:33.494182+00	2026-03-28 19:48:38.267301+00	n2eninqvw3ow	3e47eab9-3399-4435-a104-8c22ce536768
00000000-0000-0000-0000-000000000000	1017	rx4dudc6xb6p	31984a41-8b67-441c-abd6-2b3880940b87	f	2026-03-28 19:48:38.27651+00	2026-03-28 19:48:38.27651+00	yiroz2e2ufqw	3e47eab9-3399-4435-a104-8c22ce536768
00000000-0000-0000-0000-000000000000	1000	ovhihttclmb5	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-28 12:32:26.229992+00	2026-03-28 20:52:52.500328+00	vgl7qleteeaj	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1001	hpzrxzrk47bm	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-28 12:48:59.889268+00	2026-03-29 10:56:29.366155+00	\N	3fd849d4-ea83-4a25-aa5f-e509ff20adf8
00000000-0000-0000-0000-000000000000	1010	tpoy5npqsjua	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-28 15:53:02.310657+00	2026-03-29 17:33:36.945288+00	wlt7u4qmfw5v	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1004	5eado337wyjb	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-28 13:48:47.113023+00	2026-03-29 18:29:37.788557+00	atwjw7bjese3	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	998	dznp5qwyajeh	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-28 11:45:49.255579+00	2026-03-29 20:28:43.51599+00	f7ycictdqcgt	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1007	g5yxagdhifc3	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-28 14:38:49.695961+00	2026-03-29 21:46:08.111553+00	4u4ude4zfnus	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	987	xzznu2vq6htl	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-03-27 20:27:51.397636+00	2026-03-30 08:12:27.594827+00	pflh6koqzatz	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1050	b3ojlnrhd5tm	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-29 20:56:18.149758+00	2026-03-30 08:17:32.272658+00	tm7updatr3io	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1823	se5zvl3jl4vm	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-20 15:39:53.968519+00	2026-04-20 16:54:22.167607+00	\N	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1052	7pvlj76rttqw	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-29 21:46:08.11373+00	2026-03-30 09:05:24.816523+00	g5yxagdhifc3	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1850	npoxzauetznz	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 11:48:24.007995+00	2026-04-21 12:50:38.426976+00	msmilztsxzpj	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1747	cfd46655sxgg	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-19 11:34:16.147255+00	2026-04-19 12:38:47.237948+00	o7nt7uovph7g	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1876	rr5wjiqnuyi2	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 20:43:00.841657+00	2026-04-21 22:36:05.201493+00	gysh3up6okbg	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1053	xtpoblfwhczx	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-29 22:23:08.250696+00	2026-03-30 09:35:13.404387+00	kobdcvnybcix	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1066	miwnvifswced	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-30 08:17:32.273485+00	2026-03-30 10:53:00.761644+00	b3ojlnrhd5tm	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1902	to6osx77idfe	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-22 09:11:25.070184+00	2026-04-22 11:32:37.028704+00	gl6i67uyihfw	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1073	ssszld2aa6ed	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	t	2026-03-30 09:30:38.487767+00	2026-04-13 09:13:51.544553+00	ph5tqwjw4hl5	57a95f55-f4e7-4e58-9a02-64c9586203b8
00000000-0000-0000-0000-000000000000	1954	prpz4qkvwwfs	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-23 08:00:25.808519+00	2026-04-23 09:28:43.903314+00	e2yujkwirrjz	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1044	jqmvipko3fja	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-29 18:34:31.933415+00	2026-03-30 11:43:51.29356+00	6sxprbtgqa3k	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1029	6bocra6wb3ry	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-29 10:56:29.399784+00	2026-03-29 11:54:54.241693+00	hpzrxzrk47bm	3fd849d4-ea83-4a25-aa5f-e509ff20adf8
00000000-0000-0000-0000-000000000000	1928	wb3xwbuewmnx	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 14:48:55.750174+00	2026-04-23 12:50:45.683612+00	35nj3abl4yn6	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1031	2pfjxptfua65	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-29 11:52:36.587783+00	2026-03-29 12:54:28.752065+00	yah7jd4xhdgj	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1063	3avmjoigbrkq	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-30 07:29:13.454794+00	2026-03-30 12:16:01.099649+00	dl3oe37corfu	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1065	a4hyyuuci6oy	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-03-30 08:12:27.609541+00	2026-03-30 14:29:19.146009+00	xzznu2vq6htl	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1033	x2p2p72jgizz	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-29 12:54:28.768693+00	2026-03-29 13:53:49.690553+00	2pfjxptfua65	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1076	puwzff2h5obf	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-30 10:53:00.763408+00	2026-03-30 15:08:00.954303+00	miwnvifswced	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1980	zrxk4k4x6p6r	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 23:50:06.922407+00	2026-04-24 09:33:26.882403+00	pyztzkyg5fle	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1054	n2em5m7sxu6r	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-29 22:28:04.286155+00	2026-03-30 16:47:53.374727+00	7c6dj223shqq	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1035	gomfvjd6f4rn	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-29 13:53:49.716037+00	2026-03-29 17:10:02.455786+00	x2p2p72jgizz	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1078	p7zsk7yx3gac	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-30 10:58:03.252911+00	2026-03-30 18:43:17.904489+00	4hcas6sjr57j	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1079	pp4kxm33qusk	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-30 10:58:38.277505+00	2026-03-31 09:14:55.502992+00	gw7l3l3tfxl7	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1032	kjsxpxzjaqrs	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-03-29 11:54:54.257414+00	2026-04-01 11:08:22.819655+00	6bocra6wb3ry	3fd849d4-ea83-4a25-aa5f-e509ff20adf8
00000000-0000-0000-0000-000000000000	2014	df24sm5hj6rd	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-24 17:24:30.856837+00	2026-04-25 06:26:28.056265+00	zndy5joa4tz5	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1037	kh7kmdlchful	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-29 17:10:02.462715+00	2026-03-29 18:12:07.407661+00	gomfvjd6f4rn	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	2042	57s2bpwkwxdw	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-25 17:19:08.29868+00	2026-04-26 09:26:33.407574+00	caz7catqrp4b	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2072	lwf53fcuglan	ff1dccb8-00bc-4042-a869-3a55773f3701	f	2026-04-27 09:22:53.209132+00	2026-04-27 09:22:53.209132+00	i4tkbicxs7ob	8d645adf-06c6-40c0-a754-d51f12342b4e
00000000-0000-0000-0000-000000000000	1038	h7s3ilgroybn	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-29 17:33:36.969112+00	2026-03-29 18:32:47.710498+00	tpoy5npqsjua	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1041	w2ke6ofw4ciz	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-29 18:12:07.412105+00	2026-03-29 19:13:42.169818+00	kh7kmdlchful	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1046	tm7updatr3io	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-29 19:13:42.182807+00	2026-03-29 20:56:18.136954+00	w2ke6ofw4ciz	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1048	kobdcvnybcix	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-29 20:28:43.535165+00	2026-03-29 22:23:08.236976+00	dznp5qwyajeh	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1043	7c6dj223shqq	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-29 18:32:47.720917+00	2026-03-29 22:28:04.28538+00	h7s3ilgroybn	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1042	dl3oe37corfu	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-29 18:29:37.797191+00	2026-03-30 07:29:13.424658+00	5eado337wyjb	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1107	yp2zz2gudfvv	4408336b-259c-437a-9f78-c4a664506756	t	2026-03-31 07:26:41.747756+00	2026-04-04 20:35:32.330206+00	\N	9a6a4ee2-41d5-48b9-8156-0df660cea663
00000000-0000-0000-0000-000000000000	1082	astodavz42gm	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-03-30 12:32:57.46218+00	2026-03-30 12:32:57.46218+00	\N	ff598b2e-0a7b-42cb-b33a-746c7efe59e1
00000000-0000-0000-0000-000000000000	1104	cnrgwp3ebwc6	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-30 22:17:06.490412+00	2026-04-06 05:48:23.267058+00	lycra2jmrcgx	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1093	qz4mlrzbglea	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-03-30 19:10:06.242806+00	2026-04-08 13:08:26.341767+00	z46r73ag4xlh	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1457	67spf2dvzood	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-11 16:47:19.453337+00	2026-04-11 19:41:55.960611+00	isdudy4uxaf7	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1824	kgnpwbjcxhcz	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-20 16:11:39.757376+00	2026-04-21 12:03:38.378078+00	cbjceamvutqr	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1851	3svfhit2zmsu	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-21 12:03:38.397441+00	2026-04-21 13:03:39.587898+00	kgnpwbjcxhcz	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1085	gmhbjur4i724	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-30 15:02:01.501717+00	2026-03-30 18:10:33.606573+00	4pp5lcwyq55o	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1877	h5ntyk3atatt	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-21 21:01:29.265319+00	2026-04-21 22:01:30.230491+00	5wlqfycp3xtt	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1080	zgumgqhq7hyv	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-30 11:43:51.313393+00	2026-03-30 18:22:12.96922+00	jqmvipko3fja	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1929	qk633cqhvav3	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 14:51:51.761518+00	2026-04-22 15:51:52.936234+00	jwh63sfmi7wg	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1081	4d66475tdkun	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-30 12:16:01.124142+00	2026-03-30 19:21:18.861991+00	3avmjoigbrkq	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1955	sr5wqzjwepid	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-23 08:25:30.920085+00	2026-04-24 07:39:32.636575+00	42wmjc3qe3xf	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1090	s45ex5iensdo	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-30 18:22:12.976817+00	2026-03-30 19:21:27.255321+00	zgumgqhq7hyv	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1981	hwjprtobw5r5	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-24 07:03:08.356845+00	2026-04-24 09:33:06.048336+00	jawfxtkny4ms	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1086	exf7svhtgq3v	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-30 15:08:00.963551+00	2026-03-30 19:51:41.203013+00	puwzff2h5obf	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1982	ze6djdgoj3gg	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-24 07:03:32.33724+00	2026-04-24 10:01:41.434425+00	uhjgzr4olc7e	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1091	cojwzhzwgy26	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-30 18:43:17.942762+00	2026-03-30 20:01:24.426941+00	p7zsk7yx3gac	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1903	w5itxhhupl2g	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-22 09:20:18.728132+00	2026-04-24 20:55:03.203115+00	ivuoejh5ugxi	9a6a4ee2-41d5-48b9-8156-0df660cea663
00000000-0000-0000-0000-000000000000	1096	7cznwe2anv2g	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-30 19:21:27.255747+00	2026-03-30 20:20:26.647843+00	s45ex5iensdo	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	2043	fqwfpptc24xi	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-25 17:58:15.705855+00	2026-04-26 07:28:05.534535+00	52bsblzj5uca	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	2015	zxskho3ua6vk	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-24 17:59:07.434093+00	2026-04-27 08:03:51.442363+00	yys7iczd2jd4	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1097	5ztjdqkfyidk	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-30 19:51:41.227999+00	2026-03-30 20:57:21.764839+00	exf7svhtgq3v	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	2073	qtituuc4z56x	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	f	2026-04-27 09:46:28.052657+00	2026-04-27 09:46:28.052657+00	6kgcsh5ittrs	a20c7498-82e9-49ac-a51e-fdb78a554ba5
00000000-0000-0000-0000-000000000000	1094	ibfmrbnh4w7h	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-30 19:15:15.476493+00	2026-03-30 21:45:09.11704+00	zu3lcq52qtuj	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1098	lycra2jmrcgx	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-03-30 19:54:14.851307+00	2026-03-30 22:17:06.468038+00	cg5kytxm6dip	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1103	6kewdkdyt7bv	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-30 21:45:09.144666+00	2026-03-30 23:11:02.831685+00	ibfmrbnh4w7h	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1089	2vheqh3f3p2t	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-30 18:10:33.633366+00	2026-03-31 08:11:49.88263+00	gmhbjur4i724	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1095	v5vm4xzvptvm	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-30 19:21:18.868985+00	2026-03-31 08:39:01.897028+00	4d66475tdkun	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1108	jrbg32rxs5zh	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-31 08:11:49.909267+00	2026-03-31 09:26:18.949778+00	2vheqh3f3p2t	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1102	3cwbcbhpvzf2	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-30 20:57:21.797192+00	2026-03-31 11:04:55.600096+00	5ztjdqkfyidk	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1113	75kip4izt6b6	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-31 09:26:18.967668+00	2026-03-31 12:27:01.372004+00	jrbg32rxs5zh	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1100	o2plksr7vkqw	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-30 20:20:26.677073+00	2026-03-31 12:44:38.742872+00	7cznwe2anv2g	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1123	hdi4wgy7mrf6	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-03-31 13:01:49.783788+00	2026-03-31 14:05:20.052947+00	\N	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1119	klb3ruoozj57	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-31 12:27:01.378773+00	2026-03-31 14:30:43.255193+00	75kip4izt6b6	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1088	nsinnguvt5ed	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-30 16:47:53.387956+00	2026-03-31 14:33:36.34874+00	n2em5m7sxu6r	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1126	ni2pof5vgs4m	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-31 14:30:43.279024+00	2026-03-31 15:40:29.922946+00	klb3ruoozj57	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1121	xqpyxnwuuamq	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-31 12:44:38.760313+00	2026-03-31 16:05:13.516093+00	o2plksr7vkqw	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1105	issm57gpr627	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-30 23:11:02.861176+00	2026-03-31 16:21:43.33558+00	6kewdkdyt7bv	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1110	ijfgtpiwpm46	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-31 08:39:01.898483+00	2026-03-31 16:25:46.601604+00	v5vm4xzvptvm	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1115	z6hraxz4mjpi	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-31 11:04:55.628283+00	2026-03-31 16:46:36.108966+00	3cwbcbhpvzf2	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1127	c4nbrhanmonx	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-31 14:33:36.350371+00	2026-03-31 17:46:54.166224+00	nsinnguvt5ed	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1129	v2gkh3b23ryz	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-31 15:40:29.941122+00	2026-03-31 18:25:40.95141+00	ni2pof5vgs4m	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1099	ochr3q22zvyr	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-30 20:01:24.440761+00	2026-03-31 19:39:12.432824+00	cojwzhzwgy26	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1112	am7fbizvbk5p	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-31 09:14:55.518871+00	2026-03-31 21:00:04.798113+00	pp4kxm33qusk	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1114	zfi6yzzye2cm	4f008550-7b28-4437-923b-3438f4aed317	t	2026-03-31 09:57:23.358619+00	2026-04-01 11:09:40.581577+00	hy2q6qwadtyj	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1120	lfnqjrdwf6qd	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-31 12:31:12.051411+00	2026-04-01 11:12:24.434563+00	doh3tosa4clw	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1125	7rs4tko6klgw	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-03-31 14:05:20.076165+00	2026-04-01 13:10:22.089838+00	hdi4wgy7mrf6	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1083	gibfrtbbgyo7	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-03-30 14:29:19.174844+00	2026-04-03 09:12:10.055245+00	a4hyyuuci6oy	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1137	obctb3jltw3u	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-31 17:46:54.184612+00	2026-04-05 14:41:55.494139+00	c4nbrhanmonx	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1163	e5mw24dbx2ut	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-01 10:20:06.947004+00	2026-04-05 20:55:45.896439+00	dpdja6hy5lj2	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1168	mrkba4kwouaa	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-01 11:12:24.439915+00	2026-04-06 17:10:11.512273+00	lfnqjrdwf6qd	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1825	efzxp7mhtl2o	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-20 16:54:22.182594+00	2026-04-20 18:32:18.455403+00	se5zvl3jl4vm	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1132	alepshvkc3iu	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-31 16:21:43.337388+00	2026-03-31 17:22:57.497537+00	issm57gpr627	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1151	hoy4uv3yipky	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-31 23:45:22.834983+00	2026-04-10 23:14:25.00975+00	o5sspjblfblc	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1852	7maw3qwiywzs	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 12:50:38.444179+00	2026-04-21 14:15:12.884848+00	npoxzauetznz	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1878	sf3svkzw45pm	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-21 21:26:36.250285+00	2026-04-22 04:51:15.076357+00	35at5rlhsdkw	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1751	r6xne4uzp3ae	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-19 12:38:47.263079+00	2026-04-22 06:46:52.183918+00	cfd46655sxgg	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1135	y6gkwi5nndae	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-31 17:22:57.522999+00	2026-03-31 18:52:36.400343+00	alepshvkc3iu	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1133	ioepvr6vijvu	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-03-31 16:25:46.612892+00	2026-03-31 19:26:29.413125+00	ijfgtpiwpm46	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1904	eyoxqdewp453	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-22 09:35:52.161+00	2026-04-22 12:18:25.229364+00	jgponp6usplr	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1930	wpxzanyvx63f	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 15:46:18.2849+00	2026-04-22 20:40:13.374294+00	pgpzpi5dpnz7	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1956	ib5je5eaquac	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-23 08:49:05.823499+00	2026-04-23 09:52:10.807725+00	2xqlpmsh7tgm	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1140	7wefw2my5cjm	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-31 18:52:36.417642+00	2026-03-31 19:53:37.671611+00	y6gkwi5nndae	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1983	tjrl4ezcemqj	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-24 07:39:32.658585+00	2026-04-24 11:51:27.995588+00	sr5wqzjwepid	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	2016	5bzkm4e2sbtp	e804e0cf-72af-449e-9816-46518b271b84	t	2026-04-24 18:18:16.998865+00	2026-04-24 20:08:37.034757+00	\N	7562ee6f-9b69-4bec-af3b-426c2034b24e
00000000-0000-0000-0000-000000000000	2044	p4gfmfxxvnbe	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-26 07:28:05.566988+00	2026-04-26 15:00:33.693552+00	fqwfpptc24xi	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1147	nkn4lwzpmdvq	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-31 21:00:04.809422+00	2026-03-31 22:31:34.773195+00	am7fbizvbk5p	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1144	o5sspjblfblc	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-03-31 19:39:12.436364+00	2026-03-31 23:45:22.814279+00	ochr3q22zvyr	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1134	22btl6zjiuy7	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-03-31 16:46:36.122697+00	2026-04-01 06:24:13.103815+00	z6hraxz4mjpi	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1138	hxhkbfkkpyus	ff1dccb8-00bc-4042-a869-3a55773f3701	t	2026-03-31 18:25:40.978132+00	2026-04-01 07:26:18.805415+00	v2gkh3b23ryz	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1160	6udf53olplmj	ff1dccb8-00bc-4042-a869-3a55773f3701	f	2026-04-01 07:26:18.826958+00	2026-04-01 07:26:18.826958+00	hxhkbfkkpyus	016e7651-84f8-4f4e-8675-2ad1e5ce0531
00000000-0000-0000-0000-000000000000	1130	dpdja6hy5lj2	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-03-31 16:05:13.530187+00	2026-04-01 10:20:06.929282+00	xqpyxnwuuamq	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1145	iuxmg4bjmj66	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-03-31 19:53:37.677929+00	2026-04-01 11:17:31.067493+00	7wefw2my5cjm	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1158	hxq7qoy6bmm2	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-01 06:24:13.121722+00	2026-04-01 12:32:58.092089+00	22btl6zjiuy7	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1172	nc65l7dydvmf	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-01 11:44:20.646626+00	2026-04-01 13:46:28.006978+00	\N	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1166	twuqk44y3eal	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-04-01 11:08:22.83112+00	2026-04-01 13:58:05.500501+00	kjsxpxzjaqrs	3fd849d4-ea83-4a25-aa5f-e509ff20adf8
00000000-0000-0000-0000-000000000000	1169	4u4qtbpcypxm	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-01 11:17:31.074919+00	2026-04-01 15:04:14.12714+00	iuxmg4bjmj66	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1177	tbldfbtrzzhv	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-01 13:46:28.022972+00	2026-04-01 15:25:48.307135+00	nc65l7dydvmf	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1173	aq2afrgucvzg	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-01 12:32:58.122136+00	2026-04-01 15:36:00.886595+00	hxq7qoy6bmm2	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1149	5hibhalwzeok	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-03-31 22:31:34.780544+00	2026-04-01 22:56:36.69731+00	nkn4lwzpmdvq	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1167	iuboiibgvy5q	4f008550-7b28-4437-923b-3438f4aed317	t	2026-04-01 11:09:40.584309+00	2026-04-02 07:44:47.207955+00	zfi6yzzye2cm	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1164	bfbo2uwonurk	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-01 10:33:23.41985+00	2026-04-02 08:35:17.089717+00	aemfpanpmeze	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	1178	v5yohsfxv6by	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-04-01 13:58:05.507139+00	2026-04-02 10:35:17.753244+00	twuqk44y3eal	3fd849d4-ea83-4a25-aa5f-e509ff20adf8
00000000-0000-0000-0000-000000000000	1175	2wh6r7vlzkpf	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-01 13:10:22.106819+00	2026-04-03 08:53:44.900943+00	7rs4tko6klgw	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1464	agosb6mc6hre	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-11 19:41:55.988378+00	2026-04-11 20:41:56.581325+00	67spf2dvzood	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1853	hevfwhb3tggd	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-21 13:03:39.601081+00	2026-04-21 15:41:32.776443+00	3svfhit2zmsu	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1182	niqhdqh7mdci	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-01 15:25:48.324373+00	2026-04-01 16:52:56.272411+00	tbldfbtrzzhv	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1826	tplu6engp27l	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-20 17:02:10.405523+00	2026-04-21 20:24:18.741785+00	isjbvfogkh4h	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1181	hmpxtvzt2ywd	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-01 15:04:14.152865+00	2026-04-01 16:58:34.892996+00	4u4qtbpcypxm	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1229	iufmpliuk7wt	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-03 09:41:18.537381+00	2026-04-03 14:00:21.826097+00	pbsax7tj35ee	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1184	dngmc47362yi	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-01 16:52:56.290096+00	2026-04-01 18:33:46.472227+00	niqhdqh7mdci	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1183	kpig3scu6uor	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-01 15:36:00.905939+00	2026-04-03 19:43:00.353398+00	aq2afrgucvzg	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1185	rszfpnwycwqn	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-01 16:58:34.899498+00	2026-04-01 19:08:22.938387+00	hmpxtvzt2ywd	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1465	tg55eoyevpjy	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-11 20:41:56.601093+00	2026-04-11 21:41:57.623857+00	agosb6mc6hre	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1228	oioyj5gadc4c	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-03 09:12:10.066567+00	2026-04-03 21:07:04.296158+00	gibfrtbbgyo7	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1186	dq4j6f65qxk3	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-01 18:33:46.500495+00	2026-04-01 21:27:08.630878+00	dngmc47362yi	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1201	th536mzebykz	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-02 11:23:51.230851+00	2026-04-03 21:24:15.719627+00	yf5hiv2cg75a	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1224	iaxn5ntjblmr	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-02 22:54:06.425375+00	2026-04-03 22:51:10.192399+00	vr7zc6q2ws2w	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1189	gdnxlkouaktz	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-01 21:27:08.659981+00	2026-04-01 23:12:29.263773+00	dq4j6f65qxk3	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1227	bx4tanhtjexf	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-03 08:53:44.903485+00	2026-04-04 18:32:17.283735+00	2wh6r7vlzkpf	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1195	eauur2qurmhp	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-02 08:35:17.102604+00	2026-04-04 19:23:36.603818+00	bfbo2uwonurk	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	1187	wqu4udqxjg3x	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-01 19:08:22.954756+00	2026-04-06 11:23:41.649531+00	rszfpnwycwqn	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1198	tmlsgefs36uy	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-04-02 10:35:17.764611+00	2026-04-09 08:45:23.397966+00	v5yohsfxv6by	3fd849d4-ea83-4a25-aa5f-e509ff20adf8
00000000-0000-0000-0000-000000000000	1221	sz57qrdthwot	4f008550-7b28-4437-923b-3438f4aed317	t	2026-04-02 21:02:52.824181+00	2026-04-12 07:16:21.570749+00	zewtp4udolt5	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1879	ucr6dfqjktyl	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-21 22:01:30.249784+00	2026-04-21 23:01:31.186943+00	h5ntyk3atatt	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1216	l3uk4vwx6qap	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	t	2026-04-02 19:29:30.788696+00	2026-04-16 15:09:16.146686+00	aq43cirl335g	70a887fe-cbf5-435c-85c9-3691006bbab8
00000000-0000-0000-0000-000000000000	1190	pmyvbaacrg5a	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-01 22:56:36.719715+00	2026-04-02 10:24:35.491024+00	5hibhalwzeok	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1905	yvaqtv3kwptb	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-22 09:41:20.03104+00	2026-04-22 11:23:52.110287+00	dfw27mvqx6pg	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1931	47xnbuwjokpv	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 15:51:52.961431+00	2026-04-22 16:51:54.175108+00	qk633cqhvav3	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1197	yf5hiv2cg75a	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-02 10:24:35.518548+00	2026-04-02 11:23:51.201414+00	pmyvbaacrg5a	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1957	gziotcn3p6bs	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-23 09:28:43.92258+00	2026-04-23 15:07:16.853309+00	prpz4qkvwwfs	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1194	yf4lad6ds2o7	4f008550-7b28-4437-923b-3438f4aed317	t	2026-04-02 07:44:47.231603+00	2026-04-02 11:33:50.461981+00	iuboiibgvy5q	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1984	xukihlfq47oj	943a493d-044c-4c88-babc-e64804553bb4	f	2026-04-24 08:05:16.578133+00	2026-04-24 08:05:16.578133+00	\N	52af80ca-d377-4926-a0e9-0e8afbd62198
00000000-0000-0000-0000-000000000000	2017	5axpgr4ewqst	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-24 18:44:45.611725+00	2026-04-25 17:03:37.462736+00	gs4jcvimqqnv	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	2045	xbt23fmxfk2y	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-26 09:26:33.427009+00	2026-04-26 10:26:34.711978+00	57s2bpwkwxdw	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1203	kfpxalxvp7sp	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-02 11:35:39.123453+00	2026-04-02 15:53:14.90083+00	\N	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1209	mjas5oai5rlk	2549f3dd-74dd-473b-be44-d5983b70e1ba	t	2026-04-02 15:53:15.228611+00	2026-04-02 16:52:10.774416+00	wrl4zhmh6xjq	f71d0adb-1658-4567-b4b3-628ac114c07a
00000000-0000-0000-0000-000000000000	1208	77w3i3mzsogz	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-02 15:53:14.921252+00	2026-04-02 16:54:37.15531+00	kfpxalxvp7sp	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1211	xpp4wm5g2nin	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-02 16:54:37.177591+00	2026-04-02 17:54:38.82105+00	77w3i3mzsogz	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1212	z6gjl4mv64yc	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-02 17:54:38.845384+00	2026-04-02 18:54:40.385681+00	xpp4wm5g2nin	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1210	qou4j2wcpmfi	2549f3dd-74dd-473b-be44-d5983b70e1ba	t	2026-04-02 16:52:10.794956+00	2026-04-02 19:27:13.881927+00	mjas5oai5rlk	f71d0adb-1658-4567-b4b3-628ac114c07a
00000000-0000-0000-0000-000000000000	1215	ggtbnmjjcomm	2549f3dd-74dd-473b-be44-d5983b70e1ba	f	2026-04-02 19:27:13.896166+00	2026-04-02 19:27:13.896166+00	qou4j2wcpmfi	f71d0adb-1658-4567-b4b3-628ac114c07a
00000000-0000-0000-0000-000000000000	1214	2bzl3kx37thu	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-02 18:54:40.407887+00	2026-04-02 19:54:40.990537+00	z6gjl4mv64yc	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1217	nnbzp2ofrait	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-02 19:54:41.005858+00	2026-04-02 20:55:32.7894+00	2bzl3kx37thu	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1202	zewtp4udolt5	4f008550-7b28-4437-923b-3438f4aed317	t	2026-04-02 11:33:50.47602+00	2026-04-02 21:02:52.810137+00	yf4lad6ds2o7	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1219	4dz2q7m6o3tr	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-02 20:55:32.799501+00	2026-04-02 21:55:33.915567+00	nnbzp2ofrait	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1222	vr7zc6q2ws2w	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-02 21:55:33.930571+00	2026-04-02 22:54:06.412464+00	4dz2q7m6o3tr	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1191	pbsax7tj35ee	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-01 23:12:29.283194+00	2026-04-03 09:41:18.511226+00	gdnxlkouaktz	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1827	ang2xttxo7nm	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-20 17:37:03.677217+00	2026-04-20 18:36:44.627487+00	7ilvwup4xlhw	9a6a4ee2-41d5-48b9-8156-0df660cea663
00000000-0000-0000-0000-000000000000	1472	ahg5z6kzz4g5	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-04-12 10:40:24.81616+00	2026-04-15 20:45:08.39451+00	3quzbe3xv732	3fd849d4-ea83-4a25-aa5f-e509ff20adf8
00000000-0000-0000-0000-000000000000	1288	ewq3exdomsud	b5d23981-469b-4353-a615-9e4d6c8d8daf	t	2026-04-05 21:06:13.822451+00	2026-04-16 17:04:34.201332+00	\N	bd2ae24d-c3c7-4ac8-b7e5-3295e75a76f9
00000000-0000-0000-0000-000000000000	1261	sj64dmy3ml5p	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-04-04 11:27:18.391148+00	2026-04-18 16:42:20.955181+00	eiebjezcyrdz	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	1880	ii4fa5isnwo4	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 22:16:09.452877+00	2026-04-22 10:09:36.699852+00	fhinv3iavnbj	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1906	wgthw3jxxa7e	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 09:51:47.393079+00	2026-04-22 10:51:48.51067+00	vwumm4cxfqz5	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1932	52ammnmugsva	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-22 15:54:30.331057+00	2026-04-22 16:52:32.354131+00	tlfz4kkcvhoo	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1854	afoo53m2fe2g	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-21 14:07:36.730214+00	2026-04-22 19:50:06.669014+00	2lmjeacsvq54	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1122	eiebjezcyrdz	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-03-31 12:57:43.000819+00	2026-04-04 11:27:18.374132+00	zlge24rmcbsu	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	1258	vu47xzvkxpdu	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-04-04 10:25:56.39849+00	2026-04-04 11:55:53.428399+00	faxecvrb35ch	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	1958	josgetlc2rhm	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-23 09:52:10.83686+00	2026-04-23 12:20:32.638213+00	ib5je5eaquac	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1985	wlyiffay7dkh	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-24 09:11:52.855089+00	2026-04-24 13:03:53.533039+00	lbxv2mw2dck5	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1959	5jlslytcdr3x	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-23 09:54:29.970624+00	2026-04-24 16:06:58.169804+00	7iv2lk6ss2ka	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	2018	5udfextowusj	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-24 19:19:09.934962+00	2026-04-24 21:23:50.860576+00	vdknhigpymjq	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	2046	ivykwhzufwfd	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-26 10:26:34.733844+00	2026-04-26 11:26:35.707743+00	xbt23fmxfk2y	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1270	la244jiczjku	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-04 19:23:36.62563+00	2026-04-04 20:35:11.740978+00	eauur2qurmhp	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	1267	7m2kxeecv2bo	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-04 18:11:24.170728+00	2026-04-04 21:02:40.487332+00	slpksd7mtcsi	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1266	coo535j3i46s	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-04 16:48:09.457543+00	2026-04-04 21:06:02.123811+00	hjlsivdk4os3	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1274	gqimlwxjledz	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-04 21:06:02.137436+00	2026-04-04 22:06:02.954017+00	coo535j3i46s	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1275	62cnad2rvshk	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-04 22:06:02.971541+00	2026-04-04 23:06:03.902405+00	gqimlwxjledz	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1276	ra5uf4u7vjww	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-04 23:06:03.919052+00	2026-04-05 00:06:04.827281+00	62cnad2rvshk	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1259	l3dpajvjsegn	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-04-04 10:53:05.160234+00	2026-04-05 09:02:54.997446+00	2kjbsq6wnvoy	7918091c-cb18-4b5d-9de8-d38a747ae765
00000000-0000-0000-0000-000000000000	1278	zx3t7x4ghp6f	31984a41-8b67-441c-abd6-2b3880940b87	f	2026-04-05 09:02:55.028776+00	2026-04-05 09:02:55.028776+00	l3dpajvjsegn	7918091c-cb18-4b5d-9de8-d38a747ae765
00000000-0000-0000-0000-000000000000	1277	lvrzg3tzju5a	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-05 00:06:04.839512+00	2026-04-05 09:49:02.702269+00	ra5uf4u7vjww	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1279	vreogeynv3wl	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-05 09:49:02.724262+00	2026-04-05 15:22:36.183055+00	lvrzg3tzju5a	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1265	p4wzikm747fp	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-04 14:17:08.981965+00	2026-04-05 17:15:11.500963+00	kz2xzrzlpaje	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1272	zo6sm7gna7m5	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-04 20:35:32.333068+00	2026-04-05 20:11:48.815652+00	yp2zz2gudfvv	9a6a4ee2-41d5-48b9-8156-0df660cea663
00000000-0000-0000-0000-000000000000	1273	pqs5vfu4ohmv	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-04 21:02:40.496646+00	2026-04-05 20:19:26.05591+00	7m2kxeecv2bo	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1282	dknv5ls27de4	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-05 15:22:36.214115+00	2026-04-05 22:12:10.765443+00	vreogeynv3wl	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1285	mymbiappodha	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-05 20:19:26.063804+00	2026-04-06 08:20:13.788135+00	pqs5vfu4ohmv	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1283	cftcdqlvi2bf	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-05 17:15:11.532156+00	2026-04-06 08:40:02.170828+00	p4wzikm747fp	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1252	5x5tbdez6g7h	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-03 22:58:16.222777+00	2026-04-06 10:02:09.942517+00	4foljkutuesm	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1298	axrvbztsofxk	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-06 10:12:29.390517+00	2026-04-06 12:36:42.443848+00	5ghz3pgllswp	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1268	kqpx4ss4yzoh	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-04 18:32:17.298264+00	2026-04-06 15:18:10.297405+00	bx4tanhtjexf	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1300	3ktrgltafoio	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-06 12:36:42.462283+00	2026-04-06 15:38:47.468812+00	axrvbztsofxk	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1290	apb6vxxp6j7v	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-05 22:12:10.780024+00	2026-04-06 16:19:29.999149+00	dknv5ls27de4	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1299	a4u4vtmji4bm	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-06 11:23:41.676409+00	2026-04-06 16:52:53.865599+00	wqu4udqxjg3x	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1294	edl4rxkwrhik	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-06 08:40:02.182923+00	2026-04-06 18:58:39.433742+00	cftcdqlvi2bf	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1296	xkrcowgp2dmi	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-06 10:02:09.952042+00	2026-04-07 05:47:21.609242+00	5x5tbdez6g7h	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1287	ztjx2p3xpzx7	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-05 20:55:45.921395+00	2026-04-07 23:05:17.793024+00	e5mw24dbx2ut	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1263	p4arv42mp4ll	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-04-04 11:55:53.457538+00	2026-04-08 08:04:35.061969+00	vu47xzvkxpdu	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	1292	zsvkxz63nf4m	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-06 08:20:13.809559+00	2026-04-08 08:32:59.505289+00	mymbiappodha	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1291	wtpqfeknipka	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-06 05:48:23.301255+00	2026-04-08 08:50:07.815779+00	cnrgwp3ebwc6	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1271	yiqu6ppsondb	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-04 20:35:11.761067+00	2026-04-08 10:02:51.532788+00	la244jiczjku	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	1281	vkv4sro6j6sc	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-05 14:41:55.51417+00	2026-04-08 13:52:57.988057+00	obctb3jltw3u	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1297	yb7omg3mi5hs	f1932726-f713-4b61-8650-bf04f45d5b09	t	2026-04-06 10:07:38.448896+00	2026-04-08 17:33:05.091816+00	\N	aac4e3e2-5a85-4f33-bb6e-c56a7cae0649
00000000-0000-0000-0000-000000000000	1262	lnt5vnmssa6o	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-04 11:27:39.108971+00	2026-04-08 18:01:53.329065+00	ihrdixk2uw5g	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1347	wnwtpdniawl4	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-08 07:20:51.368754+00	2026-04-11 17:08:36.670284+00	qh2a5zxrg224	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1337	lx5ouywjw3mu	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-07 15:48:54.323194+00	2026-04-12 17:37:08.304075+00	6unsja2gjele	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1828	36vfqkqlo4qm	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-20 18:26:38.530876+00	2026-04-20 20:52:23.91358+00	7kicskybxdnq	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1303	vbhvukq5gx4x	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-06 15:38:47.490353+00	2026-04-06 16:37:20.503745+00	3ktrgltafoio	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1855	vptkiuajnqmt	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 14:15:12.907254+00	2026-04-21 15:49:15.066488+00	7maw3qwiywzs	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1881	uocvkmc7zvt2	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-21 22:24:24.349055+00	2026-04-21 23:25:26.285636+00	6a4uxeyeqter	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1304	7yxicxptknzx	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-06 16:19:30.020541+00	2026-04-06 17:19:30.472578+00	apb6vxxp6j7v	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1907	y65nax3vyhv4	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 10:09:36.708386+00	2026-04-22 11:25:22.466231+00	ii4fa5isnwo4	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1305	oht7zcrx7o6b	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-06 16:37:20.514627+00	2026-04-06 17:42:48.386205+00	vbhvukq5gx4x	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1309	xx4z72vnlrtt	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-06 17:19:30.478313+00	2026-04-06 18:19:31.58593+00	7yxicxptknzx	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1933	dj5btnpy7zjo	10920fad-ebd2-4be2-8e82-4604204f6139	t	2026-04-22 16:38:26.413797+00	2026-04-22 17:58:40.695926+00	xj7pkb4unetx	e0ef1413-c2d1-4a43-8823-f5fba0f268a9
00000000-0000-0000-0000-000000000000	1311	gbdvlsxtcj6w	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-06 18:19:31.601077+00	2026-04-06 19:19:32.431588+00	xx4z72vnlrtt	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1310	6jgekfprrhfm	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-06 17:42:48.406495+00	2026-04-06 19:20:36.337592+00	oht7zcrx7o6b	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1986	rjmhswno7w3r	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-24 09:33:06.067444+00	2026-04-24 15:17:36.375124+00	hwjprtobw5r5	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1960	5ys2hrq5w3ru	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-23 10:55:44.005601+00	2026-04-24 16:01:40.779272+00	lgcrdqauwmc5	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	2019	ejn6gndsvngf	10920fad-ebd2-4be2-8e82-4604204f6139	f	2026-04-24 19:21:09.745075+00	2026-04-24 19:21:09.745075+00	6sf7iurrnoz5	e0ef1413-c2d1-4a43-8823-f5fba0f268a9
00000000-0000-0000-0000-000000000000	2020	gcbowqp7vdse	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	f	2026-04-24 19:21:38.56076+00	2026-04-24 19:21:38.56076+00	2ffnswc27gae	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	1987	if5xn7bjb7jt	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-24 09:33:26.885353+00	2026-04-25 15:19:05.795676+00	zrxk4k4x6p6r	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1314	hrvb4hi6ymbv	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-06 19:19:32.458573+00	2026-04-06 20:19:34.11123+00	gbdvlsxtcj6w	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2047	gjsfptwsf7ub	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-26 11:26:35.724775+00	2026-04-26 12:26:36.64561+00	ivykwhzufwfd	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1302	n3hi4pvguset	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-06 15:18:10.325858+00	2026-04-06 20:50:03.12267+00	kqpx4ss4yzoh	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1318	anccydcmdo43	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-06 20:19:34.126979+00	2026-04-06 21:19:34.934103+00	hrvb4hi6ymbv	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1313	lgzbudfq3qd5	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-06 18:58:39.451572+00	2026-04-07 04:49:07.553587+00	edl4rxkwrhik	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1315	r2qkghvr3cwz	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-06 19:20:36.364642+00	2026-04-07 06:03:41.040873+00	6jgekfprrhfm	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1322	7qrioesnky3f	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-07 04:49:07.585788+00	2026-04-07 08:51:20.163003+00	lgzbudfq3qd5	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1320	s3wjjs3eenlo	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-06 20:50:03.132576+00	2026-04-07 09:30:32.266178+00	n3hi4pvguset	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1323	jmrguhzq4i3v	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-07 05:47:21.620834+00	2026-04-07 11:01:54.914543+00	xkrcowgp2dmi	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1329	7cpfn3rbvwf4	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-07 11:01:54.938979+00	2026-04-07 12:14:51.883414+00	jmrguhzq4i3v	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1324	ntkmf72ji7gb	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-07 06:03:41.07658+00	2026-04-07 13:03:44.791633+00	r2qkghvr3cwz	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1307	6unsja2gjele	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-06 17:10:11.524829+00	2026-04-07 15:48:54.322552+00	mrkba4kwouaa	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1327	wypjwo4lep5o	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-07 08:51:20.183606+00	2026-04-07 17:14:00.428261+00	7qrioesnky3f	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1332	ah7ms7wpoysp	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-07 13:03:44.816584+00	2026-04-07 20:57:52.796421+00	ntkmf72ji7gb	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1321	qmfmde3fzdy3	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-06 21:19:34.954869+00	2026-04-07 21:04:02.651907+00	anccydcmdo43	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1341	s7qg4bt5krpf	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-07 20:57:52.820161+00	2026-04-07 22:00:54.342608+00	ah7ms7wpoysp	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1344	onkumtpoptnl	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-07 23:05:17.823391+00	2026-04-08 00:52:48.49782+00	ztjx2p3xpzx7	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1345	qja6v6mvulnf	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-08 00:52:48.519634+00	2026-04-08 05:38:08.783843+00	onkumtpoptnl	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1346	qh2a5zxrg224	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-08 05:38:08.816145+00	2026-04-08 07:20:51.348775+00	qja6v6mvulnf	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1331	dpzpbjpknsh6	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-07 12:14:51.902707+00	2026-04-08 07:51:48.883882+00	7cpfn3rbvwf4	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1338	ohwod2wzptxf	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-07 17:14:00.463954+00	2026-04-08 08:03:52.183589+00	wypjwo4lep5o	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1306	4zrhlzmwzzgh	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-06 16:52:53.893674+00	2026-04-08 08:28:46.261956+00	a4u4vtmji4bm	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1348	bvzjsafkwcbf	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-08 07:51:48.906094+00	2026-04-08 10:55:56.520599+00	dpzpbjpknsh6	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1342	xu4im6ndehom	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-07 21:04:02.664895+00	2026-04-08 17:06:14.927354+00	qmfmde3fzdy3	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1328	syqhcoh5dtlj	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-07 09:30:32.287182+00	2026-04-08 18:53:19.792532+00	s3wjjs3eenlo	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1343	jzgdp3lwyhth	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-07 22:00:54.364691+00	2026-04-09 08:45:49.509404+00	s7qg4bt5krpf	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1350	t7k23ijkkvni	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-08 08:03:52.211762+00	2026-04-09 11:29:46.96557+00	ohwod2wzptxf	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1385	y4ib2jssta6e	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-04-08 20:33:50.103018+00	2026-04-11 16:29:10.946522+00	24chjrcf22iq	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1392	3quzbe3xv732	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-04-09 08:45:23.421749+00	2026-04-12 10:40:24.79563+00	tmlsgefs36uy	3fd849d4-ea83-4a25-aa5f-e509ff20adf8
00000000-0000-0000-0000-000000000000	1400	r6b6vumgqx72	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-09 11:19:22.534731+00	2026-04-13 09:02:39.800399+00	gp4lz3lfrmec	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1362	kzesivd323m4	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-08 11:31:47.4829+00	2026-04-16 15:37:18.048907+00	eixafpqmpmow	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	1359	unwad5voib3i	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-04-08 10:11:17.061478+00	2026-04-17 09:24:24.604574+00	wqns3s2hiba4	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	1829	lje34ejtv6yz	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-20 18:32:18.464118+00	2026-04-20 19:34:11.173783+00	efzxp7mhtl2o	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1351	wqns3s2hiba4	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-04-08 08:04:35.064586+00	2026-04-08 10:11:17.057597+00	p4arv42mp4ll	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	1856	zcyfjp4hd6tz	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-21 15:41:32.802147+00	2026-04-21 16:41:33.625491+00	hevfwhb3tggd	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1882	2ydg2vbmqpqu	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 22:36:05.223977+00	2026-04-21 23:59:59.27325+00	rr5wjiqnuyi2	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1358	eixafpqmpmow	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-08 10:02:51.555815+00	2026-04-08 11:31:47.456635+00	yiqu6ppsondb	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	1908	cjtlhnvk6lzu	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 10:51:48.536909+00	2026-04-22 11:51:49.500754+00	wgthw3jxxa7e	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1352	4i7h7mkltfsl	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-08 08:28:46.281375+00	2026-04-08 12:24:37.763544+00	4zrhlzmwzzgh	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1935	h5iz4hyeu72r	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-22 16:52:32.354584+00	2026-04-22 17:50:33.336449+00	52ammnmugsva	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1934	zt6tesmour5r	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 16:51:54.191885+00	2026-04-22 17:51:54.618029+00	47xnbuwjokpv	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1357	zlt44dfme7h2	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-04-08 09:30:04.775765+00	2026-04-08 13:04:15.121464+00	\N	b2442d92-4f90-4a83-b448-a3d333644716
00000000-0000-0000-0000-000000000000	1961	2zlb4vgo3uz6	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 12:00:51.539776+00	2026-04-23 13:00:52.434148+00	2uvfzp64w3w5	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1364	3ilb7finnyju	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-08 12:24:37.765973+00	2026-04-08 13:25:35.270457+00	4i7h7mkltfsl	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1988	4umhx2cyi74u	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-24 10:01:41.442715+00	2026-04-24 15:39:22.585207+00	ze6djdgoj3gg	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	2021	sqqtcdalc64y	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-24 19:51:58.918028+00	2026-04-24 21:15:03.491897+00	ssqntv7qrgkh	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	2048	r2vl2ntle4tm	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-26 12:26:36.65496+00	2026-04-26 13:26:37.612153+00	gjsfptwsf7ub	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1367	agtfqpiuievf	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-04-08 13:08:26.351034+00	2026-04-08 14:31:33.012794+00	qz4mlrzbglea	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1366	qzqtw2mxf4es	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-04-08 13:04:15.141882+00	2026-04-08 15:44:11.182182+00	zlt44dfme7h2	b2442d92-4f90-4a83-b448-a3d333644716
00000000-0000-0000-0000-000000000000	1373	s4ts46fm5ibk	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-04-08 15:44:11.20653+00	2026-04-08 16:46:43.151425+00	qzqtw2mxf4es	b2442d92-4f90-4a83-b448-a3d333644716
00000000-0000-0000-0000-000000000000	1375	vamhtsv43jn6	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-08 17:06:14.945288+00	2026-04-08 18:04:47.38569+00	xu4im6ndehom	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1378	ria25zlafhua	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-08 18:04:47.396622+00	2026-04-08 19:04:48.134766+00	vamhtsv43jn6	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1376	xb5hoogtt46t	f1932726-f713-4b61-8650-bf04f45d5b09	t	2026-04-08 17:33:05.109685+00	2026-04-08 19:24:42.883601+00	yb7omg3mi5hs	aac4e3e2-5a85-4f33-bb6e-c56a7cae0649
00000000-0000-0000-0000-000000000000	1381	b6tf7ya7lpnx	f1932726-f713-4b61-8650-bf04f45d5b09	f	2026-04-08 19:24:42.89642+00	2026-04-08 19:24:42.89642+00	xb5hoogtt46t	aac4e3e2-5a85-4f33-bb6e-c56a7cae0649
00000000-0000-0000-0000-000000000000	1377	iivpqb4ayixk	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-08 18:01:53.359041+00	2026-04-08 19:33:26.58764+00	lnt5vnmssa6o	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1380	6lwp743ntvnj	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-08 19:04:48.144842+00	2026-04-08 20:04:49.02864+00	ria25zlafhua	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1372	24chjrcf22iq	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-04-08 14:31:33.029197+00	2026-04-08 20:33:50.083702+00	agtfqpiuievf	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1374	i2pspjle7qtp	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-04-08 16:46:43.168667+00	2026-04-08 20:34:05.983056+00	s4ts46fm5ibk	b2442d92-4f90-4a83-b448-a3d333644716
00000000-0000-0000-0000-000000000000	1384	gaachzfzwqac	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-08 20:04:49.051531+00	2026-04-08 21:04:50.01104+00	6lwp743ntvnj	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1387	zc4m5u6t3hpd	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-08 21:04:50.026057+00	2026-04-08 22:05:37.910543+00	gaachzfzwqac	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1386	nm3u7vjucr3d	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-04-08 20:34:05.985495+00	2026-04-09 07:50:44.70339+00	i2pspjle7qtp	b2442d92-4f90-4a83-b448-a3d333644716
00000000-0000-0000-0000-000000000000	1368	vbt27kllib47	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-08 13:25:35.297689+00	2026-04-09 10:03:06.746767+00	3ilb7finnyju	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1393	gycadmggrph3	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-09 08:45:49.511145+00	2026-04-09 10:03:06.825416+00	jzgdp3lwyhth	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1353	wottktcbvbwc	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-08 08:32:59.507399+00	2026-04-09 10:56:39.655526+00	zsvkxz63nf4m	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1397	gp4lz3lfrmec	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-09 10:03:06.827727+00	2026-04-09 11:19:22.50994+00	gycadmggrph3	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1383	ibea6znu3hzn	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-04-08 19:50:49.192956+00	2026-04-09 13:02:38.454513+00	r3oefjys7nkn	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	1389	cmifrchp7r7b	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-08 22:05:37.923492+00	2026-04-09 13:43:48.794056+00	zc4m5u6t3hpd	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1391	23ddudf3nk5q	31984a41-8b67-441c-abd6-2b3880940b87	t	2026-04-09 07:50:44.729727+00	2026-04-09 14:14:57.908133+00	nm3u7vjucr3d	b2442d92-4f90-4a83-b448-a3d333644716
00000000-0000-0000-0000-000000000000	1379	ngbr3tlf7zzy	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-08 18:53:19.812774+00	2026-04-09 16:02:13.430385+00	syqhcoh5dtlj	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1355	b4ddrh66w6re	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-08 08:50:07.820904+00	2026-04-09 18:03:54.241876+00	wtpqfeknipka	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1396	mrxvh7wiqcp7	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-09 10:03:06.757501+00	2026-04-09 19:37:31.020168+00	vbt27kllib47	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1399	s4s6w4ysi6bd	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-09 10:56:39.67301+00	2026-04-10 09:48:00.644077+00	wottktcbvbwc	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1382	fqds3krtwkak	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-08 19:33:26.601373+00	2026-04-10 11:27:20.106083+00	iivpqb4ayixk	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1361	x773j5pdlc6t	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-08 10:55:56.536313+00	2026-04-10 11:32:52.743032+00	bvzjsafkwcbf	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1370	likbrdytjixo	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-08 13:52:58.020183+00	2026-04-10 14:15:38.217536+00	vkv4sro6j6sc	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1450	2w7b5asyk5yw	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-11 12:33:04.219514+00	2026-04-11 16:12:01.618975+00	\N	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1422	ys2hmtpr7bun	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-10 12:29:05.933567+00	2026-04-11 16:44:35.405905+00	gpz2q4qvc5w6	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1430	qinrnbszwtah	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-10 15:14:10.599194+00	2026-04-12 18:06:19.996681+00	ekjazxwbo77r	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1405	2mmw6dmt3o5e	31984a41-8b67-441c-abd6-2b3880940b87	f	2026-04-09 14:14:57.928243+00	2026-04-09 14:14:57.928243+00	23ddudf3nk5q	b2442d92-4f90-4a83-b448-a3d333644716
00000000-0000-0000-0000-000000000000	1428	yja5dqurb3n5	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-10 14:15:38.238432+00	2026-04-12 18:53:35.607139+00	likbrdytjixo	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1404	6yai3haqrmza	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-09 13:43:48.806364+00	2026-04-09 14:43:49.512857+00	cmifrchp7r7b	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1416	5mzmpjtu34ei	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-10 06:40:46.946367+00	2026-04-13 08:53:33.995049+00	7svawrubzkfq	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1438	pmr44dyjfmcs	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-04-10 19:45:08.160431+00	2026-04-13 12:12:35.936661+00	em63xhkyessg	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	1443	slrdnriht3gm	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-10 23:14:25.033494+00	2026-04-13 17:58:32.538271+00	hoy4uv3yipky	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1409	62gwgavh4o6i	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-09 16:02:13.433297+00	2026-04-09 17:22:30.142978+00	ngbr3tlf7zzy	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1434	h77vnd7lquxa	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-10 17:33:44.139462+00	2026-04-14 10:45:16.967831+00	6w4vq4xe4wi3	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1437	avpp2eg3s544	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-10 19:15:06.972718+00	2026-04-16 14:45:56.88943+00	e56ccmfdgzyf	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1426	3xwz6vbjkdkb	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-10 13:40:17.50729+00	2026-04-18 18:53:49.024755+00	lvj7dniz5ihu	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1857	ajufytbt2jdo	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 15:49:15.075823+00	2026-04-21 17:32:59.057011+00	vptkiuajnqmt	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1831	ivuoejh5ugxi	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-20 18:36:44.630933+00	2026-04-22 09:20:18.717404+00	ang2xttxo7nm	9a6a4ee2-41d5-48b9-8156-0df660cea663
00000000-0000-0000-0000-000000000000	1407	cn6d3exdxzb4	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-09 14:43:49.53202+00	2026-04-09 20:10:32.694325+00	6yai3haqrmza	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1883	vwumm4cxfqz5	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-21 23:01:31.203672+00	2026-04-22 09:51:47.371828+00	ucr6dfqjktyl	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1411	7svawrubzkfq	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-09 18:03:54.257618+00	2026-04-10 06:40:46.910537+00	b4ddrh66w6re	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1830	oiwpof6a2z4m	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-20 18:36:31.818508+00	2026-04-22 11:21:16.906274+00	ifhtp6viaxp6	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1909	zcbyigtcyhdg	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 11:02:13.158032+00	2026-04-22 12:08:58.538628+00	fch7cpiacl2m	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1936	42wmjc3qe3xf	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-22 17:49:13.850536+00	2026-04-23 08:25:30.891682+00	uini466ka66r	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1962	2m5viz3oc3xo	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-23 12:20:32.654947+00	2026-04-23 16:43:23.681061+00	josgetlc2rhm	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1420	gpz2q4qvc5w6	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-10 11:27:20.129653+00	2026-04-10 12:29:05.915545+00	fqds3krtwkak	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1989	gs4jcvimqqnv	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-24 11:06:24.080709+00	2026-04-24 18:44:45.589771+00	cykb56yu7eo6	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1418	go3teh6roa2a	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-10 09:48:00.671231+00	2026-04-10 12:49:47.975977+00	s4s6w4ysi6bd	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	2049	a5yha7ceguxf	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-26 13:26:37.629037+00	2026-04-26 14:25:30.455086+00	r2vl2ntle4tm	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1415	et4rardvxiut	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-09 20:10:32.717392+00	2026-04-10 13:23:06.830927+00	cn6d3exdxzb4	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2022	5wupvk7qyqtl	e804e0cf-72af-449e-9816-46518b271b84	t	2026-04-24 20:08:37.049085+00	2026-04-27 08:20:47.421635+00	5bzkm4e2sbtp	7562ee6f-9b69-4bec-af3b-426c2034b24e
00000000-0000-0000-0000-000000000000	1421	lvj7dniz5ihu	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-10 11:32:52.763741+00	2026-04-10 13:40:17.496645+00	x773j5pdlc6t	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1413	d3f4or556io7	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-09 19:37:31.041652+00	2026-04-10 13:51:43.944582+00	mrxvh7wiqcp7	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1427	ekjazxwbo77r	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-10 13:51:43.952742+00	2026-04-10 15:14:10.574498+00	d3f4or556io7	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1410	p2x4d7hkvi5u	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-09 17:22:30.168811+00	2026-04-10 17:05:32.620909+00	62gwgavh4o6i	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1402	kbeb2iw3uhmf	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-04-09 13:02:38.483063+00	2026-04-10 17:32:37.223075+00	ibea6znu3hzn	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	1424	6w4vq4xe4wi3	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-10 12:49:47.978297+00	2026-04-10 17:33:44.137905+00	go3teh6roa2a	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1425	cqauf5debf4j	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-10 13:23:06.847629+00	2026-04-10 17:47:07.132285+00	et4rardvxiut	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1435	gufv4aufrgdz	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-10 17:47:07.14288+00	2026-04-10 18:47:07.883779+00	cqauf5debf4j	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1432	e56ccmfdgzyf	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-10 17:05:32.642061+00	2026-04-10 19:15:06.956937+00	p2x4d7hkvi5u	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1433	em63xhkyessg	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-04-10 17:32:37.242914+00	2026-04-10 19:45:08.149391+00	kbeb2iw3uhmf	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	1436	j3xv7caypnxr	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-10 18:47:07.891966+00	2026-04-10 19:47:08.699281+00	gufv4aufrgdz	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1439	5vw5dcjchyld	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-10 19:47:08.7071+00	2026-04-10 20:47:09.749416+00	j3xv7caypnxr	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1401	owdlmvqsrirq	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-09 11:29:46.973928+00	2026-04-10 22:15:07.072529+00	t7k23ijkkvni	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1440	zqwt3l35ursv	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-10 20:47:09.760908+00	2026-04-11 08:42:52.510872+00	5vw5dcjchyld	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1445	v65g3aau2ifr	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-11 08:42:52.526959+00	2026-04-11 09:42:53.447787+00	zqwt3l35ursv	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1446	r2d4u3nk5ibh	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-11 09:42:53.466111+00	2026-04-11 10:42:54.217068+00	v65g3aau2ifr	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1447	kjutuq7ybw26	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-11 10:42:54.228205+00	2026-04-11 11:42:55.226812+00	r2d4u3nk5ibh	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1442	wut2j4ybdshh	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-10 22:15:07.100674+00	2026-04-11 13:22:15.493556+00	owdlmvqsrirq	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1449	qk472kfiwhap	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-11 11:42:55.250761+00	2026-04-11 15:47:18.187734+00	kjutuq7ybw26	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1832	d2aq2fgftbpc	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-20 18:44:52.146497+00	2026-04-21 04:31:20.743246+00	tnl7f5dseop4	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1452	isdudy4uxaf7	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-11 15:47:18.21305+00	2026-04-11 16:47:19.449274+00	qk472kfiwhap	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1466	jjzq36o4yhnr	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-11 21:41:57.632991+00	2026-04-11 22:42:40.608692+00	tg55eoyevpjy	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1858	gm5eesxyoosb	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-21 15:53:16.864186+00	2026-04-21 17:24:20.567426+00	futv26gmwxq4	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1467	eu6josdqstps	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-11 22:42:40.638236+00	2026-04-12 09:45:50.076134+00	jjzq36o4yhnr	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1884	5dpyojjvme2v	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-21 23:25:26.305013+00	2026-04-22 05:06:02.661375+00	uocvkmc7zvt2	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1937	mfiq6yxglu3g	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-22 17:50:33.346905+00	2026-04-22 18:48:34.468433+00	h5iz4hyeu72r	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1963	uhjgzr4olc7e	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-23 12:50:45.70632+00	2026-04-24 07:03:32.334493+00	wb3xwbuewmnx	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1476	lfx3avlmtvix	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-12 11:45:59.994236+00	2026-04-12 17:39:30.300177+00	lizeo4ctm3a4	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1990	wh4gklt3scjr	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-24 11:51:28.017156+00	2026-04-24 16:25:40.132889+00	tjrl4ezcemqj	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1468	rygqo6wgpmjq	4f008550-7b28-4437-923b-3438f4aed317	t	2026-04-12 07:16:21.607873+00	2026-04-12 17:54:39.104721+00	sz57qrdthwot	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1910	diabe5np4lgi	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-22 11:09:08.76236+00	2026-04-24 20:54:52.046155+00	uuhbewzuhzjw	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	1480	aduej3zneakt	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-12 17:39:30.330287+00	2026-04-12 18:38:55.964097+00	lfx3avlmtvix	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2023	cciwkhgsuz7j	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-24 20:42:17.649569+00	2026-04-24 22:29:01.338389+00	kqmcpwqarzc6	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1473	t76aco75kepd	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-12 10:42:41.542622+00	2026-04-12 18:44:32.107981+00	pbsv2nja4thc	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	2050	5xzg2mcazy6u	4408336b-259c-437a-9f78-c4a664506756	f	2026-04-26 13:33:25.016863+00	2026-04-26 13:33:25.016863+00	rqgmfby7qwnp	9a6a4ee2-41d5-48b9-8156-0df660cea663
00000000-0000-0000-0000-000000000000	1478	445u2wqrwtrc	be618b84-342d-454e-844d-fef4c2970891	t	2026-04-12 17:00:47.158264+00	2026-04-12 19:12:14.089455+00	ilgeuxsshhmk	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1483	nqsku7sznpkj	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-12 18:38:55.990512+00	2026-04-12 19:38:57.089976+00	aduej3zneakt	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1489	ggosrijyjgtb	943a493d-044c-4c88-babc-e64804553bb4	f	2026-04-12 19:57:43.687328+00	2026-04-12 19:57:43.687328+00	\N	908decdf-2f7e-4917-82bd-8fb252ea1cc0
00000000-0000-0000-0000-000000000000	1454	robetm2km26x	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-11 16:12:01.627241+00	2026-04-12 20:09:38.619699+00	2w7b5asyk5yw	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1488	4ozepmkabvkb	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-12 19:38:57.105157+00	2026-04-12 20:40:36.69672+00	nqsku7sznpkj	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1458	akfktt5zxnsr	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-11 17:08:36.686576+00	2026-04-12 20:46:39.518116+00	wnwtpdniawl4	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1486	xmu3p6nyobri	be618b84-342d-454e-844d-fef4c2970891	t	2026-04-12 19:12:14.109174+00	2026-04-12 21:29:19.323966+00	445u2wqrwtrc	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1491	bzfwxlvithmc	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-12 20:40:36.727777+00	2026-04-12 21:40:37.131144+00	4ozepmkabvkb	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1482	hx2udi6y3g6r	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-12 18:06:20.023286+00	2026-04-12 21:53:25.387698+00	qinrnbszwtah	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1495	lcvyz5ygz43i	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-12 21:40:37.140177+00	2026-04-12 22:40:38.219262+00	bzfwxlvithmc	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1498	ei37rjgjul65	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-12 22:40:38.232352+00	2026-04-12 23:40:39.017123+00	lcvyz5ygz43i	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1499	qkxtlcfxq454	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-12 23:40:39.030062+00	2026-04-13 00:40:39.914796+00	ei37rjgjul65	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1484	m25nei3hh4hx	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-12 18:44:32.119832+00	2026-04-13 08:48:25.412905+00	t76aco75kepd	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1496	u7giyso4utlw	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-12 21:53:25.405746+00	2026-04-13 09:27:40.900332+00	hx2udi6y3g6r	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1509	vofg6ttune7h	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-13 09:02:39.807621+00	2026-04-13 12:01:22.804216+00	r6b6vumgqx72	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1481	w3nbjdf4yrpu	4f008550-7b28-4437-923b-3438f4aed317	t	2026-04-12 17:54:39.138622+00	2026-04-13 14:39:41.879186+00	rygqo6wgpmjq	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1494	ie5s47wcaif6	be618b84-342d-454e-844d-fef4c2970891	t	2026-04-12 21:29:19.335433+00	2026-04-13 14:50:07.275824+00	xmu3p6nyobri	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1513	43vxxdxchk2m	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-13 12:01:22.827446+00	2026-04-13 14:54:17.544516+00	vofg6ttune7h	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1501	s7my4to5hnwu	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-13 00:40:39.930818+00	2026-04-13 17:02:26.134343+00	qkxtlcfxq454	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1508	ineyqk3xqwy6	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-13 08:53:34.014673+00	2026-04-13 19:39:02.156592+00	5mzmpjtu34ei	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1490	yexoi6lqi3cg	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-12 20:09:38.64495+00	2026-04-13 20:14:44.00106+00	robetm2km26x	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1507	b3jarsga2kit	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-13 08:48:25.432588+00	2026-04-13 21:04:07.024906+00	m25nei3hh4hx	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1479	s2rl6xf3h3i2	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-12 17:37:08.317202+00	2026-04-14 11:05:16.387617+00	lx5ouywjw3mu	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1492	l4gsfmpjmep4	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-12 20:46:39.521972+00	2026-04-14 21:53:37.244515+00	akfktt5zxnsr	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1511	nxw6wm24fjvk	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-13 09:27:40.909671+00	2026-04-15 10:25:51.298786+00	u7giyso4utlw	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1485	ymsslxi5t2xk	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-12 18:53:35.621414+00	2026-04-15 21:25:56.959767+00	yja5dqurb3n5	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1451	36z5k2zj7vyu	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-11 13:22:15.518313+00	2026-04-16 11:49:46.884086+00	wut2j4ybdshh	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1510	74k4g7thaapy	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	t	2026-04-13 09:13:51.570452+00	2026-04-17 09:25:13.211395+00	ssszld2aa6ed	57a95f55-f4e7-4e58-9a02-64c9586203b8
00000000-0000-0000-0000-000000000000	1564	nbv6iy3qj6ts	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-14 16:31:56.547439+00	2026-04-19 13:19:46.213162+00	e4pgnxlc4saa	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1516	l36jsm7eqa57	4f008550-7b28-4437-923b-3438f4aed317	f	2026-04-13 14:39:41.905491+00	2026-04-13 14:39:41.905491+00	w3nbjdf4yrpu	25e25d91-a833-42c0-8357-44d5e76a5b5b
00000000-0000-0000-0000-000000000000	1517	dd2wwir6ucbw	be618b84-342d-454e-844d-fef4c2970891	f	2026-04-13 14:50:07.28254+00	2026-04-13 14:50:07.28254+00	ie5s47wcaif6	3d684789-2e64-4a53-89d4-6bc3c902f25e
00000000-0000-0000-0000-000000000000	1885	7ogmcqcol2zw	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 23:59:59.296154+00	2026-04-22 01:18:25.625385+00	2ydg2vbmqpqu	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1515	3abvf4bu4bia	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-04-13 12:12:35.946706+00	2026-04-13 17:55:30.989901+00	pmr44dyjfmcs	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	1520	swxzrcqma5ri	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-13 17:02:26.155529+00	2026-04-13 18:02:27.143568+00	s7my4to5hnwu	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1912	uini466ka66r	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-22 11:23:52.136332+00	2026-04-22 17:49:13.832399+00	yvaqtv3kwptb	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1524	s57eutrnboae	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-13 18:02:27.153022+00	2026-04-13 19:02:27.977782+00	swxzrcqma5ri	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1938	qmjk64bsg464	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 17:51:54.620942+00	2026-04-22 18:51:56.26333+00	zt6tesmour5r	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1964	zdjt2uuqdvwy	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 13:00:52.446727+00	2026-04-23 14:00:53.682248+00	2zlb4vgo3uz6	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1911	vps6uwmhywch	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-22 11:21:16.935147+00	2026-04-23 15:10:40.661721+00	oiwpof6a2z4m	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1526	iep4l7xl2ubx	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-13 19:02:27.993678+00	2026-04-13 20:02:28.730454+00	s57eutrnboae	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1991	s5by6vclkr23	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-24 13:03:53.55965+00	2026-04-24 14:18:49.544296+00	wlyiffay7dkh	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1833	bha7mbfab5ux	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-20 19:29:08.782021+00	2026-04-24 15:09:16.579111+00	pqfmstfnri7l	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1859	6ctfdk5uenpl	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-04-21 15:56:18.022917+00	2026-04-24 16:04:07.662338+00	cvmrhktnezmv	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	1525	mdpk6kdisral	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	t	2026-04-13 18:48:41.764304+00	2026-04-13 20:56:52.79483+00	\N	f2eba057-a1b4-4019-bf68-2840bf276030
00000000-0000-0000-0000-000000000000	1532	cfhacjacgnue	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-04-13 20:56:52.814764+00	2026-04-13 20:56:52.814764+00	mdpk6kdisral	f2eba057-a1b4-4019-bf68-2840bf276030
00000000-0000-0000-0000-000000000000	1529	brxznygknmtt	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-13 20:02:28.744332+00	2026-04-13 21:02:29.558145+00	iep4l7xl2ubx	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2024	tpasyi5dlvp6	4408336b-259c-437a-9f78-c4a664506756	f	2026-04-24 20:54:52.063688+00	2026-04-24 20:54:52.063688+00	diabe5np4lgi	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	2025	rqgmfby7qwnp	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-24 20:55:03.209931+00	2026-04-26 13:33:25.005816+00	w5itxhhupl2g	9a6a4ee2-41d5-48b9-8156-0df660cea663
00000000-0000-0000-0000-000000000000	1533	i4riyhacwing	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-13 21:02:29.561706+00	2026-04-13 22:02:03.643326+00	brxznygknmtt	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2051	f7koovdwj7zb	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-26 14:25:30.483501+00	2026-04-26 16:08:03.587995+00	a5yha7ceguxf	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1530	zpgnd3452klb	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-13 20:14:44.02059+00	2026-04-14 00:26:24.843028+00	yexoi6lqi3cg	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1519	ymodb5dobw7v	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-13 14:54:17.560827+00	2026-04-14 06:56:55.014949+00	43vxxdxchk2m	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1528	vutn4bgwoht3	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-13 19:39:02.176805+00	2026-04-14 07:09:00.440262+00	ineyqk3xqwy6	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1547	pv7wnhsuqne5	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-14 07:09:00.458699+00	2026-04-14 08:10:12.068902+00	vutn4bgwoht3	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1536	dx5tfrgkn2aa	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-13 22:02:03.660486+00	2026-04-14 09:01:54.098146+00	i4riyhacwing	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1546	yesytv6b2dfb	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-14 06:56:55.039234+00	2026-04-14 09:53:00.451723+00	ymodb5dobw7v	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1551	ecuzciy5zb56	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-14 09:01:54.103862+00	2026-04-14 10:01:54.733777+00	dx5tfrgkn2aa	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1540	fuabjbjzxt2b	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-14 00:26:24.852005+00	2026-04-14 11:00:07.83468+00	zpgnd3452klb	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1549	y5u5nftri6za	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-14 08:10:12.080598+00	2026-04-14 12:32:43.656153+00	pv7wnhsuqne5	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1553	4izu2obufhuf	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-14 10:01:54.738195+00	2026-04-14 12:37:50.95057+00	ecuzciy5zb56	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1555	hlv4wfbfw43r	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-14 11:00:07.856675+00	2026-04-14 14:05:37.921172+00	fuabjbjzxt2b	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1561	sja3ygl2xg2h	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-14 14:05:37.958127+00	2026-04-14 15:51:44.419298+00	hlv4wfbfw43r	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1557	e4pgnxlc4saa	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-14 11:05:16.395215+00	2026-04-14 16:31:56.526441+00	s2rl6xf3h3i2	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1534	aaes2gtioorc	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-13 21:04:07.026023+00	2026-04-14 17:14:34.975675+00	b3jarsga2kit	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1560	wfy3v7yr52ik	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-14 12:37:50.959149+00	2026-04-14 17:39:02.316477+00	4izu2obufhuf	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1562	fzehslohry5t	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-14 15:51:44.434098+00	2026-04-15 05:18:14.84412+00	sja3ygl2xg2h	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1554	iewyzqrfqflh	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-14 10:45:16.985292+00	2026-04-15 08:22:00.512288+00	h77vnd7lquxa	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1552	jf6tk6aofkry	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-14 09:53:00.479071+00	2026-04-15 11:37:31.037825+00	yesytv6b2dfb	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1522	qsfrk7twgyac	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-04-13 17:55:31.007231+00	2026-04-15 12:34:13.172938+00	3abvf4bu4bia	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	1559	kh46k57nt5ck	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-14 12:32:43.675592+00	2026-04-15 16:47:27.163754+00	y5u5nftri6za	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1523	vmvs4z3oiq5c	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-13 17:58:32.544442+00	2026-04-16 23:07:39.573745+00	slrdnriht3gm	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1750	bpvzcu357bti	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-19 12:22:56.962069+00	2026-04-19 13:22:57.867932+00	vwda46daxpci	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1834	h6hnbtnktcm2	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-20 19:34:11.196534+00	2026-04-21 06:58:38.849818+00	lje34ejtv6yz	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1567	5v3ydv4sj7kq	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-14 17:39:02.320139+00	2026-04-14 18:39:02.886061+00	wfy3v7yr52ik	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1599	7n5vgazjvm5i	2f58705a-25ad-42c9-b953-5137532b3584	t	2026-04-15 12:34:13.197421+00	2026-04-21 18:01:25.160007+00	qsfrk7twgyac	0b4a81c9-70a8-489e-a4b1-b11817ad3070
00000000-0000-0000-0000-000000000000	1569	55def76dquif	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-14 18:39:02.888176+00	2026-04-14 19:39:04.016008+00	5v3ydv4sj7kq	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1860	35at5rlhsdkw	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-21 15:59:43.269874+00	2026-04-21 21:26:36.228392+00	tx2n5kpdp67n	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1886	ggsipp7tlaum	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 01:18:25.655026+00	2026-04-22 02:42:22.776665+00	7ogmcqcol2zw	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1570	7merufiriodw	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-14 19:39:04.037527+00	2026-04-14 20:39:04.893683+00	55def76dquif	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1565	wy2divmmhbsh	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-14 17:14:34.999316+00	2026-04-14 21:28:40.196267+00	aaes2gtioorc	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1913	hz4sr2m5q6wn	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 11:25:22.473002+00	2026-04-22 13:25:45.115231+00	y65nax3vyhv4	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1572	wb4d4rovj2ws	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-14 20:39:04.909577+00	2026-04-14 21:39:06.159831+00	7merufiriodw	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1575	uxiyj2xbvq2u	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-14 21:53:37.254011+00	2026-04-15 00:28:43.079636+00	l4gsfmpjmep4	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1992	4kvh3irybvrp	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	f	2026-04-24 13:17:54.463881+00	2026-04-24 13:17:54.463881+00	\N	49e49799-b664-4fb4-bef7-a5bb6346168b
00000000-0000-0000-0000-000000000000	1939	ixitfdhekjay	10920fad-ebd2-4be2-8e82-4604204f6139	t	2026-04-22 17:58:40.703914+00	2026-04-24 17:21:35.178576+00	dj5btnpy7zjo	e0ef1413-c2d1-4a43-8823-f5fba0f268a9
00000000-0000-0000-0000-000000000000	1965	vdknhigpymjq	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-23 13:45:10.480971+00	2026-04-24 19:19:09.911499+00	zyd3xq7j5nzd	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1574	ftzuffck4rrh	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-14 21:39:06.167857+00	2026-04-15 08:12:30.480784+00	wb4d4rovj2ws	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1573	n74cnfodutlw	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-14 21:28:40.218561+00	2026-04-15 08:18:03.862207+00	wy2divmmhbsh	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	2026	rvalbqekf2j5	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-24 21:14:27.319631+00	2026-04-25 13:51:49.087178+00	w4klzpwokpek	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	2052	mqy7wvobaz6k	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-26 15:00:33.706273+00	2026-04-26 21:26:02.365268+00	p4gfmfxxvnbe	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	2027	5am4ikytin32	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-24 21:15:03.493697+00	2026-04-27 09:01:55.928004+00	sqqtcdalc64y	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1579	nibl3ibyxa2c	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 08:12:30.499684+00	2026-04-15 09:12:31.142518+00	ftzuffck4rrh	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1581	slrhwd6gsauv	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-15 08:22:00.520128+00	2026-04-15 09:25:07.432267+00	iewyzqrfqflh	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1583	zyp7cqzbu75e	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 09:12:31.154258+00	2026-04-15 10:11:19.99106+00	nibl3ibyxa2c	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1584	wtwousddrnup	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-15 09:25:07.450391+00	2026-04-15 10:27:13.680909+00	slrhwd6gsauv	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1587	xmpgtp57qjmm	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 10:11:20.000653+00	2026-04-15 11:11:45.085482+00	zyp7cqzbu75e	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1577	a24pmqkbkk4g	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-15 05:18:14.879041+00	2026-04-15 11:45:03.290321+00	fzehslohry5t	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1591	qyqzc3iv772a	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 11:11:45.098504+00	2026-04-15 12:10:01.350113+00	xmpgtp57qjmm	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1588	fva5d5kyn5wd	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-15 10:25:51.317708+00	2026-04-15 12:19:10.146813+00	nxw6wm24fjvk	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1593	duhfr2empxis	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-15 11:37:31.04915+00	2026-04-15 14:16:41.980579+00	jf6tk6aofkry	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1594	3rxldjiywyvl	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-15 11:45:03.302665+00	2026-04-15 14:38:49.890211+00	a24pmqkbkk4g	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1601	w3ni552sn6qd	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-15 14:16:41.997591+00	2026-04-15 15:56:21.638935+00	duhfr2empxis	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1597	aoei7c3pwnma	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 12:10:01.357758+00	2026-04-15 16:00:43.436025+00	qyqzc3iv772a	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1603	jlsehj46i6eq	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	t	2026-04-15 15:03:24.284511+00	2026-04-15 16:03:18.541218+00	\N	0ba74217-fba2-4fd7-ba36-bf963c26d9b1
00000000-0000-0000-0000-000000000000	1606	icjtifyojdto	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-04-15 16:03:18.553255+00	2026-04-15 16:03:18.553255+00	jlsehj46i6eq	0ba74217-fba2-4fd7-ba36-bf963c26d9b1
00000000-0000-0000-0000-000000000000	1605	lhnnhssjpl73	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 16:00:43.439817+00	2026-04-15 17:00:44.280246+00	aoei7c3pwnma	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1610	r6qgmb4l74vk	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 17:00:44.286606+00	2026-04-15 18:00:45.59515+00	lhnnhssjpl73	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1284	uqlrlz473ria	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-05 20:11:48.835665+00	2026-04-15 18:14:02.091259+00	zo6sm7gna7m5	9a6a4ee2-41d5-48b9-8156-0df660cea663
00000000-0000-0000-0000-000000000000	1609	6fofbcgpvjub	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	t	2026-04-15 16:58:51.385932+00	2026-04-15 18:33:39.446303+00	\N	57481a16-2ec8-4a04-871a-094886569940
00000000-0000-0000-0000-000000000000	1613	7rlxqlpufhql	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-04-15 18:33:39.458507+00	2026-04-15 18:33:39.458507+00	6fofbcgpvjub	57481a16-2ec8-4a04-871a-094886569940
00000000-0000-0000-0000-000000000000	1611	il6mcv3utrkg	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 18:00:45.623281+00	2026-04-15 19:00:46.264101+00	r6qgmb4l74vk	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1612	gmur2ioqu3a7	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-15 18:14:02.109647+00	2026-04-15 19:12:44.881677+00	uqlrlz473ria	9a6a4ee2-41d5-48b9-8156-0df660cea663
00000000-0000-0000-0000-000000000000	1604	qldseozup767	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-15 15:56:21.666828+00	2026-04-16 09:40:19.977713+00	w3ni552sn6qd	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1608	ji6dvfz5vpiw	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-15 16:47:27.181071+00	2026-04-16 10:13:39.41386+00	kh46k57nt5ck	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1590	irc2d6qar3on	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-04-15 10:51:58.267751+00	2026-04-16 12:25:23.710001+00	n5ouoga4ypde	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1580	mrqk5svyzde5	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-15 08:18:03.880251+00	2026-04-16 13:15:08.132101+00	n74cnfodutlw	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1602	3mtefmsfm7cn	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-15 14:38:49.910165+00	2026-04-16 14:55:11.466015+00	3rxldjiywyvl	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1576	l2zaxxx7rhi7	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-15 00:28:43.113096+00	2026-04-16 14:58:37.218283+00	uxiyj2xbvq2u	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1598	4whlcejdfmnw	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-15 12:19:10.159042+00	2026-04-16 15:13:28.750018+00	fva5d5kyn5wd	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1589	oaqwb4shlf43	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-15 10:27:13.682916+00	2026-04-18 09:38:49.79154+00	wtwousddrnup	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1615	7ilvwup4xlhw	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-15 19:12:44.890545+00	2026-04-20 17:37:03.65175+00	gmur2ioqu3a7	9a6a4ee2-41d5-48b9-8156-0df660cea663
00000000-0000-0000-0000-000000000000	1835	cm3kflpqlyjx	1459c5f5-7c55-4f8c-86a0-f049234706a1	f	2026-04-20 20:52:23.941118+00	2026-04-20 20:52:23.941118+00	36vfqkqlo4qm	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1621	kv42qpqn4xkx	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-15 21:25:56.974217+00	2026-04-20 21:39:43.785607+00	ymsslxi5t2xk	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1614	osidpoiodsyo	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 19:00:46.283431+00	2026-04-15 20:00:47.255384+00	il6mcv3utrkg	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1861	sdr7rhfc7mxq	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 16:31:06.675424+00	2026-04-21 18:05:09.561257+00	dz3ebuwudpxa	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1618	6erh7gcul5a4	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 20:00:47.274985+00	2026-04-15 21:00:47.973126+00	osidpoiodsyo	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1887	ggfi3uucydol	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 02:42:22.797843+00	2026-04-22 03:54:21.012894+00	ggsipp7tlaum	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1661	uuhbewzuhzjw	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-16 18:58:10.303136+00	2026-04-22 11:09:08.750635+00	hjh3puxzc7k7	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	1620	7uthrh2hcxts	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 21:00:47.987506+00	2026-04-15 22:00:48.930414+00	6erh7gcul5a4	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1623	5jgxdjf2aey2	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-15 22:00:48.948452+00	2026-04-16 09:09:51.599563+00	7uthrh2hcxts	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1966	bh5mbjprbun7	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-23 14:00:53.689862+00	2026-04-23 16:50:00.801687+00	zdjt2uuqdvwy	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1624	ds64dglskrax	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 09:09:51.633846+00	2026-04-16 10:09:52.78879+00	5jgxdjf2aey2	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1914	cykb56yu7eo6	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-22 11:30:13.103293+00	2026-04-24 11:06:24.057811+00	5gpayo46bqpl	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1993	rvmeqkqesx5i	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	t	2026-04-24 13:20:19.837349+00	2026-04-24 15:55:05.243903+00	\N	a20c7498-82e9-49ac-a51e-fdb78a554ba5
00000000-0000-0000-0000-000000000000	1651	y5ckax75taso	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	t	2026-04-16 15:09:16.16829+00	2026-04-24 16:03:33.589793+00	l3uk4vwx6qap	70a887fe-cbf5-435c-85c9-3691006bbab8
00000000-0000-0000-0000-000000000000	1940	26gn2owa6sdc	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-22 18:48:34.485137+00	2026-04-24 17:02:58.122279+00	mfiq6yxglu3g	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	2028	t4iqutzrvbva	16f4402c-a1b5-4431-8d98-c454f52a6284	f	2026-04-24 21:23:50.869829+00	2026-04-24 21:23:50.869829+00	5udfextowusj	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1627	fr3vri2ud4gg	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 10:09:52.807114+00	2026-04-16 11:09:53.750674+00	ds64dglskrax	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2053	erajrnwg6363	e92aa512-c44f-48c8-b983-7c7705e36a6f	f	2026-04-26 16:08:03.618679+00	2026-04-26 16:08:03.618679+00	f7koovdwj7zb	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1631	mzndgclonyn7	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 11:09:53.757507+00	2026-04-16 12:09:54.986697+00	fr3vri2ud4gg	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1626	caxf6ct36u5s	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-16 09:40:19.995976+00	2026-04-16 12:38:25.635672+00	qldseozup767	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1628	vbbyiv7kl2ak	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-16 10:13:39.429737+00	2026-04-16 12:42:19.670006+00	ji6dvfz5vpiw	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1639	atrzq6sa5noy	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-04-16 13:54:02.246822+00	2026-04-16 13:54:02.246822+00	\N	ea57d49d-21b7-4301-a465-5a6a9df57ff0
00000000-0000-0000-0000-000000000000	1636	gi3eueduwej2	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-16 12:38:25.653522+00	2026-04-16 14:50:29.853502+00	caxf6ct36u5s	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1617	ekbvmvxi34zp	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	t	2026-04-15 19:27:58.649623+00	2026-04-16 14:54:00.903078+00	\N	00ef3d37-9ca9-41cd-96b6-b3752fe69e42
00000000-0000-0000-0000-000000000000	1633	jwccjtr4mbdy	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 12:09:55.004502+00	2026-04-16 14:56:59.020956+00	mzndgclonyn7	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1637	wcfmpr3v7ztt	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-16 12:42:19.687403+00	2026-04-16 14:57:59.868821+00	vbbyiv7kl2ak	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1634	ecnbj7btrmhk	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-04-16 12:25:23.729287+00	2026-04-16 15:01:29.180391+00	irc2d6qar3on	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1641	3bih5myoqzkz	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	t	2026-04-16 14:44:47.894676+00	2026-04-16 15:47:41.333421+00	\N	28177b15-1cfd-4994-80c3-23d1d59dcb10
00000000-0000-0000-0000-000000000000	1654	6for2aavqaa6	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-04-16 15:47:41.354169+00	2026-04-16 15:47:41.354169+00	3bih5myoqzkz	28177b15-1cfd-4994-80c3-23d1d59dcb10
00000000-0000-0000-0000-000000000000	1647	wnferlppr42i	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 14:56:59.032311+00	2026-04-16 16:48:08.63485+00	jwccjtr4mbdy	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1657	t2aip3ajacnf	b5d23981-469b-4353-a615-9e4d6c8d8daf	f	2026-04-16 17:04:34.221298+00	2026-04-16 17:04:34.221298+00	ewq3exdomsud	bd2ae24d-c3c7-4ac8-b7e5-3295e75a76f9
00000000-0000-0000-0000-000000000000	1656	67ke5fgu6f6y	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 16:48:08.650019+00	2026-04-16 17:48:14.238271+00	wnferlppr42i	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1649	7amxe4evqmi7	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-16 14:58:37.222008+00	2026-04-16 17:49:33.039751+00	l2zaxxx7rhi7	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1658	j7jugdrn72ua	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 17:48:14.259222+00	2026-04-16 18:48:15.141697+00	67ke5fgu6f6y	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1653	hjh3puxzc7k7	4408336b-259c-437a-9f78-c4a664506756	t	2026-04-16 15:37:18.071482+00	2026-04-16 18:58:10.283254+00	kzesivd323m4	e67fe040-3b84-4afe-97fe-21952174c254
00000000-0000-0000-0000-000000000000	1660	trlzbjlqsm7x	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 18:48:15.164604+00	2026-04-16 19:48:16.065287+00	j7jugdrn72ua	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1638	fqx73qkatg6e	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-16 13:15:08.154444+00	2026-04-16 20:15:01.316931+00	mrqk5svyzde5	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1644	jld7riotu3go	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-16 14:50:29.860323+00	2026-04-16 20:38:49.019577+00	gi3eueduwej2	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1663	4dbu2pd2wkha	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 19:48:16.094443+00	2026-04-16 20:47:13.117542+00	trlzbjlqsm7x	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1645	g6v2nbotliyv	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	t	2026-04-16 14:54:00.905175+00	2026-04-16 21:06:52.399584+00	ekbvmvxi34zp	00ef3d37-9ca9-41cd-96b6-b3752fe69e42
00000000-0000-0000-0000-000000000000	1659	d6hxl5jbgp6v	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-16 17:49:33.047961+00	2026-04-16 21:24:21.259714+00	7amxe4evqmi7	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1632	pjigavggtt6r	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-16 11:49:46.907504+00	2026-04-17 08:15:34.689215+00	36z5k2zj7vyu	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1652	xf3shtew5aph	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-16 15:13:28.752689+00	2026-04-17 09:58:26.902179+00	4whlcejdfmnw	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1619	ukreqzpfc6yf	00872e2b-9e9c-442f-810c-bfd62ee8a524	t	2026-04-15 20:45:08.409001+00	2026-04-17 14:29:35.711992+00	ahg5z6kzz4g5	3fd849d4-ea83-4a25-aa5f-e509ff20adf8
00000000-0000-0000-0000-000000000000	1646	3j5uz4wx2ngz	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-16 14:55:11.493552+00	2026-04-17 15:12:52.618602+00	3mtefmsfm7cn	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1648	cfeguf7224bl	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-16 14:57:59.872012+00	2026-04-18 07:48:35.012237+00	wcfmpr3v7ztt	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1642	pgzefeiz5qlm	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-16 14:45:56.902393+00	2026-04-18 12:28:25.026346+00	avpp2eg3s544	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1650	d7shb45mb4jp	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-04-16 15:01:29.185513+00	2026-04-18 18:27:08.745197+00	ecnbj7btrmhk	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1757	hlpxctd5ekmv	10920fad-ebd2-4be2-8e82-4604204f6139	f	2026-04-19 13:31:37.785724+00	2026-04-19 13:31:37.785724+00	\N	8c61ff8a-0c83-449b-95ea-a05f92488895
00000000-0000-0000-0000-000000000000	1693	e5ppvyb7hwjs	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-17 16:30:59.660207+00	2026-04-20 07:27:24.16451+00	yrpkuksnoeai	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1668	zoqs4fcailqt	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	t	2026-04-16 21:06:52.411401+00	2026-04-20 14:34:04.725779+00	g6v2nbotliyv	00ef3d37-9ca9-41cd-96b6-b3752fe69e42
00000000-0000-0000-0000-000000000000	1687	7kicskybxdnq	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-17 13:01:49.986817+00	2026-04-20 18:26:38.50765+00	d3gk222iovwm	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1667	55yxn5mgy56g	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 20:47:13.131637+00	2026-04-16 21:47:13.90246+00	4dbu2pd2wkha	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1670	kupvatxiv24j	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 21:47:13.926566+00	2026-04-16 22:47:15.010498+00	55yxn5mgy56g	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1862	oicbnor5sfq2	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-21 16:41:33.634626+00	2026-04-21 17:41:34.533382+00	zcyfjp4hd6tz	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1671	yw4r53ecrouo	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 22:47:15.034086+00	2026-04-16 23:47:15.764772+00	kupvatxiv24j	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1672	a373zjswebeg	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-16 23:07:39.590431+00	2026-04-21 19:38:49.127513+00	vmvs4z3oiq5c	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1888	ssxluzenpe5j	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-22 03:29:58.269232+00	2026-04-22 07:19:06.599881+00	egsqwdd5jjmn	6fd39da8-325e-4ed7-9734-d80e23d837f7
00000000-0000-0000-0000-000000000000	1664	lcqlcjgpwbth	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-16 20:15:01.345335+00	2026-04-17 09:22:19.370875+00	fqx73qkatg6e	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1677	pg45inespv7a	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	t	2026-04-17 09:24:24.631491+00	2026-04-22 12:32:13.036108+00	unwad5voib3i	e6251a1f-86e9-408e-8f4c-ea3cac1eb435
00000000-0000-0000-0000-000000000000	1678	b7tbbp2yp62q	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-04-17 09:25:13.215178+00	2026-04-17 09:25:13.215178+00	74k4g7thaapy	57a95f55-f4e7-4e58-9a02-64c9586203b8
00000000-0000-0000-0000-000000000000	1836	zve536itwdrb	16f4402c-a1b5-4431-8d98-c454f52a6284	t	2026-04-20 21:39:43.806517+00	2026-04-22 13:42:06.695978+00	kv42qpqn4xkx	7824e9c7-5f6e-440d-8339-27a5105385cc
00000000-0000-0000-0000-000000000000	1676	gpvu4rosmvfu	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-17 09:22:19.378525+00	2026-04-17 10:22:12.884177+00	lcqlcjgpwbth	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1941	xxzlp3rdq6ya	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 18:51:56.267133+00	2026-04-22 19:51:57.12314+00	qmjk64bsg464	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1915	a3bzcdvo3jfh	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-22 11:32:37.041655+00	2026-04-23 15:23:59.19143+00	to6osx77idfe	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1683	pmqv6zh5baoa	943a493d-044c-4c88-babc-e64804553bb4	f	2026-04-17 12:10:25.504505+00	2026-04-17 12:10:25.504505+00	\N	c24099c9-b494-4ec2-b3a6-fa81a76d96ab
00000000-0000-0000-0000-000000000000	1967	jawfxtkny4ms	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-23 15:07:16.883147+00	2026-04-24 07:03:08.338206+00	gziotcn3p6bs	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1680	euem5e5cfjdn	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-17 09:58:26.919693+00	2026-04-17 12:32:14.83351+00	xf3shtew5aph	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1994	5mab2d5fxseq	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-24 14:18:49.568095+00	2026-04-24 15:50:16.783254+00	s5by6vclkr23	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1673	3uoajtn7sxah	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-16 23:47:15.784346+00	2026-04-17 12:49:14.451327+00	yw4r53ecrouo	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	2029	u7usp4my72my	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	f	2026-04-24 21:49:08.920637+00	2026-04-24 21:49:08.920637+00	kgpfgsueqxmv	00ef3d37-9ca9-41cd-96b6-b3752fe69e42
00000000-0000-0000-0000-000000000000	1681	d3gk222iovwm	1459c5f5-7c55-4f8c-86a0-f049234706a1	t	2026-04-17 10:22:12.914182+00	2026-04-17 13:01:49.972168+00	gpvu4rosmvfu	ae2f476b-5f97-401c-9608-90b7590b52b5
00000000-0000-0000-0000-000000000000	1686	kbdaun26vah5	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-17 12:49:14.472028+00	2026-04-17 13:49:15.45469+00	3uoajtn7sxah	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1689	vekb76bhzb5b	00872e2b-9e9c-442f-810c-bfd62ee8a524	f	2026-04-17 14:29:35.72943+00	2026-04-17 14:29:35.72943+00	ukreqzpfc6yf	3fd849d4-ea83-4a25-aa5f-e509ff20adf8
00000000-0000-0000-0000-000000000000	1685	jbvuejodsph3	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-17 12:32:14.837011+00	2026-04-17 14:31:39.806788+00	euem5e5cfjdn	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	2054	kzs3xafuo3wz	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	t	2026-04-26 19:52:54.175364+00	2026-04-27 08:11:04.667613+00	a66g4oro3x45	a20c7498-82e9-49ac-a51e-fdb78a554ba5
00000000-0000-0000-0000-000000000000	1690	yrpkuksnoeai	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-17 14:31:39.811639+00	2026-04-17 16:30:59.655364+00	jbvuejodsph3	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1688	vyarmtgopuev	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-17 13:49:15.479164+00	2026-04-17 17:12:46.16679+00	kbdaun26vah5	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1669	fu7eqcd7opxb	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-16 21:24:21.278768+00	2026-04-17 17:22:25.817625+00	d6hxl5jbgp6v	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1694	pjrv3bxn35e6	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-17 17:12:46.195621+00	2026-04-17 18:12:47.120275+00	vyarmtgopuev	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1674	vo4holn6hx6n	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-17 08:15:34.719857+00	2026-04-17 19:54:46.574303+00	pjigavggtt6r	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1666	46roqgvu5w27	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-16 20:38:49.029912+00	2026-04-17 20:25:06.54216+00	jld7riotu3go	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1695	gluuyjroalfb	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-17 17:22:25.837982+00	2026-04-17 20:27:48.786058+00	fu7eqcd7opxb	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1698	yglrk5ovl3gj	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-17 19:54:46.60264+00	2026-04-17 21:18:28.624302+00	vo4holn6hx6n	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1701	vc5mq34wd44i	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-17 21:18:28.652097+00	2026-04-17 22:21:38.60129+00	yglrk5ovl3gj	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1700	rgtr4u4o6s2t	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-17 20:27:48.79283+00	2026-04-17 22:25:40.138908+00	gluuyjroalfb	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1697	htuq3gsw6gzy	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-17 18:12:47.128531+00	2026-04-17 23:26:30.841261+00	pjrv3bxn35e6	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1705	2ex2u3zlykhx	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-17 23:26:30.869612+00	2026-04-18 00:26:32.223293+00	htuq3gsw6gzy	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1691	6tfvuklyvz75	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-17 15:12:52.636734+00	2026-04-18 05:24:16.423104+00	3j5uz4wx2ngz	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1707	3dnfmcr4z4cc	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-18 05:24:16.458+00	2026-04-18 08:20:58.542114+00	6tfvuklyvz75	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1699	xtph4y3sym4z	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-17 20:25:06.557303+00	2026-04-18 11:15:05.999727+00	46roqgvu5w27	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1706	ozpwvdhs4psw	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-18 00:26:32.244749+00	2026-04-18 13:31:35.613793+00	2ex2u3zlykhx	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1713	uwq3mdhkigfu	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-18 11:15:06.013644+00	2026-04-18 13:46:42.735493+00	xtph4y3sym4z	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1703	xxb72g7jxunv	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-17 22:21:38.625846+00	2026-04-18 14:51:38.266434+00	vc5mq34wd44i	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1712	5su5z3hbfvou	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-18 09:38:49.811954+00	2026-04-18 17:37:12.464794+00	oaqwb4shlf43	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1710	ijqzujt5qbli	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-18 08:20:58.565159+00	2026-04-18 18:07:13.398273+00	3dnfmcr4z4cc	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1704	sntsg2xkc2ed	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-17 22:25:40.157092+00	2026-04-19 06:47:12.148997+00	rgtr4u4o6s2t	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1724	pqfmstfnri7l	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-18 17:37:12.475368+00	2026-04-20 19:29:08.757902+00	5su5z3hbfvou	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	1744	hzuby5dwvod4	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-19 10:22:55.191817+00	2026-04-19 11:22:56.118688+00	7pnlfjx4kv42	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1760	5prdyhocxmjr	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-19 13:40:27.787494+00	2026-04-21 00:53:26.877434+00	s5hsprohonzv	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1738	o7nt7uovph7g	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-18 22:02:32.479695+00	2026-04-19 11:34:16.134788+00	ytzb7d4oy2rz	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1726	cvmrhktnezmv	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-04-18 18:13:11.745699+00	2026-04-21 15:56:18.011168+00	gfxr6lnn6qh3	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	1837	zddckbbbge5x	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-21 00:53:26.908156+00	2026-04-21 19:01:00.92655+00	5prdyhocxmjr	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1743	gnvm6mdxh2f7	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-19 10:06:35.263079+00	2026-04-19 13:35:40.445424+00	edeswhsmgoxg	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1716	ejk52462wu4f	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-18 13:31:35.638258+00	2026-04-18 17:24:04.600259+00	ozpwvdhs4psw	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1863	qom47qfhqf6h	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-21 17:24:20.586687+00	2026-04-21 20:11:37.478132+00	gm5eesxyoosb	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1723	rkuwtcflzkjs	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-04-18 17:26:15.429306+00	2026-04-18 17:26:15.429306+00	\N	f10256a0-940b-4f2c-8e9d-7fe45cebcfd5
00000000-0000-0000-0000-000000000000	1721	gfxr6lnn6qh3	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	t	2026-04-18 16:42:20.986563+00	2026-04-18 18:13:11.734786+00	sj64dmy3ml5p	e0e7c041-bae0-4c4a-a1ed-d865801366b9
00000000-0000-0000-0000-000000000000	1889	44pdiehdehlu	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 03:54:21.039644+00	2026-04-22 05:05:16.749419+00	ggfi3uucydol	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1722	f6xrgi6x3yxh	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-18 17:24:04.627863+00	2026-04-18 18:24:05.362179+00	ejk52462wu4f	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1741	s5hsprohonzv	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-19 06:47:12.177585+00	2026-04-19 13:40:27.77199+00	sntsg2xkc2ed	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1719	zguvryjsqzns	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-18 14:51:38.291857+00	2026-04-18 18:35:53.188669+00	xxb72g7jxunv	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1916	z2hymkzjplbv	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-22 11:51:49.528015+00	2026-04-22 12:51:50.214206+00	cjtlhnvk6lzu	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1766	tlfz4kkcvhoo	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-19 15:15:49.239135+00	2026-04-22 15:54:30.318576+00	7i7cfroh4c4e	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1728	vvnuyypg5ire	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-18 18:24:05.383766+00	2026-04-18 19:24:06.100235+00	f6xrgi6x3yxh	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1755	6iifrcewqksa	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-19 13:19:46.234883+00	2026-04-19 14:17:47.809895+00	nbv6iy3qj6ts	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1729	pgg4bnt6nclq	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-04-18 18:27:08.760825+00	2026-04-18 19:41:01.100644+00	d7shb45mb4jp	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1733	n44aziko7i5z	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-18 19:24:06.130005+00	2026-04-18 20:24:07.043808+00	vvnuyypg5ire	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1942	msdp3m4t32j3	8c1c7bba-636d-42f2-820a-ac1131897e84	t	2026-04-22 19:43:11.326587+00	2026-04-24 15:52:56.906097+00	q67amrzqzhwy	2d9ac9cb-6b87-4ced-b0fe-0587b45397d9
00000000-0000-0000-0000-000000000000	1736	f5wu3diamlna	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-18 20:24:07.07231+00	2026-04-18 21:24:07.966249+00	n44aziko7i5z	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1759	yru7nkckgfbw	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-19 13:35:40.45402+00	2026-04-19 14:34:18.611796+00	gnvm6mdxh2f7	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1732	ytzb7d4oy2rz	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-18 18:53:49.04873+00	2026-04-18 22:02:32.466829+00	3xwz6vbjkdkb	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	1968	hr4qfy2xzyfs	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-23 15:10:40.669116+00	2026-04-24 15:57:27.74393+00	vps6uwmhywch	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1737	on5k3s5ycumz	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-18 21:24:07.978879+00	2026-04-18 22:24:00.024994+00	f5wu3diamlna	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1735	nen6vh7wmrox	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	t	2026-04-18 19:41:01.102317+00	2026-04-24 15:58:15.846066+00	pgg4bnt6nclq	391d2633-351e-4334-b952-2e1d8eaad788
00000000-0000-0000-0000-000000000000	1739	4k7ha7xwjutv	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-18 22:24:00.045278+00	2026-04-18 23:24:00.527902+00	on5k3s5ycumz	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1709	mmnrgh7ohpl6	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-18 07:48:35.041531+00	2026-04-19 14:35:12.296033+00	cfeguf7224bl	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1995	ibeoyj3xttik	c96625ad-9941-423c-8b5a-6fdc1b54ac20	t	2026-04-24 15:09:16.596119+00	2026-04-24 16:24:37.43283+00	bha7mbfab5ux	bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93
00000000-0000-0000-0000-000000000000	2030	gbjfg6psgzjx	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-24 22:29:01.364173+00	2026-04-25 09:29:14.162918+00	cciwkhgsuz7j	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1730	edeswhsmgoxg	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-18 18:35:53.206259+00	2026-04-19 10:06:35.228832+00	zguvryjsqzns	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1740	7pnlfjx4kv42	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-18 23:24:00.543051+00	2026-04-19 10:22:55.177919+00	4k7ha7xwjutv	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1715	65jhj5ib7dib	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-18 12:28:25.046512+00	2026-04-26 22:03:26.049518+00	pgzefeiz5qlm	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	2055	buydantsaiuj	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-26 21:26:02.393187+00	2026-04-27 07:22:26.103086+00	mqy7wvobaz6k	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1763	7i7cfroh4c4e	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-19 14:17:47.818274+00	2026-04-19 15:15:49.21564+00	6iifrcewqksa	8572d9fe-586e-4d40-b93c-2042b9d36650
00000000-0000-0000-0000-000000000000	1725	u5fphfggpzek	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-18 18:07:13.427547+00	2026-04-19 16:59:38.334564+00	ijqzujt5qbli	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1756	2qcixirjpcsb	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-19 13:22:57.88702+00	2026-04-19 17:16:48.905015+00	bpvzcu357bti	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1754	eqdmk5i2jd5l	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-19 13:14:29.396746+00	2026-04-19 17:19:39.487114+00	\N	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1758	uwhevd4g64ma	10920fad-ebd2-4be2-8e82-4604204f6139	t	2026-04-19 13:32:05.601679+00	2026-04-19 17:43:31.788338+00	\N	e0ef1413-c2d1-4a43-8823-f5fba0f268a9
00000000-0000-0000-0000-000000000000	1771	ue7haah2po5h	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-19 17:16:48.906046+00	2026-04-19 18:16:49.556516+00	2qcixirjpcsb	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1768	3xcgcyazs6lv	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-19 16:59:38.355689+00	2026-04-19 19:42:50.410997+00	u5fphfggpzek	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1717	id7xped7wzed	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-18 13:46:42.762031+00	2026-04-20 07:33:14.787406+00	uwq3mdhkigfu	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1764	pyx2cmlc27ov	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-19 14:34:18.637984+00	2026-04-20 07:38:32.631636+00	yru7nkckgfbw	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1765	p3oskysmfi3c	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-19 14:35:12.298385+00	2026-04-20 08:03:52.710786+00	mmnrgh7ohpl6	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1778	buda6hdykx76	ec1c03bd-6b21-4574-aff7-39deac5e25bf	t	2026-04-19 19:42:50.437485+00	2026-04-20 10:57:12.562429+00	3xcgcyazs6lv	ef6ddb62-61bb-4763-ab3e-d58a0bc353d3
00000000-0000-0000-0000-000000000000	1806	dxravzcliiqp	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-20 09:57:36.171575+00	2026-04-20 10:57:36.914571+00	jtkmptbspaix	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1803	rken2ldhtlzk	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-20 09:31:54.081307+00	2026-04-20 11:11:51.051149+00	ocyjn3egm25q	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1801	bqpwt52lswr5	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-20 08:56:23.980122+00	2026-04-20 12:04:05.861488+00	2a5cs3mt2rxd	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1798	isjbvfogkh4h	0e9bdb55-a555-467d-995a-62d64ab8a509	t	2026-04-20 08:03:52.732427+00	2026-04-20 17:02:10.382947+00	p3oskysmfi3c	2e10e97f-dc00-44ed-bba3-6c10816000dd
00000000-0000-0000-0000-000000000000	1794	ifhtp6viaxp6	9d852873-3b29-4018-adde-c6244679e312	t	2026-04-20 07:33:14.806233+00	2026-04-20 18:36:31.797301+00	id7xped7wzed	9b377b5d-4d4a-4b07-8050-93bbb595c7c1
00000000-0000-0000-0000-000000000000	1838	lo3vnb24b6sy	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-21 04:31:20.771704+00	2026-04-21 05:53:45.225341+00	d2aq2fgftbpc	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1793	32ogl3c2xfd3	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-20 07:27:24.185404+00	2026-04-21 08:40:50.1651+00	e5ppvyb7hwjs	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1864	bfft5mekfa2o	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-21 17:32:59.068577+00	2026-04-21 18:43:35.779045+00	ajufytbt2jdo	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1890	wzpgshocihkr	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-22 04:51:15.104416+00	2026-04-22 06:34:25.298907+00	sf3svkzw45pm	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1775	f3boxd4mnwvr	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-19 18:16:49.573056+00	2026-04-19 22:13:26.680867+00	ue7haah2po5h	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1917	4mndzihud6gl	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-22 12:08:58.556679+00	2026-04-22 13:39:43.621709+00	zcbyigtcyhdg	6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902
00000000-0000-0000-0000-000000000000	1783	t7fjzfgsnddq	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-19 22:13:26.696778+00	2026-04-19 23:13:27.469905+00	f3boxd4mnwvr	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1774	xj7pkb4unetx	10920fad-ebd2-4be2-8e82-4604204f6139	t	2026-04-19 17:43:31.804258+00	2026-04-22 16:38:26.394498+00	uwhevd4g64ma	e0ef1413-c2d1-4a43-8823-f5fba0f268a9
00000000-0000-0000-0000-000000000000	1943	363xxixic4xk	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	t	2026-04-22 19:47:38.479859+00	2026-04-23 04:23:47.353573+00	2yu4olmxrgob	b76b4f7f-4424-49ef-ac70-28adfb124c3d
00000000-0000-0000-0000-000000000000	1969	gdvt6yxjae2y	449ee91c-f52f-4661-abd4-ebfd556c37c3	t	2026-04-23 15:23:59.206542+00	2026-04-24 15:55:28.974824+00	a3bzcdvo3jfh	4741f457-f865-4699-9a78-d7d7ccb1bb3c
00000000-0000-0000-0000-000000000000	2031	njypiktxk7vg	c06aa55d-9cd6-4f14-8d85-6c5739913994	t	2026-04-25 06:26:28.088741+00	2026-04-25 07:42:53.748749+00	df24sm5hj6rd	3bc6fd1d-2320-4366-91f6-a1291b117b9f
00000000-0000-0000-0000-000000000000	1996	6rj3f7hj2xhy	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-24 15:17:36.390019+00	2026-04-27 08:04:48.849674+00	rjmhswno7w3r	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	2056	y5cpty7nrhll	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	t	2026-04-26 22:03:26.066127+00	2026-04-27 08:13:13.755951+00	65jhj5ib7dib	bb65e12f-dfc1-480b-936a-8fa12ebb8e04
00000000-0000-0000-0000-000000000000	1784	a7lh2rw3vfr5	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-19 23:13:27.490229+00	2026-04-20 07:57:34.67443+00	t7fjzfgsnddq	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1772	2a5cs3mt2rxd	7d59efea-fc42-4117-a34b-3937905456db	t	2026-04-19 17:19:39.490926+00	2026-04-20 08:56:23.959504+00	eqdmk5i2jd5l	6d8a9303-996f-499b-9d91-83925a0313ca
00000000-0000-0000-0000-000000000000	1797	zjhth7zyjzpt	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-20 07:57:34.703105+00	2026-04-20 08:57:35.211391+00	a7lh2rw3vfr5	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
00000000-0000-0000-0000-000000000000	1795	ocyjn3egm25q	45ef0325-e165-4aef-8836-03099f1d7bd9	t	2026-04-20 07:38:32.632486+00	2026-04-20 09:31:54.06484+00	pyx2cmlc27ov	6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7
00000000-0000-0000-0000-000000000000	1596	pi3sekyhzajh	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	t	2026-04-15 11:57:21.531557+00	2026-04-20 09:55:54.377653+00	\N	ad78a9b8-42b9-422d-86f1-4519e61f2c7f
00000000-0000-0000-0000-000000000000	1805	hbyescmjls7a	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	f	2026-04-20 09:55:54.399131+00	2026-04-20 09:55:54.399131+00	pi3sekyhzajh	ad78a9b8-42b9-422d-86f1-4519e61f2c7f
00000000-0000-0000-0000-000000000000	1802	jtkmptbspaix	e92aa512-c44f-48c8-b983-7c7705e36a6f	t	2026-04-20 08:57:35.215284+00	2026-04-20 09:57:36.162765+00	zjhth7zyjzpt	7c46fbb4-b165-4db6-8ed5-64399b8c3bba
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
20260302000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
8572d9fe-586e-4d40-b93c-2042b9d36650	449ee91c-f52f-4661-abd4-ebfd556c37c3	2026-02-25 11:51:07.531787+00	2026-04-24 17:02:58.175535+00	\N	aal1	\N	2026-04-24 17:02:58.175406	Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:150.0) Gecko/20100101 Firefox/150.0	84.162.172.200	\N	\N	\N	\N	\N
ef6ddb62-61bb-4763-ab3e-d58a0bc353d3	ec1c03bd-6b21-4574-aff7-39deac5e25bf	2026-04-11 12:33:04.202064+00	2026-04-27 08:06:11.655268+00	\N	aal1	\N	2026-04-27 08:06:11.655177	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	143.131.228.59	\N	\N	\N	\N	\N
bb65e12f-dfc1-480b-936a-8fa12ebb8e04	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	2026-03-31 13:01:49.764086+00	2026-04-27 08:13:13.767444+00	\N	aal1	\N	2026-04-27 08:13:13.767354	Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/147.0.7727.99 Mobile/15E148 Safari/604.1	188.87.207.219	\N	\N	\N	\N	\N
57481a16-2ec8-4a04-871a-094886569940	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-04-15 16:58:51.364731+00	2026-04-15 18:33:39.480318+00	\N	aal1	\N	2026-04-15 18:33:39.480206	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
2080d919-8941-487a-9911-23ed6ebe6c37	00872e2b-9e9c-442f-810c-bfd62ee8a524	2026-03-02 11:01:55.133927+00	2026-03-20 17:06:45.949573+00	\N	aal1	\N	2026-03-20 17:06:45.948643	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	137.101.93.181	\N	\N	\N	\N	\N
d9684c6e-99ba-4147-add5-ab40d1ed36e9	00872e2b-9e9c-442f-810c-bfd62ee8a524	2026-02-28 09:27:58.657021+00	2026-02-28 09:27:58.657021+00	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	79.117.245.204	\N	\N	\N	\N	\N
49e49799-b664-4fb4-bef7-a5bb6346168b	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	2026-04-24 13:17:54.453099+00	2026-04-24 13:17:54.453099+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	188.26.193.89	\N	\N	\N	\N	\N
6b043fd0-ab4c-40a6-88f4-28d5d90d4eb7	45ef0325-e165-4aef-8836-03099f1d7bd9	2026-03-09 11:59:31.840578+00	2026-04-25 13:51:49.161725+00	\N	aal1	\N	2026-04-25 13:51:49.16162	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/147.0.7727.99 Mobile/15E148 Safari/604.1	79.117.74.62	\N	\N	\N	\N	\N
f2eba057-a1b4-4019-bf68-2840bf276030	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-04-13 18:48:41.726649+00	2026-04-13 20:56:52.849109+00	\N	aal1	\N	2026-04-13 20:56:52.848994	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
7824e9c7-5f6e-440d-8339-27a5105385cc	16f4402c-a1b5-4431-8d98-c454f52a6284	2026-03-02 22:41:23.049561+00	2026-04-24 21:23:50.885096+00	\N	aal1	\N	2026-04-24 21:23:50.884999	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	88.15.31.60	\N	\N	\N	\N	\N
e0e7c041-bae0-4c4a-a1ed-d865801366b9	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	2026-02-26 13:49:28.522121+00	2026-04-24 19:21:38.602053+00	\N	aal1	\N	2026-04-24 19:21:38.601932	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1	37.47.177.192	\N	\N	\N	\N	\N
a78dc683-0189-4b2b-a3c7-3ea7f965f60c	8d16ce77-1836-4ce6-a462-b9d16358fb3f	2026-03-11 13:14:34.13836+00	2026-03-25 13:16:00.821865+00	\N	aal1	\N	2026-03-25 13:16:00.821166	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36	83.61.216.117	\N	\N	\N	\N	\N
6a00599b-d3f6-4fba-8097-dadcbf0a8f29	00872e2b-9e9c-442f-810c-bfd62ee8a524	2026-02-28 09:28:41.586378+00	2026-03-27 12:39:11.569581+00	\N	aal1	\N	2026-03-27 12:39:11.569443	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36 Edg/146.0.0.0	188.26.222.197	\N	\N	\N	\N	\N
28177b15-1cfd-4994-80c3-23d1d59dcb10	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-04-16 14:44:47.862173+00	2026-04-16 15:47:41.383616+00	\N	aal1	\N	2026-04-16 15:47:41.382938	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
b76b4f7f-4424-49ef-ac70-28adfb124c3d	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	2026-03-01 09:34:58.295879+00	2026-04-27 08:16:48.129905+00	\N	aal1	\N	2026-04-27 08:16:48.129791	Mozilla/5.0 (iPhone; CPU iPhone OS 26_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/147.0.7727.99 Mobile/15E148 Safari/604.1	79.117.227.193	\N	\N	\N	\N	\N
6fd39da8-325e-4ed7-9734-d80e23d837f7	16f4402c-a1b5-4431-8d98-c454f52a6284	2026-03-02 22:26:38.740244+00	2026-04-22 20:20:50.269733+00	\N	aal1	\N	2026-04-22 20:20:50.269626	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	31.221.240.88	\N	\N	\N	\N	\N
2d9ac9cb-6b87-4ced-b0fe-0587b45397d9	8c1c7bba-636d-42f2-820a-ac1131897e84	2026-02-28 11:22:27.668449+00	2026-04-27 08:20:12.64237+00	\N	aal1	\N	2026-04-27 08:20:12.64225	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) SamsungBrowser/29.0 Chrome/136.0.0.0 Mobile Safari/537.36	62.36.126.73	\N	\N	\N	\N	\N
f5e23156-f5ae-48ef-acdc-e813d7be5ebb	943a493d-044c-4c88-babc-e64804553bb4	2026-02-25 19:24:42.877031+00	2026-02-25 19:24:42.877031+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	88.26.169.107	\N	\N	\N	\N	\N
9952d18a-a0af-4cbd-98dc-15844d29d1ed	b5d23981-469b-4353-a615-9e4d6c8d8daf	2026-02-21 18:35:43.795705+00	2026-03-19 20:21:02.894281+00	\N	aal1	\N	2026-03-19 20:21:02.894175	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36	185.114.87.60	\N	\N	\N	\N	\N
6dc2e7f4-73bb-4a6c-bc5b-d0d123a53902	c06aa55d-9cd6-4f14-8d85-6c5739913994	2026-04-20 10:12:01.19853+00	2026-04-27 07:27:34.126395+00	\N	aal1	\N	2026-04-27 07:27:34.126275	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	159.147.90.244	\N	\N	\N	\N	\N
b1d00248-1278-4fa0-97be-da56fa5926a5	943a493d-044c-4c88-babc-e64804553bb4	2026-03-07 11:33:17.514259+00	2026-03-07 11:33:17.514259+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	176.83.94.147	\N	\N	\N	\N	\N
da99741b-fb99-4474-9fa9-fd3e49543738	e804e0cf-72af-449e-9816-46518b271b84	2026-04-21 11:41:40.496849+00	2026-04-22 12:35:14.6038+00	\N	aal1	\N	2026-04-22 12:35:14.603681	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) EdgiOS/147 Version/16.0 Safari/605.1.15	86.127.227.148	\N	\N	\N	\N	\N
1b59da56-646e-48d2-bd35-e145b3703d7c	ff1dccb8-00bc-4042-a869-3a55773f3701	2026-03-08 20:08:11.815578+00	2026-03-15 14:23:51.064498+00	\N	aal1	\N	2026-03-15 14:23:51.064362	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) FxiOS/148.2 Mobile/15E148 Safari/604.1	178.57.161.150	\N	\N	\N	\N	\N
bd3ac2cb-32b8-461b-98e5-b0cf5c35ee93	c96625ad-9941-423c-8b5a-6fdc1b54ac20	2026-03-09 11:32:37.149985+00	2026-04-24 16:24:37.493313+00	\N	aal1	\N	2026-04-24 16:24:37.493202	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	79.116.243.84	\N	\N	\N	\N	\N
6d8a9303-996f-499b-9d91-83925a0313ca	7d59efea-fc42-4117-a34b-3937905456db	2026-04-19 13:14:29.375733+00	2026-04-27 08:04:48.905624+00	\N	aal1	\N	2026-04-27 08:04:48.905509	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	62.36.107.36	\N	\N	\N	\N	\N
0b4a81c9-70a8-489e-a4b1-b11817ad3070	2f58705a-25ad-42c9-b953-5137532b3584	2026-03-01 19:14:31.317146+00	2026-04-25 08:23:34.065989+00	\N	aal1	\N	2026-04-25 08:23:34.065871	Mozilla/5.0 (iPhone; CPU iPhone OS 26_1_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/147.0.7727.99 Mobile/15E148 Safari/604.1	46.222.144.13	\N	\N	\N	\N	\N
dc5e3fbe-b5d0-475a-811e-9761f35394ae	2549f3dd-74dd-473b-be44-d5983b70e1ba	2026-02-25 11:51:51.264289+00	2026-03-19 17:46:08.297808+00	\N	aal1	\N	2026-03-19 17:46:08.297716	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	79.117.227.170	\N	\N	\N	\N	\N
8d645adf-06c6-40c0-a754-d51f12342b4e	ff1dccb8-00bc-4042-a869-3a55773f3701	2026-03-16 15:26:52.226916+00	2026-04-27 09:22:53.243969+00	\N	aal1	\N	2026-04-27 09:22:53.243216	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	130.41.83.29	\N	\N	\N	\N	\N
2e10e97f-dc00-44ed-bba3-6c10816000dd	0e9bdb55-a555-467d-995a-62d64ab8a509	2026-03-19 10:05:01.423385+00	2026-04-27 08:03:51.485522+00	\N	aal1	\N	2026-04-27 08:03:51.485405	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	178.139.163.158	\N	\N	\N	\N	\N
03665399-c6f6-41b4-8800-627c97ec6444	943a493d-044c-4c88-babc-e64804553bb4	2026-04-11 17:12:42.375375+00	2026-04-11 17:12:42.375375+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	86.127.228.86	\N	\N	\N	\N	\N
57a95f55-f4e7-4e58-9a02-64c9586203b8	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-03-30 08:30:27.900071+00	2026-04-17 09:25:13.230058+00	\N	aal1	\N	2026-04-17 09:25:13.22996	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Safari/605.1.15	188.26.194.43	\N	\N	\N	\N	\N
38a7e050-8748-456e-94fe-6d81e4775134	943a493d-044c-4c88-babc-e64804553bb4	2026-03-16 15:53:44.067882+00	2026-03-16 15:53:44.067882+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	83.38.151.78	\N	\N	\N	\N	\N
eb06df08-bb8f-4413-962c-db927135684a	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-03-20 09:12:44.670794+00	2026-03-20 10:55:01.935105+00	\N	aal1	\N	2026-03-20 10:55:01.934992	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
016e7651-84f8-4f4e-8675-2ad1e5ce0531	ff1dccb8-00bc-4042-a869-3a55773f3701	2026-03-27 11:25:20.985037+00	2026-04-01 07:26:18.850616+00	\N	aal1	\N	2026-04-01 07:26:18.850493	Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/145.0.7632.117 Mobile/15E148 Safari/604.1	77.226.162.147	\N	\N	\N	\N	\N
6eae37ff-2205-437e-88d1-9cd43a3f1345	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-03-20 13:19:36.698196+00	2026-03-20 13:19:36.698196+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
3fd849d4-ea83-4a25-aa5f-e509ff20adf8	00872e2b-9e9c-442f-810c-bfd62ee8a524	2026-03-28 12:48:59.854575+00	2026-04-17 14:29:35.759563+00	\N	aal1	\N	2026-04-17 14:29:35.759438	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36 Edg/147.0.0.0	79.117.225.119	\N	\N	\N	\N	\N
ae2f476b-5f97-401c-9608-90b7590b52b5	1459c5f5-7c55-4f8c-86a0-f049234706a1	2026-03-27 13:45:55.264836+00	2026-04-20 20:52:23.975742+00	\N	aal1	\N	2026-04-20 20:52:23.975632	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1	79.145.50.116	\N	\N	\N	\N	\N
88dfd653-2835-4f26-bd15-7c0eeb6241ab	31984a41-8b67-441c-abd6-2b3880940b87	2026-03-19 13:38:05.503918+00	2026-03-25 22:42:34.52145+00	\N	aal1	\N	2026-03-25 22:42:34.520695	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36	79.117.166.45	\N	\N	\N	\N	\N
3d684789-2e64-4a53-89d4-6bc3c902f25e	be618b84-342d-454e-844d-fef4c2970891	2026-03-20 12:41:46.830911+00	2026-04-13 14:50:07.298989+00	\N	aal1	\N	2026-04-13 14:50:07.298883	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	79.117.203.142	\N	\N	\N	\N	\N
b18ad4a5-a8fe-46b6-8855-7d907cfcaf2a	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-03-22 19:53:28.549708+00	2026-03-22 19:53:28.549708+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
391d2633-351e-4334-b952-2e1d8eaad788	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	2026-03-21 13:32:47.8743+00	2026-04-24 15:58:15.850873+00	\N	aal1	\N	2026-04-24 15:58:15.850776	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	31.4.236.135	\N	\N	\N	\N	\N
081a1ba2-f2b2-4359-b2a7-eb90d1281bc4	e92aa512-c44f-48c8-b983-7c7705e36a6f	2026-03-19 11:35:59.398442+00	2026-03-21 10:41:25.923667+00	\N	aal1	\N	2026-03-21 10:41:25.922293	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36	31.4.176.88	\N	\N	\N	\N	\N
10f5facc-ee28-42cd-a394-3e24f9b750dc	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-03-23 11:06:26.373867+00	2026-03-23 11:06:26.373867+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
a20c7498-82e9-49ac-a51e-fdb78a554ba5	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	2026-04-24 13:20:19.820931+00	2026-04-27 09:46:28.083058+00	\N	aal1	\N	2026-04-27 09:46:28.08294	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	95.121.78.170	\N	\N	\N	\N	\N
2a702674-f270-4024-b5a3-48a39b7c072c	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-03-22 09:04:35.498196+00	2026-03-22 09:04:35.498196+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
00ef3d37-9ca9-41cd-96b6-b3752fe69e42	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	2026-04-15 19:27:58.639093+00	2026-04-24 21:49:08.958397+00	\N	aal1	\N	2026-04-24 21:49:08.958286	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	79.116.154.60	\N	\N	\N	\N	\N
7c46fbb4-b165-4db6-8ed5-64399b8c3bba	e92aa512-c44f-48c8-b983-7c7705e36a6f	2026-04-02 11:35:39.101108+00	2026-04-26 16:08:03.660422+00	\N	aal1	\N	2026-04-26 16:08:03.660313	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	86.127.225.78	\N	\N	\N	\N	\N
3e47eab9-3399-4435-a104-8c22ce536768	31984a41-8b67-441c-abd6-2b3880940b87	2026-03-28 16:43:55.753319+00	2026-03-28 19:48:38.300974+00	\N	aal1	\N	2026-03-28 19:48:38.300856	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36	79.117.166.45	\N	\N	\N	\N	\N
e6251a1f-86e9-408e-8f4c-ea3cac1eb435	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	2026-03-19 17:02:05.295173+00	2026-04-27 09:05:25.412705+00	\N	aal1	\N	2026-04-27 09:05:25.41261	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1	193.125.100.204	\N	\N	\N	\N	\N
4741f457-f865-4699-9a78-d7d7ccb1bb3c	449ee91c-f52f-4661-abd4-ebfd556c37c3	2026-03-23 11:27:55.290159+00	2026-04-27 08:04:54.295075+00	\N	aal1	\N	2026-04-27 08:04:54.289688	Mozilla/5.0 (Android 16; Mobile; rv:150.0) Gecko/150.0 Firefox/150.0	46.222.196.180	\N	\N	\N	\N	\N
ad78a9b8-42b9-422d-86f1-4519e61f2c7f	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-04-15 11:57:21.514333+00	2026-04-20 09:55:54.431249+00	\N	aal1	\N	2026-04-20 09:55:54.431144	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.6 Safari/605.1.15	178.237.230.80	\N	\N	\N	\N	\N
70a887fe-cbf5-435c-85c9-3691006bbab8	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	2026-03-19 17:07:22.117303+00	2026-04-24 16:03:33.615355+00	\N	aal1	\N	2026-04-24 16:03:33.615245	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	88.29.163.130	\N	\N	\N	\N	\N
25e25d91-a833-42c0-8357-44d5e76a5b5b	4f008550-7b28-4437-923b-3438f4aed317	2026-03-19 11:55:36.599911+00	2026-04-13 14:39:41.940541+00	\N	aal1	\N	2026-04-13 14:39:41.939738	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	62.36.98.80	\N	\N	\N	\N	\N
9b377b5d-4d4a-4b07-8050-93bbb595c7c1	9d852873-3b29-4018-adde-c6244679e312	2026-04-01 11:44:20.633307+00	2026-04-27 09:01:55.980322+00	\N	aal1	\N	2026-04-27 09:01:55.98021	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	83.39.130.47	\N	\N	\N	\N	\N
e67fe040-3b84-4afe-97fe-21952174c254	4408336b-259c-437a-9f78-c4a664506756	2026-03-24 17:18:17.381349+00	2026-04-24 20:54:52.092191+00	\N	aal1	\N	2026-04-24 20:54:52.092079	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	77.227.66.203	\N	\N	\N	\N	\N
ff598b2e-0a7b-42cb-b33a-746c7efe59e1	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-03-30 12:32:57.427123+00	2026-03-30 12:32:57.427123+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
c24099c9-b494-4ec2-b3a6-fa81a76d96ab	943a493d-044c-4c88-babc-e64804553bb4	2026-04-17 12:10:25.460952+00	2026-04-17 12:10:25.460952+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	86.127.228.119	\N	\N	\N	\N	\N
8c61ff8a-0c83-449b-95ea-a05f92488895	10920fad-ebd2-4be2-8e82-4604204f6139	2026-04-19 13:31:37.761527+00	2026-04-19 13:31:37.761527+00	\N	aal1	\N	\N	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36 EdgA/147.0.0.0	88.3.163.231	\N	\N	\N	\N	\N
f71d0adb-1658-4567-b4b3-628ac114c07a	2549f3dd-74dd-473b-be44-d5983b70e1ba	2026-03-23 16:55:44.769935+00	2026-04-02 19:27:13.921788+00	\N	aal1	\N	2026-04-02 19:27:13.921663	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/145.0.0.0 Safari/537.36	79.117.227.179	\N	\N	\N	\N	\N
9a6a4ee2-41d5-48b9-8156-0df660cea663	4408336b-259c-437a-9f78-c4a664506756	2026-03-31 07:26:41.709147+00	2026-04-26 13:33:25.041605+00	\N	aal1	\N	2026-04-26 13:33:25.040814	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36	77.227.66.203	\N	\N	\N	\N	\N
b2442d92-4f90-4a83-b448-a3d333644716	31984a41-8b67-441c-abd6-2b3880940b87	2026-04-08 09:30:04.74628+00	2026-04-09 14:14:57.964387+00	\N	aal1	\N	2026-04-09 14:14:57.964281	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36	86.127.224.99	\N	\N	\N	\N	\N
52af80ca-d377-4926-a0e9-0e8afbd62198	943a493d-044c-4c88-babc-e64804553bb4	2026-04-24 08:05:16.535026+00	2026-04-24 08:05:16.535026+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	83.38.148.156	\N	\N	\N	\N	\N
9ce1e1c0-e99f-463e-9d96-5b502b42f126	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-04-03 18:28:22.393887+00	2026-04-03 18:28:22.393887+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
908decdf-2f7e-4917-82bd-8fb252ea1cc0	943a493d-044c-4c88-babc-e64804553bb4	2026-04-12 19:57:43.647931+00	2026-04-12 19:57:43.647931+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	176.83.234.88	\N	\N	\N	\N	\N
7918091c-cb18-4b5d-9de8-d38a747ae765	31984a41-8b67-441c-abd6-2b3880940b87	2026-04-03 14:25:33.100777+00	2026-04-05 09:02:55.068253+00	\N	aal1	\N	2026-04-05 09:02:55.067482	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Mobile Safari/537.36	79.117.166.45	\N	\N	\N	\N	\N
0ba74217-fba2-4fd7-ba36-bf963c26d9b1	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-04-15 15:03:24.253127+00	2026-04-15 16:03:18.573644+00	\N	aal1	\N	2026-04-15 16:03:18.573543	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
ea57d49d-21b7-4301-a465-5a6a9df57ff0	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-04-16 13:54:02.200149+00	2026-04-16 13:54:02.200149+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
bd2ae24d-c3c7-4ac8-b7e5-3295e75a76f9	b5d23981-469b-4353-a615-9e4d6c8d8daf	2026-04-05 21:06:13.804915+00	2026-04-16 17:04:34.254324+00	\N	aal1	\N	2026-04-16 17:04:34.254222	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36	185.114.87.60	\N	\N	\N	\N	\N
aac4e3e2-5a85-4f33-bb6e-c56a7cae0649	f1932726-f713-4b61-8650-bf04f45d5b09	2026-04-06 10:07:38.43149+00	2026-04-08 19:24:42.919799+00	\N	aal1	\N	2026-04-08 19:24:42.919681	Mozilla/5.0 (iPhone; CPU iPhone OS 17_3_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.3.1 Mobile/15E148 Safari/604.1	90.161.138.122	\N	\N	\N	\N	\N
f10256a0-940b-4f2c-8e9d-7fe45cebcfd5	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-04-18 17:26:15.411755+00	2026-04-18 17:26:15.411755+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.3 Mobile/15E148 Safari/604.1	188.26.194.43	\N	\N	\N	\N	\N
3bc6fd1d-2320-4366-91f6-a1291b117b9f	c06aa55d-9cd6-4f14-8d85-6c5739913994	2026-04-20 15:39:53.941842+00	2026-04-27 07:22:26.199104+00	\N	aal1	\N	2026-04-27 07:22:26.198986	Mozilla/5.0 (iPhone; CPU iPhone OS 26_4_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/147.0.7727.99 Mobile/15E148 Safari/604.1	185.128.9.39	\N	\N	\N	\N	\N
f96b554f-e06a-4162-9da1-d4c39c097093	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2026-04-27 08:08:28.268559+00	2026-04-27 08:08:28.268559+00	\N	aal1	\N	\N	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.4 Mobile/15E148 Safari/604.1	178.237.230.80	\N	\N	\N	\N	\N
7562ee6f-9b69-4bec-af3b-426c2034b24e	e804e0cf-72af-449e-9816-46518b271b84	2026-04-24 18:18:16.960454+00	2026-04-27 08:20:47.424941+00	\N	aal1	\N	2026-04-27 08:20:47.424852	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Mobile/15E148 Safari/604.1	79.117.111.132	\N	\N	\N	\N	\N
e0ef1413-c2d1-4a43-8823-f5fba0f268a9	10920fad-ebd2-4be2-8e82-4604204f6139	2026-04-19 13:32:05.599095+00	2026-04-24 19:21:09.754992+00	\N	aal1	\N	2026-04-24 19:21:09.754901	Mozilla/5.0 (Linux; Android 16; Xiaomi 15T Build/BP2A.250605.031.A3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.7049.79 Mobile Safari/537.36 XiaoMi/MiuiBrowser/14.54.0-gn	88.3.163.231	\N	\N	\N	\N	\N
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
00000000-0000-0000-0000-000000000000	00872e2b-9e9c-442f-810c-bfd62ee8a524	authenticated	authenticated	mineclavelo11@gmail.com	$2a$10$Dc9MUV5Yh/xtbjnUENoW3urLVBaujjXfRv89LXEaf/X9LI/cRYonq	2026-02-28 09:27:58.646956+00	\N		2026-02-28 09:22:43.230979+00		\N			\N	2026-03-28 12:48:59.853854+00	{"provider": "email", "providers": ["email"]}	{"sub": "00872e2b-9e9c-442f-810c-bfd62ee8a524", "nick": "MELIODAS", "email": "mineclavelo11@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-28 09:22:43.120096+00	2026-04-21 10:32:24.87365+00	\N	\N			\N		0	2300-02-04 10:32:24.873431+00		\N	f	\N	f
00000000-0000-0000-0000-000000000000	449ee91c-f52f-4661-abd4-ebfd556c37c3	authenticated	authenticated	hukha221@gmail.com	$2a$10$.4hVjkKqDx8fAPimAMChRukwgDs00ATBn4CqgzWQP1vkuxeREkAlW	2026-02-25 11:51:07.505688+00	\N		2026-02-25 11:50:01.928268+00		\N			\N	2026-03-23 11:27:55.290068+00	{"provider": "email", "providers": ["email"]}	{"sub": "449ee91c-f52f-4661-abd4-ebfd556c37c3", "nick": "Hukha", "email": "hukha221@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-25 11:50:01.842461+00	2026-04-27 08:04:54.265014+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8c1c7bba-636d-42f2-820a-ac1131897e84	authenticated	authenticated	pedrorodriguezmoya83@gmail.com	$2a$10$/FcmxVkAnijV5/lFzHqeYeH/yBAQlLGgzGL9V6yfVlA3veR99Bxoe	2026-02-28 11:22:27.661093+00	\N		2026-02-28 11:22:16.502673+00		\N			\N	2026-02-28 11:22:27.668357+00	{"provider": "email", "providers": ["email"]}	{"sub": "8c1c7bba-636d-42f2-820a-ac1131897e84", "nick": "Don Ptr Squad", "email": "pedrorodriguezmoya83@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-28 11:22:16.41071+00	2026-04-27 08:20:12.627529+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	be618b84-342d-454e-844d-fef4c2970891	authenticated	authenticated	davidsvalencia.o1@gmail.com	$2a$10$S9pDD/aJv1Qrl2X6gjBVJef/hMYtJvI4lgYsKuGva4QAM7chmOiUa	2026-03-20 12:41:46.809238+00	\N		2026-03-20 12:41:15.635073+00		\N			\N	2026-03-20 12:41:46.829636+00	{"provider": "email", "providers": ["email"]}	{"sub": "be618b84-342d-454e-844d-fef4c2970891", "nick": "Davidsvo96", "email": "davidsvalencia.o1@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-20 12:40:01.168984+00	2026-04-13 14:50:07.288273+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e804e0cf-72af-449e-9816-46518b271b84	authenticated	authenticated	daniel_moruno@hotmail.com	$2a$10$u5Q1nAjORAOGMgqZUbrDju5ivS2i9WYuZa4VeJTA1QOw.vPwYihte	2026-04-21 11:41:40.491792+00	\N		2026-04-21 11:41:07.233575+00		\N			\N	2026-04-24 18:18:16.959377+00	{"provider": "email", "providers": ["email"]}	{"sub": "e804e0cf-72af-449e-9816-46518b271b84", "nick": "Judas", "email": "daniel_moruno@hotmail.com", "email_verified": true, "phone_verified": false}	\N	2026-04-21 11:41:07.152007+00	2026-04-27 08:20:47.423106+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c06aa55d-9cd6-4f14-8d85-6c5739913994	authenticated	authenticated	jhortolano@gmail.com	$2a$10$421fUnsaWu7hdBcR9.kKKO7HwLxElpwerwrZu/obwKtOx6K4WExcm	2026-02-16 14:42:03.862989+00	\N		\N		2026-03-08 20:04:20.645762+00			\N	2026-04-20 15:39:53.941719+00	{"provider": "email", "providers": ["email"]}	{"sub": "c06aa55d-9cd6-4f14-8d85-6c5739913994", "nick": "Mr.Macson", "email": "jhortolano@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-16 14:41:52.428558+00	2026-04-27 07:27:34.108846+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	943a493d-044c-4c88-babc-e64804553bb4	authenticated	authenticated	angel_fgrico@hotmail.com	$2a$10$AJhZDcvdBiGI4gvMFzclZ.fdamdOU082Acq2op7DhHVeMmqdFlzSW	2026-02-25 19:24:42.860648+00	\N		2026-02-25 19:24:06.141473+00		\N			\N	2026-04-24 08:05:16.533244+00	{"provider": "email", "providers": ["email"]}	{"sub": "943a493d-044c-4c88-babc-e64804553bb4", "nick": "Angel_Rico", "email": "angel_fgrico@hotmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-25 19:24:06.031284+00	2026-04-24 08:05:16.622126+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	b5d23981-469b-4353-a615-9e4d6c8d8daf	authenticated	authenticated	adrianruizmartos16@gmail.com	$2a$10$3CzUZUFSTOdmyKa24GZUTeHxdspGzj9NUEVLfXPEGNQ7cU.4zCSjW	2026-02-21 18:35:43.783589+00	\N		2026-02-21 18:35:14.305928+00		\N			\N	2026-04-05 21:06:13.804004+00	{"provider": "email", "providers": ["email"]}	{"sub": "b5d23981-469b-4353-a615-9e4d6c8d8daf", "nick": "AdriWins", "email": "adrianruizmartos16@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-21 18:35:14.190404+00	2026-04-16 17:04:34.237196+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2549f3dd-74dd-473b-be44-d5983b70e1ba	authenticated	authenticated	francisaditrap@gmail.com	$2a$10$jFFnRA7o0GinaRFJJ0cDXuwET4InLx1Dvul6Yko8RcLfZ/Z1sV3ji	2026-02-25 11:51:51.26109+00	\N		2026-02-25 11:51:26.158647+00		\N			\N	2026-03-23 16:55:44.76982+00	{"provider": "email", "providers": ["email"]}	{"sub": "2549f3dd-74dd-473b-be44-d5983b70e1ba", "nick": "Franchesco", "email": "francisaditrap@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-25 11:51:26.140923+00	2026-04-02 19:27:13.909319+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ff1dccb8-00bc-4042-a869-3a55773f3701	authenticated	authenticated	rjgcolino@gmail.com	$2a$10$b1OwVkzY25CoClpixZRi2u.iT3PteD.5CgBwjoA9QH7TESlZxigN2	2026-02-16 15:24:29.591924+00	\N		\N		\N			\N	2026-03-27 11:25:20.984931+00	{"provider": "email", "providers": ["email"]}	{"sub": "ff1dccb8-00bc-4042-a869-3a55773f3701", "nick": "errejota", "email": "rjgcolino@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-16 15:24:06.156321+00	2026-04-27 09:22:53.22563+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	authenticated	authenticated	57juanjose57@gmail.com	$2a$10$GpfQMhmVjoV1fepRVUu/x.3ST9sOJ4.eSwXLysQuYF4httGTlCyvO	2026-02-26 13:49:28.516411+00	\N		2026-02-26 13:49:18.39979+00		\N			\N	2026-02-26 13:49:28.52203+00	{"provider": "email", "providers": ["email"]}	{"sub": "eae8c25a-a99d-480f-8e3e-854d36c5c8dc", "nick": "Jeybiss", "email": "57juanjose57@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-02-26 13:49:18.323529+00	2026-04-24 19:21:38.582443+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	31984a41-8b67-441c-abd6-2b3880940b87	authenticated	authenticated	sergiollaverogomez@gmail.com	$2a$10$NN6zE.fngHd9ZH5.qtlcxOo2DDQc9qTuqeF6K3Ej9ANCIW0/Eiwfy	2026-03-19 13:38:05.498936+00	\N		2026-03-19 13:36:54.507146+00		\N			\N	2026-04-08 09:30:04.742676+00	{"provider": "email", "providers": ["email"]}	{"sub": "31984a41-8b67-441c-abd6-2b3880940b87", "nick": "LlaveringL", "email": "sergiollaverogomez@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-19 13:35:47.386644+00	2026-04-15 12:29:16.64856+00	\N	\N			\N		0	2032-11-09 12:29:16.647717+00		\N	f	\N	f
00000000-0000-0000-0000-000000000000	0e9bdb55-a555-467d-995a-62d64ab8a509	authenticated	authenticated	libertogil@gmail.com	$2a$10$xyKX3C2Hz5auNm8c7wVaxe03kvi.SiD6jbPd9hqHZUrWQoEVFrb7q	2026-03-19 10:05:01.416117+00	\N		2026-03-19 10:04:47.36198+00		\N			\N	2026-03-19 10:05:01.423269+00	{"provider": "email", "providers": ["email"]}	{"sub": "0e9bdb55-a555-467d-995a-62d64ab8a509", "nick": "libertojeans", "email": "libertogil@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-19 10:04:47.253605+00	2026-04-27 08:03:51.473767+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	45ef0325-e165-4aef-8836-03099f1d7bd9	authenticated	authenticated	luischava1234@gmail.com	$2a$10$bR7jOnTDU5JKhYqtm5qjdOMiUoT97U7ihe2ksODQaCF1rnD2S/UHW	2026-03-09 11:59:31.830678+00	\N		2026-03-09 11:59:20.440525+00		\N			\N	2026-03-09 11:59:31.838669+00	{"provider": "email", "providers": ["email"]}	{"sub": "45ef0325-e165-4aef-8836-03099f1d7bd9", "nick": "Chava_14", "email": "luischava1234@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-09 11:59:20.359839+00	2026-04-25 13:51:49.142072+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	authenticated	authenticated	david.cvega89@gmail.com	$2a$10$AdcjtQw1BYIwq8SUqvhclOvZrq2O2jY.DBNA1YRmbsxLV3iSUEmSy	2026-03-01 09:34:58.290428+00	\N		2026-03-01 09:34:43.322612+00		\N			\N	2026-03-01 09:34:58.29578+00	{"provider": "email", "providers": ["email"]}	{"sub": "38f98f64-f2db-47bf-a5ea-dcd1804ce00a", "nick": "themule089", "email": "david.cvega89@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-01 09:34:43.212688+00	2026-04-27 08:16:48.121927+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	e92aa512-c44f-48c8-b983-7c7705e36a6f	authenticated	authenticated	escobarelkin@coruniamericana.edu.co	$2a$10$Zj.BykjY3EmwbeIbkP2Q3O8Bt6DuY2k3XipzJXzQ18K/fyFdMLXBG	2026-03-19 11:35:59.392043+00	\N		2026-03-19 11:35:33.559298+00		\N			\N	2026-04-02 11:35:39.101011+00	{"provider": "email", "providers": ["email"]}	{"sub": "e92aa512-c44f-48c8-b983-7c7705e36a6f", "nick": "Excobar1208", "email": "escobarelkin@coruniamericana.edu.co", "email_verified": true, "phone_verified": false}	\N	2026-03-19 11:35:33.45285+00	2026-04-26 16:08:03.638732+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	8d16ce77-1836-4ce6-a462-b9d16358fb3f	authenticated	authenticated	muycontento10@hotmail.com	$2a$10$9hwtG3lBBxKAcR1EgH7q1OQBla9xhZ8wY45z3UmePbB9NQt5hfQCi	2026-03-11 13:14:34.072826+00	\N		2026-03-11 13:13:38.178514+00		\N			\N	2026-03-11 13:14:34.1365+00	{"provider": "email", "providers": ["email"]}	{"sub": "8d16ce77-1836-4ce6-a462-b9d16358fb3f", "nick": "Rubens_saga", "email": "muycontento10@hotmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-11 13:13:38.094624+00	2026-03-25 16:34:26.417589+00	\N	\N			\N		0	2027-03-25 16:34:26.416814+00		\N	f	\N	f
00000000-0000-0000-0000-000000000000	c96625ad-9941-423c-8b5a-6fdc1b54ac20	authenticated	authenticated	dari970417@gmail.com	$2a$10$pFa07LiTSa42r.8BPD1TVOp4Kg/vk55m/V7KX.qiDCDI8zOPGEb3i	2026-03-09 11:32:37.14358+00	\N		2026-03-09 11:32:15.848157+00		\N			\N	2026-03-09 11:32:37.149201+00	{"provider": "email", "providers": ["email"]}	{"sub": "c96625ad-9941-423c-8b5a-6fdc1b54ac20", "nick": "SharkD", "email": "dari970417@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-09 11:32:15.759641+00	2026-04-24 16:24:37.471364+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	1459c5f5-7c55-4f8c-86a0-f049234706a1	authenticated	authenticated	juanka13games@gmail.com	$2a$10$GUmVtz4DKxS1NXwNH.A5wO3JHC8ABzwPiEKuwEIjBqixfrLupcVpm	2026-03-27 13:45:55.255316+00	\N		2026-03-27 13:45:43.643491+00		\N			\N	2026-03-27 13:45:55.263636+00	{"provider": "email", "providers": ["email"]}	{"sub": "1459c5f5-7c55-4f8c-86a0-f049234706a1", "nick": "Juanka13Games", "email": "juanka13games@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-27 13:45:43.56002+00	2026-04-20 20:52:23.961288+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	authenticated	authenticated	kapi_86@hotmail.com	$2a$10$Fq83CG9bAzdHKRh7bUA/pum54dSt892mPjo3wRcOOZJZey6nxmJ06	2026-03-19 17:02:05.290035+00	\N		2026-03-19 17:01:34.457223+00		\N			\N	2026-03-19 17:02:05.295056+00	{"provider": "email", "providers": ["email"]}	{"sub": "74d1cfe5-421b-4be6-a055-0b7693ff2f1c", "nick": "Kapi_86", "email": "kapi_86@hotmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-19 17:01:34.348746+00	2026-04-27 09:05:25.405586+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2f58705a-25ad-42c9-b953-5137532b3584	authenticated	authenticated	jluisdiazmaroto@gmail.com	$2a$10$ARZ3KOiyTtDOM2dKu26GB.l.Fq95o.XszlbdwJviezIbwE4NmrzXS	2026-03-01 19:14:31.270691+00	\N		2026-03-01 19:03:49.246213+00		\N			\N	2026-03-01 19:14:31.308644+00	{"provider": "email", "providers": ["email"]}	{"sub": "2f58705a-25ad-42c9-b953-5137532b3584", "nick": "Selu ", "email": "jluisdiazmaroto@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-01 19:03:49.130763+00	2026-04-25 08:23:34.052165+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	16f4402c-a1b5-4431-8d98-c454f52a6284	authenticated	authenticated	ikerxu1985@gmail.com	$2a$10$AruBsDX59U49ifBHVTmpWOU1npSlmeJGyUgoEO1WFXT8EvUZWYZLe	2026-03-02 22:26:38.729633+00	\N		2026-03-02 22:26:22.707407+00		\N			\N	2026-03-02 22:41:23.048837+00	{"provider": "email", "providers": ["email"]}	{"sub": "16f4402c-a1b5-4431-8d98-c454f52a6284", "nick": "Iker", "email": "ikerxu1985@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-02 22:26:22.573167+00	2026-04-24 21:23:50.881443+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4f008550-7b28-4437-923b-3438f4aed317	authenticated	authenticated	l14mkrls@icloud.com	$2a$10$TOkcBfR/glYcNeHV9kZrju9MdS0tmuEmx3M8v61e1a5Qy2/12uDEa	2026-03-19 11:55:36.570621+00	\N		2026-03-19 11:47:53.555836+00		\N			\N	2026-03-19 11:55:36.598805+00	{"provider": "email", "providers": ["email"]}	{"sub": "4f008550-7b28-4437-923b-3438f4aed317", "nick": "L1amAiram", "email": "l14mkrls@icloud.com", "email_verified": true, "phone_verified": false}	\N	2026-03-19 11:47:53.522626+00	2026-04-20 09:06:30.034297+00	\N	\N			\N		0	2032-11-14 09:06:30.028449+00		\N	f	\N	f
00000000-0000-0000-0000-000000000000	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	authenticated	authenticated	kokoncholopez@gmail.com	$2a$10$Jm5tF0mROqit3z8xVZnTYeBnkxovYlIbNhpB7kwd2oWHy56.hEUne	2026-04-24 13:17:54.444794+00	\N		2026-04-24 13:17:38.010186+00		\N			\N	2026-04-24 13:20:19.820827+00	{"provider": "email", "providers": ["email"]}	{"sub": "81a8640c-85be-4c54-9e36-9a5ac9c98e4a", "nick": "Santi", "email": "kokoncholopez@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-04-24 13:17:37.925482+00	2026-04-27 09:46:28.069998+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	f1932726-f713-4b61-8650-bf04f45d5b09	authenticated	authenticated	mendyvillacity@gmail.com	$2a$10$ZB8Ob9qlN9oYwq2TnokoKOd3QTWz4kCUsMdFyTKe7S8zCAzF/ljQm	2026-04-06 10:07:38.423341+00	\N		2026-04-06 10:05:58.546621+00		\N			\N	2026-04-06 10:07:38.430685+00	{"provider": "email", "providers": ["email"]}	{"sub": "f1932726-f713-4b61-8650-bf04f45d5b09", "nick": "payomalo89", "email": "mendyvillacity@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-04-06 10:05:58.480947+00	2026-04-24 07:08:55.777402+00	\N	\N			\N		0	2300-02-07 07:08:55.776462+00		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4408336b-259c-437a-9f78-c4a664506756	authenticated	authenticated	felixrg1703@gmail.com	$2a$10$tsIJEdGyghG22fUn2KAU/uwK9W84Vwl1lY5cigIuUJ.vPReSqfi2.	2026-03-24 17:18:17.374853+00	\N		2026-03-24 17:18:04.044667+00		\N			\N	2026-03-31 07:26:41.709034+00	{"provider": "email", "providers": ["email"]}	{"sub": "4408336b-259c-437a-9f78-c4a664506756", "nick": "FelixRG", "email": "felixrg1703@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-24 17:18:03.952167+00	2026-04-26 13:33:25.029612+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	authenticated	authenticated	efstathioski@gmail.com	$2a$10$zfBGIyLkpC89WSBvimHdSu1EatW9YtRlb131NcCyuYBTF9.FjPJK6	2026-04-15 19:27:58.635527+00	\N		2026-04-15 19:27:47.304352+00		\N			\N	2026-04-15 19:27:58.639014+00	{"provider": "email", "providers": ["email"]}	{"sub": "56f68d15-9c80-4b6a-9537-d8f5e8c1f021", "nick": "GreekVE", "email": "efstathioski@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-04-15 19:27:47.249013+00	2026-04-24 21:49:08.940591+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	authenticated	authenticated	ocarvallo23@gmail.com	$2a$10$sqlemlt2mUMPzJAf6srJdOL70EIXZ9Mw9EipoxBs2Tyu5V3CCVozS	2026-03-21 13:32:47.836852+00	\N		2026-03-21 13:28:47.227904+00		\N			\N	2026-03-21 13:32:47.872663+00	{"provider": "email", "providers": ["email"]}	{"sub": "4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd", "nick": "Ocarvallo15", "email": "ocarvallo23@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-21 13:28:47.101665+00	2026-04-24 15:58:15.849206+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	authenticated	authenticated	melliot001@hotmail.com	$2a$10$v87UcrjC5kGj.J/yNpuDw.C8w2hoavbR1N3dostF/FBeWTyZeEMo2	2026-03-31 13:01:49.755667+00	\N		2026-03-31 13:00:35.919548+00		\N			\N	2026-03-31 13:01:49.761493+00	{"provider": "email", "providers": ["email"]}	{"sub": "39b4f188-96fa-4fc8-8d91-4d954f67c5d3", "nick": "melliot1990", "email": "melliot001@hotmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-31 13:00:35.883338+00	2026-04-27 08:13:13.76443+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	7d59efea-fc42-4117-a34b-3937905456db	authenticated	authenticated	pedrocanosanchez1@gmail.com	$2a$10$IGaPMIUcW/Bln7Njzwt8GunTukffguIffvrv8biABmGtzGzt1p/ba	2026-04-19 13:14:29.340732+00	\N		2026-04-19 13:14:01.580443+00		\N			\N	2026-04-19 13:14:29.373292+00	{"provider": "email", "providers": ["email"]}	{"sub": "7d59efea-fc42-4117-a34b-3937905456db", "nick": "Sueldo analogo", "email": "pedrocanosanchez1@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-04-19 13:14:01.528194+00	2026-04-27 08:04:48.890076+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	ec1c03bd-6b21-4574-aff7-39deac5e25bf	authenticated	authenticated	antoniocruzp80@gmail.com	$2a$10$qrn4/fqYJlLu3.7zl7PG5eOVTsaEIayMdSTgRVr2t.Pn/yi137oby	2026-04-11 12:33:04.196637+00	\N		2026-04-11 12:32:48.330291+00		\N			\N	2026-04-11 12:33:04.20195+00	{"provider": "email", "providers": ["email"]}	{"sub": "ec1c03bd-6b21-4574-aff7-39deac5e25bf", "nick": "Acrazun", "email": "antoniocruzp80@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-04-11 12:32:48.228034+00	2026-04-27 08:06:11.653387+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	authenticated	authenticated	fernandoguardado04@gmail.com	$2a$10$Yk6kJoarZa34olrUDQb/XuY6/5QVMwKVvI/CLSPI3ghVXDXj5iucm	2026-03-19 17:07:22.111419+00	\N		2026-03-19 17:06:58.672654+00		\N			\N	2026-03-19 17:07:22.11628+00	{"provider": "email", "providers": ["email"]}	{"sub": "af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76", "nick": "Fernando92", "email": "fernandoguardado04@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-19 17:06:58.635297+00	2026-04-24 16:03:33.603593+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	10920fad-ebd2-4be2-8e82-4604204f6139	authenticated	authenticated	joni_esnaider@hotmail.com	$2a$10$MyD1KEY1xJUVGKB/MnM9JuW35uPkOEStxu4cndkw0Z8.oxTNFc7su	2026-04-19 13:31:37.723137+00	\N		2026-04-19 13:30:06.939859+00		\N			\N	2026-04-19 13:32:05.599009+00	{"provider": "email", "providers": ["email"]}	{"sub": "10920fad-ebd2-4be2-8e82-4604204f6139", "nick": "jonny_black83", "email": "joni_esnaider@hotmail.com", "email_verified": true, "phone_verified": false}	\N	2026-04-19 13:30:06.886816+00	2026-04-24 19:21:09.753356+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	authenticated	authenticated	infoalbertoegea@gmail.com	$2a$10$UHlaTo0O1627pWle2tiWUOQLHP/puBAJPXPbI1NBIPcVMjiD1YwIG	2026-03-20 09:12:44.654041+00	\N		2026-03-20 09:12:32.961581+00		\N			\N	2026-04-27 08:08:28.267599+00	{"provider": "email", "providers": ["email"]}	{"sub": "05fcf0a8-e2f1-46b3-bad4-8d3b267fd003", "nick": "Egea", "email": "infoalbertoegea@gmail.com", "email_verified": true, "phone_verified": false}	\N	2026-03-20 09:12:32.847557+00	2026-04-27 08:08:28.326663+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	9d852873-3b29-4018-adde-c6244679e312	authenticated	authenticated	charlie29948@hotmail.com	$2a$10$zVcXsJqvin3Ozh6.0rtv6Oykp9JqvXmEzUZ6xg9X6TPukUiQpMY12	2026-04-01 11:44:20.628857+00	\N		2026-04-01 11:44:07.064945+00		\N			\N	2026-04-01 11:44:20.6332+00	{"provider": "email", "providers": ["email"]}	{"sub": "9d852873-3b29-4018-adde-c6244679e312", "nick": "CharGie29", "email": "charlie29948@hotmail.com", "email_verified": true, "phone_verified": false}	\N	2026-04-01 11:44:06.975272+00	2026-04-27 09:01:55.972236+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: avisos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.avisos (id, titulo, contenido, mostrar, updated_at) FROM stdin;
1	📅 La nueva temporada de liga empieza el martes 📅	Ya podéis consultar el calendario de los próximos partidos.	t	2026-04-27 07:45:01.823+00
\.


--
-- Data for Name: config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.config (id, current_week, current_season, allow_registration) FROM stdin;
1	0	2	t
\.


--
-- Data for Name: encuestas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.encuestas (id, pregunta, opciones, activa, created_at, creador_id) FROM stdin;
91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	¿Cómo os gustaría jugar las jornadas?	{"1 partido - Igual que ahora","2 partidos - Se suman los goles","2 partidos - Solo cuenta victoria/empate/derrota. Si es Victoria-Derrota o Empate-Empate, se juega un tercer partido."}	f	2026-04-16 14:34:07.42466+00	\N
\.


--
-- Data for Name: extra_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extra_groups (id, extra_id, nombre_grupo, created_at) FROM stdin;
fbc03f64-38b8-4a75-8469-5bcbad875296	3cfb1829-52c0-44ff-adf5-e030ca38331b	Grupo A	2026-03-21 16:02:24.537188+00
9fd30f54-d01c-45c9-8f22-f3b01905e6db	3cfb1829-52c0-44ff-adf5-e030ca38331b	Grupo B	2026-03-21 16:02:24.830874+00
94a5ebb6-01c0-4b78-b94e-bdbf4e83bcbf	3cfb1829-52c0-44ff-adf5-e030ca38331b	Grupo C	2026-03-21 16:02:25.08336+00
67aa88ee-6739-451e-b695-d21883734d36	3cfb1829-52c0-44ff-adf5-e030ca38331b	Grupo D	2026-03-21 16:02:25.308722+00
deb6e026-258f-4f1d-b27a-35b8a307b8e0	3cfb1829-52c0-44ff-adf5-e030ca38331b	Grupo E	2026-03-21 16:02:25.493953+00
d2d24a4d-2eb9-44e7-abb0-eacad8f32fe9	3cfb1829-52c0-44ff-adf5-e030ca38331b	Grupo F	2026-03-21 16:02:25.69188+00
743b87bc-a47f-471c-b4b0-52c9765548ae	3cfb1829-52c0-44ff-adf5-e030ca38331b	Grupo G	2026-03-21 16:02:25.873189+00
2a87fa59-2970-4a32-a7f2-86f32d3c3352	59b65dd8-3c59-4576-b744-6b2765c73eb6	Grupo A	2026-03-27 13:53:20.163143+00
27669dd4-4cbc-4982-a089-2445a99fee95	b8da2430-6d1b-4732-bc62-790d55537a87	Grupo A	2026-04-27 07:38:38.172414+00
06fe3996-a8e4-4c72-a42b-f22ed5cb34ad	b8da2430-6d1b-4732-bc62-790d55537a87	Grupo B	2026-04-27 07:38:38.378803+00
5ce8255d-1d8a-4e87-b8b3-71addf57b1ac	b8da2430-6d1b-4732-bc62-790d55537a87	Grupo C	2026-04-27 07:38:38.553712+00
9210ef8f-8f0e-49b2-b253-c75cd2db0a20	b8da2430-6d1b-4732-bc62-790d55537a87	Grupo D	2026-04-27 07:38:38.72923+00
1d5ef9fc-cf8a-44e7-922d-8579e268846a	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	Grupo A	2026-04-27 07:41:08.115894+00
b4a6f022-dded-4f45-9c88-a0fc1cd066ab	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	Grupo B	2026-04-27 07:41:08.299645+00
31f18934-83a1-4a32-8a4d-f53428d4f0fb	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	Grupo C	2026-04-27 07:41:08.499201+00
e05acde3-be06-4826-a33f-759da29282a6	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	Grupo D	2026-04-27 07:41:08.690293+00
5c4028c5-ca8d-43a8-a35f-5581d060edb8	4f2ec4ba-8989-4a4a-922d-e59f969de4af	Grupo A	2026-04-27 07:43:36.733531+00
febafa6b-bfeb-4aaf-8540-686233c7cf02	4f2ec4ba-8989-4a4a-922d-e59f969de4af	Grupo B	2026-04-27 07:43:37.257415+00
cb79f1a5-82d0-4e8b-87eb-d3446f9ac7f6	4f2ec4ba-8989-4a4a-922d-e59f969de4af	Grupo C	2026-04-27 07:43:37.838685+00
06895b18-d72e-4f4b-8622-9d5b1167e05d	4f2ec4ba-8989-4a4a-922d-e59f969de4af	Grupo D	2026-04-27 07:43:38.341098+00
\.


--
-- Data for Name: extra_matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extra_matches (id, extra_id, group_id, player1_id, player2_id, score1, score2, fecha_inicio, fecha_fin, fase, numero_jornada, is_played, next_match_id, stream_url, updated_at) FROM stdin;
bac3a95e-ae25-4236-b27d-8274672783d4	3cfb1829-52c0-44ff-adf5-e030ca38331b	deb6e026-258f-4f1d-b27a-35b8a307b8e0	31984a41-8b67-441c-abd6-2b3880940b87	be618b84-342d-454e-844d-fef4c2970891	5	5	\N	\N	j2	2	t	\N		2026-04-03 14:26:53.452139+00
5b49f82e-73f4-4779-bde6-cf26ea76db64	3cfb1829-52c0-44ff-adf5-e030ca38331b	743b87bc-a47f-471c-b4b0-52c9765548ae	8c1c7bba-636d-42f2-820a-ac1131897e84	943a493d-044c-4c88-babc-e64804553bb4	0	4	\N	\N	j3	3	t	\N	https://www.twitch.tv/donptrsquad?sr=a	2026-03-31 12:14:54.327671+00
a8c9065c-76e7-4e7a-8132-770ceebd4149	3cfb1829-52c0-44ff-adf5-e030ca38331b	94a5ebb6-01c0-4b78-b94e-bdbf4e83bcbf	4408336b-259c-437a-9f78-c4a664506756	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	5	0	\N	\N	j1	1	t	\N	\N	2026-04-05 20:50:22.862554+00
da732262-4284-4660-8456-18415f906f0c	3cfb1829-52c0-44ff-adf5-e030ca38331b	94a5ebb6-01c0-4b78-b94e-bdbf4e83bcbf	4408336b-259c-437a-9f78-c4a664506756	c06aa55d-9cd6-4f14-8d85-6c5739913994	3	2	\N	\N	j3	3	t	\N	https://www.twitch.tv/mistermacson2	2026-04-01 10:01:57.027857+00
94bbfafe-48bc-4b44-95f7-a40bb687fbbb	3cfb1829-52c0-44ff-adf5-e030ca38331b	743b87bc-a47f-471c-b4b0-52c9765548ae	8c1c7bba-636d-42f2-820a-ac1131897e84	449ee91c-f52f-4661-abd4-ebfd556c37c3	2	6	\N	\N	j2	2	t	\N	https://www.twitch.tv/donptrsquad?sr=a	2026-03-31 12:44:56.504169+00
ac56bbd0-f97e-4a9b-a52f-d97b4db15a67	59b65dd8-3c59-4576-b744-6b2765c73eb6	2a87fa59-2970-4a32-a7f2-86f32d3c3352	1459c5f5-7c55-4f8c-86a0-f049234706a1	f1932726-f713-4b61-8650-bf04f45d5b09	5	3	\N	\N	j3	3	t	\N		2026-04-08 18:02:50.525611+00
1051dd0f-c74a-4167-9a51-345cb9bf25c0	3cfb1829-52c0-44ff-adf5-e030ca38331b	9fd30f54-d01c-45c9-8f22-f3b01905e6db	16f4402c-a1b5-4431-8d98-c454f52a6284	45ef0325-e165-4aef-8836-03099f1d7bd9	3	5	\N	\N	j3	3	t	\N		2026-03-30 10:53:08.874688+00
a9e1ca66-d883-435c-b9f5-ad25c307a27d	3cfb1829-52c0-44ff-adf5-e030ca38331b	fbc03f64-38b8-4a75-8469-5bcbad875296	00872e2b-9e9c-442f-810c-bfd62ee8a524	4f008550-7b28-4437-923b-3438f4aed317	3	5	\N	\N	j2	2	t	\N		2026-04-01 12:00:05.487563+00
c1bc6198-6169-4d54-94a7-8c871b734e5c	3cfb1829-52c0-44ff-adf5-e030ca38331b	9fd30f54-d01c-45c9-8f22-f3b01905e6db	c96625ad-9941-423c-8b5a-6fdc1b54ac20	16f4402c-a1b5-4431-8d98-c454f52a6284	6	2	\N	\N	j1	1	t	\N		2026-03-28 12:07:37.512694+00
a0ecc94a-3934-45b3-8b00-24a85cb3a801	3cfb1829-52c0-44ff-adf5-e030ca38331b	67aa88ee-6739-451e-b695-d21883734d36	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	0e9bdb55-a555-467d-995a-62d64ab8a509	0	0	\N	\N	j2	2	t	\N		2026-04-03 18:28:54.076887+00
f1a90954-6bac-41cb-9eaf-1ce2c877acf1	3cfb1829-52c0-44ff-adf5-e030ca38331b	fbc03f64-38b8-4a75-8469-5bcbad875296	e92aa512-c44f-48c8-b983-7c7705e36a6f	ff1dccb8-00bc-4042-a869-3a55773f3701	5	0	\N	\N	j2	2	t	\N	\N	2026-04-02 10:45:55.669382+00
b6ee7b0f-f4ae-4a14-ad72-da9d88bbb47b	59b65dd8-3c59-4576-b744-6b2765c73eb6	2a87fa59-2970-4a32-a7f2-86f32d3c3352	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	f1932726-f713-4b61-8650-bf04f45d5b09	4	7	\N	\N	j2	2	t	\N		2026-04-08 19:25:12.512665+00
6cfc08df-eaf8-4a4e-b945-583c4d2bd5de	3cfb1829-52c0-44ff-adf5-e030ca38331b	d2d24a4d-2eb9-44e7-abb0-eacad8f32fe9	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	1	4	\N	\N	j3	3	t	\N		2026-04-04 10:27:36.003024+00
6ae2eb35-31aa-425e-b2b0-d3ade9373266	3cfb1829-52c0-44ff-adf5-e030ca38331b	deb6e026-258f-4f1d-b27a-35b8a307b8e0	1459c5f5-7c55-4f8c-86a0-f049234706a1	31984a41-8b67-441c-abd6-2b3880940b87	1	6	\N	\N	j3	3	t	\N		2026-04-04 10:53:35.651507+00
36c8003d-c0e0-4a45-bf66-6478939cc5fb	3cfb1829-52c0-44ff-adf5-e030ca38331b	67aa88ee-6739-451e-b695-d21883734d36	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	0e9bdb55-a555-467d-995a-62d64ab8a509	10	5	\N	\N	j3	3	t	\N		2026-03-30 19:52:03.386577+00
6370cdfa-171f-4d86-9f86-9a32ad6c5f29	3cfb1829-52c0-44ff-adf5-e030ca38331b	94a5ebb6-01c0-4b78-b94e-bdbf4e83bcbf	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	c06aa55d-9cd6-4f14-8d85-6c5739913994	1	6	\N	\N	j2	2	t	\N	https://www.twitch.tv/mistermacson2	2026-03-28 12:14:40.838539+00
2e350b29-c738-4028-8a20-8bfdb109bb0c	3cfb1829-52c0-44ff-adf5-e030ca38331b	deb6e026-258f-4f1d-b27a-35b8a307b8e0	be618b84-342d-454e-844d-fef4c2970891	1459c5f5-7c55-4f8c-86a0-f049234706a1	0	0	\N	\N	j1	1	t	\N	\N	2026-04-04 11:37:25.417055+00
5b20f1f7-45eb-4f4f-b3b5-6c57028c5df6	3cfb1829-52c0-44ff-adf5-e030ca38331b	94a5ebb6-01c0-4b78-b94e-bdbf4e83bcbf	b5d23981-469b-4353-a615-9e4d6c8d8daf	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	3	0	\N	\N	j3	3	t	\N		2026-04-05 21:09:13.449176+00
79f7f70e-ac36-4311-b7fb-3377d91e4c78	59b65dd8-3c59-4576-b744-6b2765c73eb6	2a87fa59-2970-4a32-a7f2-86f32d3c3352	1459c5f5-7c55-4f8c-86a0-f049234706a1	ec1c03bd-6b21-4574-aff7-39deac5e25bf	2	1	\N	\N	j2	2	t	\N		2026-04-14 17:15:16.461943+00
edb4c78d-9be9-4b1b-9b9f-d3dd78adac89	3cfb1829-52c0-44ff-adf5-e030ca38331b	fbc03f64-38b8-4a75-8469-5bcbad875296	e92aa512-c44f-48c8-b983-7c7705e36a6f	00872e2b-9e9c-442f-810c-bfd62ee8a524	3	4	\N	\N	j1	1	t	\N	https://www.twitch.tv/videos/2733835338	2026-03-28 13:19:50.438515+00
79d12439-1d21-4452-a5f0-f5d2e79ec552	3cfb1829-52c0-44ff-adf5-e030ca38331b	743b87bc-a47f-471c-b4b0-52c9765548ae	943a493d-044c-4c88-babc-e64804553bb4	449ee91c-f52f-4661-abd4-ebfd556c37c3	2	7	\N	\N	j1	1	t	\N		2026-03-27 13:17:08.277431+00
031962fb-8a5d-4992-824b-0c0bab1eeed2	3cfb1829-52c0-44ff-adf5-e030ca38331b	94a5ebb6-01c0-4b78-b94e-bdbf4e83bcbf	c06aa55d-9cd6-4f14-8d85-6c5739913994	b5d23981-469b-4353-a615-9e4d6c8d8daf	6	3	\N	\N	j1	1	t	\N	https://www.twitch.tv/mistermacson2	2026-03-29 18:24:05.985409+00
e035563c-beda-4997-ac55-3d0840017d73	3cfb1829-52c0-44ff-adf5-e030ca38331b	fbc03f64-38b8-4a75-8469-5bcbad875296	ff1dccb8-00bc-4042-a869-3a55773f3701	00872e2b-9e9c-442f-810c-bfd62ee8a524	0	5	\N	\N	j3	3	t	\N	\N	2026-04-02 10:46:13.221685+00
c9bdc75f-9fd9-4535-8084-0fc431db95ea	3cfb1829-52c0-44ff-adf5-e030ca38331b	67aa88ee-6739-451e-b695-d21883734d36	0e9bdb55-a555-467d-995a-62d64ab8a509	8d16ce77-1836-4ce6-a462-b9d16358fb3f	3	0	\N	\N	j1	1	t	\N	\N	2026-03-27 13:17:08.277431+00
627925f0-05e6-49dd-930b-0e61f17bbf7f	3cfb1829-52c0-44ff-adf5-e030ca38331b	67aa88ee-6739-451e-b695-d21883734d36	8d16ce77-1836-4ce6-a462-b9d16358fb3f	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	0	3	\N	\N	j3	3	t	\N	\N	2026-03-27 13:17:08.277431+00
dd4e75bd-44a0-4efe-a6a8-ec506a98542b	3cfb1829-52c0-44ff-adf5-e030ca38331b	67aa88ee-6739-451e-b695-d21883734d36	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	8d16ce77-1836-4ce6-a462-b9d16358fb3f	3	0	\N	\N	j2	2	t	\N	\N	2026-03-27 13:17:08.277431+00
6ec22e1f-8801-4e63-9c57-fca6ae153dbc	3cfb1829-52c0-44ff-adf5-e030ca38331b	d2d24a4d-2eb9-44e7-abb0-eacad8f32fe9	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	2549f3dd-74dd-473b-be44-d5983b70e1ba	8	3	\N	\N	j1	1	t	\N		2026-03-27 13:17:08.277431+00
9730e264-bc2e-443c-897a-62e653e298b2	3cfb1829-52c0-44ff-adf5-e030ca38331b	deb6e026-258f-4f1d-b27a-35b8a307b8e0	2f58705a-25ad-42c9-b953-5137532b3584	31984a41-8b67-441c-abd6-2b3880940b87	1	6	\N	\N	j1	1	t	\N		2026-03-27 13:17:08.277431+00
4c8afe3a-97c5-4969-8a6e-e0237355f5b1	3cfb1829-52c0-44ff-adf5-e030ca38331b	67aa88ee-6739-451e-b695-d21883734d36	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	6	1	\N	\N	j1	1	t	\N		2026-03-27 13:17:08.277431+00
1bbb6e77-5c6f-4ba2-9f6a-b7f73a661146	3cfb1829-52c0-44ff-adf5-e030ca38331b	fbc03f64-38b8-4a75-8469-5bcbad875296	4f008550-7b28-4437-923b-3438f4aed317	ff1dccb8-00bc-4042-a869-3a55773f3701	7	2	\N	\N	j1	1	t	\N		2026-03-27 13:17:08.277431+00
e8fabf18-7467-4012-94fc-31d129e07595	59b65dd8-3c59-4576-b744-6b2765c73eb6	2a87fa59-2970-4a32-a7f2-86f32d3c3352	f1932726-f713-4b61-8650-bf04f45d5b09	ec1c03bd-6b21-4574-aff7-39deac5e25bf	0	5	\N	\N	j1	1	t	\N	\N	2026-04-15 08:03:24.823437+00
6cbc9b9f-e108-417b-b8bb-2b1bb5fc394d	3cfb1829-52c0-44ff-adf5-e030ca38331b	9fd30f54-d01c-45c9-8f22-f3b01905e6db	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	45ef0325-e165-4aef-8836-03099f1d7bd9	3	0	\N	\N	j1	1	t	\N		2026-03-29 19:13:33.71259+00
c1c170ee-c0db-4208-8f4b-3ad0fd950baa	b8da2430-6d1b-4732-bc62-790d55537a87	27669dd4-4cbc-4982-a089-2445a99fee95	4408336b-259c-437a-9f78-c4a664506756	9d852873-3b29-4018-adde-c6244679e312	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:38:38.287139+00
1d541871-6a27-4f46-9cf8-18c639cd4bac	3cfb1829-52c0-44ff-adf5-e030ca38331b	94a5ebb6-01c0-4b78-b94e-bdbf4e83bcbf	4408336b-259c-437a-9f78-c4a664506756	b5d23981-469b-4353-a615-9e4d6c8d8daf	7	2	\N	\N	j2	2	t	\N	https://www.twitch.tv/felixrg1703	2026-04-05 20:40:36.284599+00
a63831e4-1365-42c0-a907-cea68deaf348	b8da2430-6d1b-4732-bc62-790d55537a87	27669dd4-4cbc-4982-a089-2445a99fee95	449ee91c-f52f-4661-abd4-ebfd556c37c3	9d852873-3b29-4018-adde-c6244679e312	\N	\N	\N	\N	j2	2	f	\N	\N	2026-04-27 07:38:38.287139+00
c2df50bb-0e2e-4821-be3a-2187f4f9f777	b8da2430-6d1b-4732-bc62-790d55537a87	27669dd4-4cbc-4982-a089-2445a99fee95	449ee91c-f52f-4661-abd4-ebfd556c37c3	4408336b-259c-437a-9f78-c4a664506756	\N	\N	\N	\N	j3	3	f	\N	\N	2026-04-27 07:38:38.287139+00
e78aa559-8df2-4da8-b3b1-95e81a0446c8	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	1d5ef9fc-cf8a-44e7-922d-8579e268846a	2549f3dd-74dd-473b-be44-d5983b70e1ba	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:41:08.207092+00
9d1948ed-248f-41d6-93d3-89fa1f7333d2	3cfb1829-52c0-44ff-adf5-e030ca38331b	9fd30f54-d01c-45c9-8f22-f3b01905e6db	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	c96625ad-9941-423c-8b5a-6fdc1b54ac20	8	3	\N	\N	j3	3	t	\N		2026-03-31 16:22:02.71556+00
c2e49469-c4c8-4018-9543-5fa325f44530	3cfb1829-52c0-44ff-adf5-e030ca38331b	9fd30f54-d01c-45c9-8f22-f3b01905e6db	45ef0325-e165-4aef-8836-03099f1d7bd9	c96625ad-9941-423c-8b5a-6fdc1b54ac20	2	2	\N	\N	j2	2	t	\N		2026-03-31 16:46:52.109427+00
96c5b516-6e04-4efd-aaf2-b8a302bd7cdd	3cfb1829-52c0-44ff-adf5-e030ca38331b	9fd30f54-d01c-45c9-8f22-f3b01905e6db	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	16f4402c-a1b5-4431-8d98-c454f52a6284	3	0	\N	\N	j2	2	t	\N		2026-03-31 19:36:35.40052+00
2898804b-1361-4d16-aa31-392b08516328	3cfb1829-52c0-44ff-adf5-e030ca38331b	fbc03f64-38b8-4a75-8469-5bcbad875296	e92aa512-c44f-48c8-b983-7c7705e36a6f	4f008550-7b28-4437-923b-3438f4aed317	5	5	\N	\N	j3	3	t	\N		2026-04-02 11:34:56.083319+00
88371f33-6bf1-4d82-aa4a-33ce4ac2471c	3cfb1829-52c0-44ff-adf5-e030ca38331b	d2d24a4d-2eb9-44e7-abb0-eacad8f32fe9	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	2549f3dd-74dd-473b-be44-d5983b70e1ba	4	7	\N	\N	j2	2	t	\N		2026-04-02 16:14:57.166013+00
5829ed13-4679-4cc6-8f75-72b40c5db50c	59b65dd8-3c59-4576-b744-6b2765c73eb6	2a87fa59-2970-4a32-a7f2-86f32d3c3352	1459c5f5-7c55-4f8c-86a0-f049234706a1	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	9	4	\N	\N	j1	1	t	\N		2026-04-03 09:13:16.497882+00
f13286db-2e2a-41fa-bbfa-1d8aecf4c993	3cfb1829-52c0-44ff-adf5-e030ca38331b	deb6e026-258f-4f1d-b27a-35b8a307b8e0	2f58705a-25ad-42c9-b953-5137532b3584	1459c5f5-7c55-4f8c-86a0-f049234706a1	0	0	\N	\N	j2	2	t	\N	\N	2026-04-07 19:46:40.970301+00
dd3077fe-2b4a-41b5-9edd-439398f8ebb6	3cfb1829-52c0-44ff-adf5-e030ca38331b	deb6e026-258f-4f1d-b27a-35b8a307b8e0	2f58705a-25ad-42c9-b953-5137532b3584	be618b84-342d-454e-844d-fef4c2970891	0	0	\N	\N	j3	3	t	\N	\N	2026-04-07 19:46:48.566485+00
c7d3d958-4f00-4716-af22-20619d924d97	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	1d5ef9fc-cf8a-44e7-922d-8579e268846a	2f58705a-25ad-42c9-b953-5137532b3584	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	\N	\N	j2	2	f	\N	\N	2026-04-27 07:41:08.207092+00
d8b575ce-6d0d-46bb-b43b-d70d26383ba5	59b65dd8-3c59-4576-b744-6b2765c73eb6	2a87fa59-2970-4a32-a7f2-86f32d3c3352	ec1c03bd-6b21-4574-aff7-39deac5e25bf	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	7	3	\N	\N	j3	3	t	\N		2026-04-13 20:40:52.395155+00
ec705ea7-8090-4eca-9878-87b42fadb97f	b8da2430-6d1b-4732-bc62-790d55537a87	06fe3996-a8e4-4c72-a42b-f22ed5cb34ad	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:38:38.464915+00
cfc8c176-8b25-4b07-b026-2b7523b677a8	b8da2430-6d1b-4732-bc62-790d55537a87	06fe3996-a8e4-4c72-a42b-f22ed5cb34ad	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	\N	\N	j2	2	f	\N	\N	2026-04-27 07:38:38.464915+00
08c16f1f-44b9-422b-82fe-bf0bb2d4fc80	b8da2430-6d1b-4732-bc62-790d55537a87	06fe3996-a8e4-4c72-a42b-f22ed5cb34ad	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	\N	\N	\N	\N	j3	3	f	\N	\N	2026-04-27 07:38:38.464915+00
66ccedaf-0961-407f-b106-481f3a21b86b	b8da2430-6d1b-4732-bc62-790d55537a87	5ce8255d-1d8a-4e87-b8b3-71addf57b1ac	10920fad-ebd2-4be2-8e82-4604204f6139	be618b84-342d-454e-844d-fef4c2970891	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:38:38.644989+00
300d5478-1d49-4123-b45a-fec2caf9277c	b8da2430-6d1b-4732-bc62-790d55537a87	9210ef8f-8f0e-49b2-b253-c75cd2db0a20	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:38:38.815619+00
d6d4a717-00d0-49a1-9be7-fbf0df154c06	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	1d5ef9fc-cf8a-44e7-922d-8579e268846a	2f58705a-25ad-42c9-b953-5137532b3584	2549f3dd-74dd-473b-be44-d5983b70e1ba	\N	\N	\N	\N	j3	3	f	\N	\N	2026-04-27 07:41:08.207092+00
c1ae9370-6e17-4627-82cb-7a199f81cefe	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	b4a6f022-dded-4f45-9c88-a0fc1cd066ab	16f4402c-a1b5-4431-8d98-c454f52a6284	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:41:08.404994+00
8843e6be-1efd-426b-9cec-dd32a3e40b4f	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	b4a6f022-dded-4f45-9c88-a0fc1cd066ab	1459c5f5-7c55-4f8c-86a0-f049234706a1	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	\N	\N	\N	\N	j2	2	f	\N	\N	2026-04-27 07:41:08.404994+00
2f1c8999-f946-4769-9f6a-1771ede1c0e1	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	b4a6f022-dded-4f45-9c88-a0fc1cd066ab	1459c5f5-7c55-4f8c-86a0-f049234706a1	16f4402c-a1b5-4431-8d98-c454f52a6284	\N	\N	\N	\N	j3	3	f	\N	\N	2026-04-27 07:41:08.404994+00
7f786751-f61b-4a5f-afb7-3e241890f56b	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	31f18934-83a1-4a32-8a4d-f53428d4f0fb	e92aa512-c44f-48c8-b983-7c7705e36a6f	8c1c7bba-636d-42f2-820a-ac1131897e84	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:41:08.600757+00
0edb96bb-c81c-43ba-b8c7-c0fea496a87e	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	e05acde3-be06-4826-a33f-759da29282a6	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	ec1c03bd-6b21-4574-aff7-39deac5e25bf	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:41:08.781264+00
3d033d9e-6dec-4758-bc5f-31ad2a9c65fa	4f2ec4ba-8989-4a4a-922d-e59f969de4af	5c4028c5-ca8d-43a8-a35f-5581d060edb8	ff1dccb8-00bc-4042-a869-3a55773f3701	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:43:36.98364+00
4b5b10fa-f1ad-40ca-82ca-eb5e38eb6b45	4f2ec4ba-8989-4a4a-922d-e59f969de4af	5c4028c5-ca8d-43a8-a35f-5581d060edb8	0e9bdb55-a555-467d-995a-62d64ab8a509	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	\N	\N	\N	\N	j2	2	f	\N	\N	2026-04-27 07:43:36.98364+00
5e54284c-e95f-4337-8291-beade888324d	4f2ec4ba-8989-4a4a-922d-e59f969de4af	5c4028c5-ca8d-43a8-a35f-5581d060edb8	0e9bdb55-a555-467d-995a-62d64ab8a509	ff1dccb8-00bc-4042-a869-3a55773f3701	\N	\N	\N	\N	j3	3	f	\N	\N	2026-04-27 07:43:36.98364+00
0aeb3132-6d07-4c55-9b0d-c155b3d27c80	4f2ec4ba-8989-4a4a-922d-e59f969de4af	febafa6b-bfeb-4aaf-8540-686233c7cf02	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:43:37.548887+00
f567bc1e-63b8-40ed-b0f8-592fabefb4ae	4f2ec4ba-8989-4a4a-922d-e59f969de4af	febafa6b-bfeb-4aaf-8540-686233c7cf02	943a493d-044c-4c88-babc-e64804553bb4	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	\N	\N	j2	2	f	\N	\N	2026-04-27 07:43:37.548887+00
18b8d30a-8b4b-423d-bba0-b22467c9fb37	4f2ec4ba-8989-4a4a-922d-e59f969de4af	febafa6b-bfeb-4aaf-8540-686233c7cf02	943a493d-044c-4c88-babc-e64804553bb4	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	\N	\N	\N	\N	j3	3	f	\N	\N	2026-04-27 07:43:37.548887+00
07a39e2d-9eae-4098-a4e2-b4dd2ed6b0eb	4f2ec4ba-8989-4a4a-922d-e59f969de4af	cb79f1a5-82d0-4e8b-87eb-d3446f9ac7f6	b5d23981-469b-4353-a615-9e4d6c8d8daf	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:43:38.122404+00
bebb37c2-dbca-41cc-8ac3-270e5436f8de	4f2ec4ba-8989-4a4a-922d-e59f969de4af	06895b18-d72e-4f4b-8622-9d5b1167e05d	e804e0cf-72af-449e-9816-46518b271b84	7d59efea-fc42-4117-a34b-3937905456db	\N	\N	\N	\N	j1	1	f	\N	\N	2026-04-27 07:43:38.534278+00
\.


--
-- Data for Name: extra_playoffs_matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.extra_playoffs_matches (id, playoff_extra_id, numero_jornada, player1_id, group_id_p1, posicion_p1, player2_id, group_id_p2, posicion_p2, score1, score2, is_played, created_at, p1_from_match_id, p2_from_match_id, stream_url, stream_updated_at, updated_at) FROM stdin;
14	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	4f008550-7b28-4437-923b-3438f4aed317	743b87bc-a47f-471c-b4b0-52c9765548ae	2	\N	deb6e026-258f-4f1d-b27a-35b8a307b8e0	3	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.225199+00
2	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	31984a41-8b67-441c-abd6-2b3880940b87	9fd30f54-d01c-45c9-8f22-f3b01905e6db	3	\N	94a5ebb6-01c0-4b78-b94e-bdbf4e83bcbf	3	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.225429+00
5	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	e92aa512-c44f-48c8-b983-7c7705e36a6f	67aa88ee-6739-451e-b695-d21883734d36	1	\N	\N	\N	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.226416+00
19	3cfb1829-52c0-44ff-adf5-e030ca38331b	OCTAVOS	e92aa512-c44f-48c8-b983-7c7705e36a6f	\N	\N	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	3	2	t	2026-03-21 16:02:26.246616+00	5	6		\N	2026-04-15 10:27:52.440088+00
1	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	fbc03f64-38b8-4a75-8469-5bcbad875296	1	\N	\N	\N	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.232372+00
69	59b65dd8-3c59-4576-b744-6b2765c73eb6	SEMIS VUELTA	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	2a87fa59-2970-4a32-a7f2-86f32d3c3352	4	1459c5f5-7c55-4f8c-86a0-f049234706a1	2a87fa59-2970-4a32-a7f2-86f32d3c3352	1	1	5	t	2026-03-27 13:53:20.434446+00	\N	\N		\N	2026-04-20 18:27:29.886623+00
4	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	c06aa55d-9cd6-4f14-8d85-6c5739913994	9fd30f54-d01c-45c9-8f22-f3b01905e6db	2	\N	\N	\N	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.236932+00
17	3cfb1829-52c0-44ff-adf5-e030ca38331b	OCTAVOS	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	\N	\N	31984a41-8b67-441c-abd6-2b3880940b87	\N	\N	4	2	t	2026-03-21 16:02:26.246616+00	1	2		\N	2026-04-15 10:52:17.42003+00
3	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	449ee91c-f52f-4661-abd4-ebfd556c37c3	fbc03f64-38b8-4a75-8469-5bcbad875296	2	\N	\N	\N	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.282898+00
12	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	00872e2b-9e9c-442f-810c-bfd62ee8a524	94a5ebb6-01c0-4b78-b94e-bdbf4e83bcbf	2	\N	\N	\N	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.282947+00
72	59b65dd8-3c59-4576-b744-6b2765c73eb6	FINAL	1459c5f5-7c55-4f8c-86a0-f049234706a1	\N	\N	ec1c03bd-6b21-4574-aff7-39deac5e25bf	\N	\N	0	0	t	2026-03-27 13:53:20.573194+00	68	70	\N	\N	2026-04-27 07:29:33.43969+00
15	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	d2d24a4d-2eb9-44e7-abb0-eacad8f32fe9	1	\N	\N	\N	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.286865+00
11	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	45ef0325-e165-4aef-8836-03099f1d7bd9	743b87bc-a47f-471c-b4b0-52c9765548ae	1	\N	\N	\N	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.287847+00
16	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	4408336b-259c-437a-9f78-c4a664506756	67aa88ee-6739-451e-b695-d21883734d36	2	\N	\N	\N	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.304056+00
13	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	94a5ebb6-01c0-4b78-b94e-bdbf4e83bcbf	1	\N	\N	\N	\N	\N	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-07 19:46:49.309787+00
73	b8da2430-6d1b-4732-bc62-790d55537a87	CUARTOS	\N	27669dd4-4cbc-4982-a089-2445a99fee95	1	\N	9210ef8f-8f0e-49b2-b253-c75cd2db0a20	2	\N	\N	f	2026-04-27 07:38:38.924862+00	\N	\N	\N	\N	2026-04-27 07:38:38.924862+00
27	3cfb1829-52c0-44ff-adf5-e030ca38331b	CUARTOS	0e9bdb55-a555-467d-995a-62d64ab8a509	\N	\N	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	1	6	t	2026-03-21 16:02:26.353118+00	21	22		\N	2026-04-20 19:27:59.257717+00
6	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	c96625ad-9941-423c-8b5a-6fdc1b54ac20	d2d24a4d-2eb9-44e7-abb0-eacad8f32fe9	2	8c1c7bba-636d-42f2-820a-ac1131897e84	d2d24a4d-2eb9-44e7-abb0-eacad8f32fe9	3	5	0	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-09 10:56:07.553946+00
74	b8da2430-6d1b-4732-bc62-790d55537a87	CUARTOS	\N	9210ef8f-8f0e-49b2-b253-c75cd2db0a20	1	\N	27669dd4-4cbc-4982-a089-2445a99fee95	2	\N	\N	f	2026-04-27 07:38:38.924862+00	\N	\N	\N	\N	2026-04-27 07:38:38.924862+00
10	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	0e9bdb55-a555-467d-995a-62d64ab8a509	fbc03f64-38b8-4a75-8469-5bcbad875296	3	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	67aa88ee-6739-451e-b695-d21883734d36	3	5	3	t	2026-03-21 16:02:26.100668+00	\N	\N		\N	2026-04-09 18:07:05.523006+00
25	3cfb1829-52c0-44ff-adf5-e030ca38331b	CUARTOS	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	\N	\N	449ee91c-f52f-4661-abd4-ebfd556c37c3	\N	\N	0	5	t	2026-03-21 16:02:26.353118+00	17	18	\N	\N	2026-04-21 14:15:34.880207+00
24	3cfb1829-52c0-44ff-adf5-e030ca38331b	OCTAVOS	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	\N	\N	4408336b-259c-437a-9f78-c4a664506756	\N	\N	4	5	t	2026-03-21 16:02:26.246616+00	15	16	https://www.twitch.tv/felixrg1703	\N	2026-04-15 19:32:06.090089+00
75	b8da2430-6d1b-4732-bc62-790d55537a87	CUARTOS	\N	06fe3996-a8e4-4c72-a42b-f22ed5cb34ad	1	\N	5ce8255d-1d8a-4e87-b8b3-71addf57b1ac	2	\N	\N	f	2026-04-27 07:38:38.924862+00	\N	\N	\N	\N	2026-04-27 07:38:38.924862+00
28	3cfb1829-52c0-44ff-adf5-e030ca38331b	CUARTOS	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	\N	\N	4408336b-259c-437a-9f78-c4a664506756	\N	\N	3	4	t	2026-03-21 16:02:26.353118+00	23	24	https://www.twitch.tv/felixrg1703?sr=a	\N	2026-04-22 11:11:26.680186+00
76	b8da2430-6d1b-4732-bc62-790d55537a87	CUARTOS	\N	5ce8255d-1d8a-4e87-b8b3-71addf57b1ac	1	\N	06fe3996-a8e4-4c72-a42b-f22ed5cb34ad	2	\N	\N	f	2026-04-27 07:38:38.924862+00	\N	\N	\N	\N	2026-04-27 07:38:38.924862+00
68	59b65dd8-3c59-4576-b744-6b2765c73eb6	SEMIS IDA	1459c5f5-7c55-4f8c-86a0-f049234706a1	2a87fa59-2970-4a32-a7f2-86f32d3c3352	1	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	2a87fa59-2970-4a32-a7f2-86f32d3c3352	4	7	2	t	2026-03-27 13:53:20.434446+00	\N	\N		\N	2026-04-17 09:22:44.912082+00
29	3cfb1829-52c0-44ff-adf5-e030ca38331b	SEMIS	449ee91c-f52f-4661-abd4-ebfd556c37c3	\N	\N	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	\N	\N	5	0	t	2026-03-21 16:02:26.448846+00	25	26	https://www.twitch.tv/hukha	\N	2026-04-22 15:56:29.528636+00
9	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	be618b84-342d-454e-844d-fef4c2970891	9fd30f54-d01c-45c9-8f22-f3b01905e6db	1	b5d23981-469b-4353-a615-9e4d6c8d8daf	\N	\N	5	2	t	2026-03-21 16:02:26.100668+00	\N	\N		\N	2026-04-12 19:15:06.091539+00
23	3cfb1829-52c0-44ff-adf5-e030ca38331b	OCTAVOS	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	\N	\N	4f008550-7b28-4437-923b-3438f4aed317	\N	\N	5	0	t	2026-03-21 16:02:26.246616+00	13	14	\N	\N	2026-04-18 14:13:37.667137+00
8	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	943a493d-044c-4c88-babc-e64804553bb4	deb6e026-258f-4f1d-b27a-35b8a307b8e0	2	2549f3dd-74dd-473b-be44-d5983b70e1ba	743b87bc-a47f-471c-b4b0-52c9765548ae	3	5	0	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-13 06:28:45.489796+00
77	b8da2430-6d1b-4732-bc62-790d55537a87	SEMIS IDA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:38:39.021249+00	73	74	\N	\N	2026-04-27 07:38:39.021249+00
7	3cfb1829-52c0-44ff-adf5-e030ca38331b	DIECISEISAVOS	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	deb6e026-258f-4f1d-b27a-35b8a307b8e0	1	1459c5f5-7c55-4f8c-86a0-f049234706a1	\N	\N	1	0	t	2026-03-21 16:02:26.100668+00	\N	\N	\N	\N	2026-04-13 08:37:35.203254+00
26	3cfb1829-52c0-44ff-adf5-e030ca38331b	CUARTOS	e92aa512-c44f-48c8-b983-7c7705e36a6f	\N	\N	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	\N	\N	0	2	t	2026-03-21 16:02:26.353118+00	19	20		\N	2026-04-18 17:46:04.576554+00
20	3cfb1829-52c0-44ff-adf5-e030ca38331b	OCTAVOS	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	\N	\N	943a493d-044c-4c88-babc-e64804553bb4	\N	\N	5	1	t	2026-03-21 16:02:26.246616+00	7	8		\N	2026-04-13 18:49:42.914724+00
78	b8da2430-6d1b-4732-bc62-790d55537a87	SEMIS VUELTA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:38:39.021249+00	74	73	\N	\N	2026-04-27 07:38:39.021249+00
21	3cfb1829-52c0-44ff-adf5-e030ca38331b	OCTAVOS	be618b84-342d-454e-844d-fef4c2970891	\N	\N	0e9bdb55-a555-467d-995a-62d64ab8a509	\N	\N	5	6	t	2026-03-21 16:02:26.246616+00	9	10		\N	2026-04-13 20:02:38.795812+00
71	59b65dd8-3c59-4576-b744-6b2765c73eb6	SEMIS VUELTA	f1932726-f713-4b61-8650-bf04f45d5b09	2a87fa59-2970-4a32-a7f2-86f32d3c3352	3	ec1c03bd-6b21-4574-aff7-39deac5e25bf	2a87fa59-2970-4a32-a7f2-86f32d3c3352	2	0	5	t	2026-03-27 13:53:20.434446+00	\N	\N	\N	\N	2026-04-23 16:43:52.530307+00
18	3cfb1829-52c0-44ff-adf5-e030ca38331b	OCTAVOS	449ee91c-f52f-4661-abd4-ebfd556c37c3	\N	\N	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	5	1	t	2026-03-21 16:02:26.246616+00	3	4	https://www.twitch.tv/videos/2747786133	\N	2026-04-14 11:04:53.246959+00
91	4f2ec4ba-8989-4a4a-922d-e59f969de4af	CUARTOS	\N	5c4028c5-ca8d-43a8-a35f-5581d060edb8	1	\N	06895b18-d72e-4f4b-8622-9d5b1167e05d	2	\N	\N	f	2026-04-27 07:43:38.762681+00	\N	\N	\N	\N	2026-04-27 07:43:38.762681+00
30	3cfb1829-52c0-44ff-adf5-e030ca38331b	SEMIS	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	4408336b-259c-437a-9f78-c4a664506756	\N	\N	3	5	t	2026-03-21 16:02:26.448846+00	27	28		\N	2026-04-24 21:14:37.124449+00
79	b8da2430-6d1b-4732-bc62-790d55537a87	SEMIS IDA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:38:39.021249+00	75	76	\N	\N	2026-04-27 07:38:39.021249+00
80	b8da2430-6d1b-4732-bc62-790d55537a87	SEMIS VUELTA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:38:39.021249+00	76	75	\N	\N	2026-04-27 07:38:39.021249+00
81	b8da2430-6d1b-4732-bc62-790d55537a87	FINAL	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:38:39.094025+00	77	79	\N	\N	2026-04-27 07:38:39.094025+00
82	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	CUARTOS	\N	1d5ef9fc-cf8a-44e7-922d-8579e268846a	1	\N	e05acde3-be06-4826-a33f-759da29282a6	2	\N	\N	f	2026-04-27 07:41:08.876118+00	\N	\N	\N	\N	2026-04-27 07:41:08.876118+00
22	3cfb1829-52c0-44ff-adf5-e030ca38331b	OCTAVOS	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	00872e2b-9e9c-442f-810c-bfd62ee8a524	\N	\N	4	0	t	2026-03-21 16:02:26.246616+00	11	12	\N	\N	2026-04-19 10:49:39.659858+00
83	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	CUARTOS	\N	e05acde3-be06-4826-a33f-759da29282a6	1	\N	1d5ef9fc-cf8a-44e7-922d-8579e268846a	2	\N	\N	f	2026-04-27 07:41:08.876118+00	\N	\N	\N	\N	2026-04-27 07:41:08.876118+00
70	59b65dd8-3c59-4576-b744-6b2765c73eb6	SEMIS IDA	ec1c03bd-6b21-4574-aff7-39deac5e25bf	2a87fa59-2970-4a32-a7f2-86f32d3c3352	2	f1932726-f713-4b61-8650-bf04f45d5b09	2a87fa59-2970-4a32-a7f2-86f32d3c3352	3	1	0	t	2026-03-27 13:53:20.434446+00	\N	\N		\N	2026-04-19 19:43:03.496828+00
31	3cfb1829-52c0-44ff-adf5-e030ca38331b	FINAL	449ee91c-f52f-4661-abd4-ebfd556c37c3	\N	\N	4408336b-259c-437a-9f78-c4a664506756	\N	\N	2	7	t	2026-03-21 16:02:26.54296+00	29	30	https://www.twitch.tv/felixrg1703	\N	2026-04-26 14:17:36.108183+00
84	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	CUARTOS	\N	b4a6f022-dded-4f45-9c88-a0fc1cd066ab	1	\N	31f18934-83a1-4a32-8a4d-f53428d4f0fb	2	\N	\N	f	2026-04-27 07:41:08.876118+00	\N	\N	\N	\N	2026-04-27 07:41:08.876118+00
85	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	CUARTOS	\N	31f18934-83a1-4a32-8a4d-f53428d4f0fb	1	\N	b4a6f022-dded-4f45-9c88-a0fc1cd066ab	2	\N	\N	f	2026-04-27 07:41:08.876118+00	\N	\N	\N	\N	2026-04-27 07:41:08.876118+00
86	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	SEMIS IDA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:41:08.958974+00	82	83	\N	\N	2026-04-27 07:41:08.958974+00
87	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	SEMIS VUELTA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:41:08.958974+00	83	82	\N	\N	2026-04-27 07:41:08.958974+00
88	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	SEMIS IDA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:41:08.958974+00	84	85	\N	\N	2026-04-27 07:41:08.958974+00
89	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	SEMIS VUELTA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:41:08.958974+00	85	84	\N	\N	2026-04-27 07:41:08.958974+00
90	f754ab0c-b7f2-4c0a-be4e-60856d5fd169	FINAL	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:41:09.039564+00	86	88	\N	\N	2026-04-27 07:41:09.039564+00
92	4f2ec4ba-8989-4a4a-922d-e59f969de4af	CUARTOS	\N	06895b18-d72e-4f4b-8622-9d5b1167e05d	1	\N	5c4028c5-ca8d-43a8-a35f-5581d060edb8	2	\N	\N	f	2026-04-27 07:43:38.762681+00	\N	\N	\N	\N	2026-04-27 07:43:38.762681+00
93	4f2ec4ba-8989-4a4a-922d-e59f969de4af	CUARTOS	\N	febafa6b-bfeb-4aaf-8540-686233c7cf02	1	\N	cb79f1a5-82d0-4e8b-87eb-d3446f9ac7f6	2	\N	\N	f	2026-04-27 07:43:38.762681+00	\N	\N	\N	\N	2026-04-27 07:43:38.762681+00
94	4f2ec4ba-8989-4a4a-922d-e59f969de4af	CUARTOS	\N	cb79f1a5-82d0-4e8b-87eb-d3446f9ac7f6	1	\N	febafa6b-bfeb-4aaf-8540-686233c7cf02	2	\N	\N	f	2026-04-27 07:43:38.762681+00	\N	\N	\N	\N	2026-04-27 07:43:38.762681+00
95	4f2ec4ba-8989-4a4a-922d-e59f969de4af	SEMIS IDA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:43:38.895657+00	91	92	\N	\N	2026-04-27 07:43:38.895657+00
96	4f2ec4ba-8989-4a4a-922d-e59f969de4af	SEMIS VUELTA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:43:38.895657+00	92	91	\N	\N	2026-04-27 07:43:38.895657+00
97	4f2ec4ba-8989-4a4a-922d-e59f969de4af	SEMIS IDA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:43:38.895657+00	93	94	\N	\N	2026-04-27 07:43:38.895657+00
98	4f2ec4ba-8989-4a4a-922d-e59f969de4af	SEMIS VUELTA	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:43:38.895657+00	94	93	\N	\N	2026-04-27 07:43:38.895657+00
99	4f2ec4ba-8989-4a4a-922d-e59f969de4af	FINAL	\N	\N	\N	\N	\N	\N	\N	\N	f	2026-04-27 07:43:39.031101+00	95	97	\N	\N	2026-04-27 07:43:39.031101+00
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
6	https://www.twitch.tv/videos/2726198609	2026-03-19 09:31:39.388+00
36	https://www.twitch.tv/games__wtf	2026-03-19 21:01:44.018975+00
39	https://www.twitch.tv/videos/2729856248?tt_content=vod&tt_medium=mobile_web_share	2026-03-23 17:21:46.635+00
9	https://www.twitch.tv/videos/2730030820	2026-03-23 21:05:57.161+00
11	https://www.twitch.tv/donptrsquad?sr=a	2026-03-24 17:22:08.581+00
14	https://www.twitch.tv/mistermacson2	2026-03-28 11:16:41.720097+00
43	https://www.twitch.tv/videos/2737115208	2026-04-01 11:37:42.051+00
40	https://www.twitch.tv/videos/2737918922	2026-04-02 10:35:42.988+00
16	https://www.twitch.tv/donptrsquad?sr=a	2026-04-05 20:56:04.49+00
46	https://www.twitch.tv/videos/2743638369	2026-04-09 08:46:20.87+00
49	https://www.twitch.tv/videos/2750256727	2026-04-17 14:30:46.963+00
23	https://www.twitch.tv/donptrsquad?sr=a	2026-04-17 20:28:12.124+00
19	https://www.twitch.tv/mistermacson	2026-04-19 10:48:57.832+00
28	https://www.twitch.tv/mistermacson	2026-04-21 18:05:33.079915+00
26	https://www.twitch.tv/donptrsquad?sr=a	2026-04-22 20:19:23.915+00
\.


--
-- Data for Name: matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matches (id, home_team, away_team, home_score, away_score, week, is_played, created_at, season, division, updated_at) FROM stdin;
29	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	2549f3dd-74dd-473b-be44-d5983b70e1ba	7	4	1	t	2026-03-05 09:55:52.787837+00	1	2	2026-03-27 13:17:08.277431+00
24	ff1dccb8-00bc-4042-a869-3a55773f3701	c06aa55d-9cd6-4f14-8d85-6c5739913994	0	3	6	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-31 08:38:22.723055+00
31	00872e2b-9e9c-442f-810c-bfd62ee8a524	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	6	3	1	t	2026-03-05 09:55:52.787837+00	1	2	2026-03-27 13:17:08.277431+00
18	45ef0325-e165-4aef-8836-03099f1d7bd9	16f4402c-a1b5-4431-8d98-c454f52a6284	5	5	5	t	2026-03-05 09:55:52.787837+00	1	1	2026-04-10 23:14:48.703171+00
1	2f58705a-25ad-42c9-b953-5137532b3584	8c1c7bba-636d-42f2-820a-ac1131897e84	4	1	1	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-27 13:17:08.277431+00
41	9d852873-3b29-4018-adde-c6244679e312	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	2	3	4	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-01 15:25:56.66017+00
56	9d852873-3b29-4018-adde-c6244679e312	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	5	2	7	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-20 18:36:43.551855+00
8	943a493d-044c-4c88-babc-e64804553bb4	16f4402c-a1b5-4431-8d98-c454f52a6284	1	4	2	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-27 13:17:08.277431+00
52	449ee91c-f52f-4661-abd4-ebfd556c37c3	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	5	2	6	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-14 16:32:22.508876+00
57	449ee91c-f52f-4661-abd4-ebfd556c37c3	4408336b-259c-437a-9f78-c4a664506756	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
27	943a493d-044c-4c88-babc-e64804553bb4	ff1dccb8-00bc-4042-a869-3a55773f3701	3	0	7	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-31 08:38:30.294496+00
51	2549f3dd-74dd-473b-be44-d5983b70e1ba	9d852873-3b29-4018-adde-c6244679e312	5	5	6	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-16 09:40:30.037178+00
28	45ef0325-e165-4aef-8836-03099f1d7bd9	c06aa55d-9cd6-4f14-8d85-6c5739913994	6	3	7	t	2026-03-05 09:55:52.787837+00	1	1	2026-04-21 18:05:32.821938+00
39	2549f3dd-74dd-473b-be44-d5983b70e1ba	c96625ad-9941-423c-8b5a-6fdc1b54ac20	4	4	3	t	2026-03-05 09:55:52.787837+00	1	2	2026-03-27 13:17:08.277431+00
21	16f4402c-a1b5-4431-8d98-c454f52a6284	2f58705a-25ad-42c9-b953-5137532b3584	4	3	6	t	2026-03-05 09:55:52.787837+00	1	1	2026-04-16 23:08:45.964151+00
2	b5d23981-469b-4353-a615-9e4d6c8d8daf	ff1dccb8-00bc-4042-a869-3a55773f3701	3	1	1	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-27 13:17:08.277431+00
58	9d852873-3b29-4018-adde-c6244679e312	10920fad-ebd2-4be2-8e82-4604204f6139	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
49	00872e2b-9e9c-442f-810c-bfd62ee8a524	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	4	7	6	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-17 14:30:45.674622+00
53	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	7d59efea-fc42-4117-a34b-3937905456db	5	2	7	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-22 19:48:17.033331+00
26	16f4402c-a1b5-4431-8d98-c454f52a6284	8c1c7bba-636d-42f2-820a-ac1131897e84	5	3	7	t	2026-03-05 09:55:52.787837+00	1	1	2026-04-22 20:19:24.221516+00
59	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
3	16f4402c-a1b5-4431-8d98-c454f52a6284	c06aa55d-9cd6-4f14-8d85-6c5739913994	4	3	1	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-27 13:17:08.277431+00
9	2f58705a-25ad-42c9-b953-5137532b3584	c06aa55d-9cd6-4f14-8d85-6c5739913994	2	4	3	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-27 13:17:08.277431+00
5	ff1dccb8-00bc-4042-a869-3a55773f3701	2f58705a-25ad-42c9-b953-5137532b3584	2	5	2	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-27 13:17:08.277431+00
54	00872e2b-9e9c-442f-810c-bfd62ee8a524	2549f3dd-74dd-473b-be44-d5983b70e1ba	0	3	7	f	2026-03-05 09:55:52.787837+00	1	2	2026-04-23 12:51:09.291725+00
11	8c1c7bba-636d-42f2-820a-ac1131897e84	943a493d-044c-4c88-babc-e64804553bb4	6	3	3	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-27 13:17:08.277431+00
6	c06aa55d-9cd6-4f14-8d85-6c5739913994	8c1c7bba-636d-42f2-820a-ac1131897e84	4	3	2	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-27 13:17:08.277431+00
34	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	2549f3dd-74dd-473b-be44-d5983b70e1ba	2	5	2	t	2026-03-05 09:55:52.787837+00	1	2	2026-03-27 13:17:08.277431+00
33	449ee91c-f52f-4661-abd4-ebfd556c37c3	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	3	4	2	t	2026-03-05 09:55:52.787837+00	1	2	2026-03-27 13:17:08.277431+00
37	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	6	3	3	t	2026-03-05 09:55:52.787837+00	1	2	2026-03-27 13:17:08.277431+00
36	c96625ad-9941-423c-8b5a-6fdc1b54ac20	00872e2b-9e9c-442f-810c-bfd62ee8a524	6	3	2	t	2026-03-05 09:55:52.787837+00	1	2	2026-03-27 13:17:08.277431+00
14	943a493d-044c-4c88-babc-e64804553bb4	c06aa55d-9cd6-4f14-8d85-6c5739913994	3	6	4	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-28 11:16:41.614131+00
4	943a493d-044c-4c88-babc-e64804553bb4	45ef0325-e165-4aef-8836-03099f1d7bd9	0	3	1	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-29 12:20:38.087193+00
7	45ef0325-e165-4aef-8836-03099f1d7bd9	b5d23981-469b-4353-a615-9e4d6c8d8daf	5	2	2	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-29 17:10:20.355233+00
12	b5d23981-469b-4353-a615-9e4d6c8d8daf	16f4402c-a1b5-4431-8d98-c454f52a6284	1	4	3	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-29 22:37:56.627292+00
22	b5d23981-469b-4353-a615-9e4d6c8d8daf	943a493d-044c-4c88-babc-e64804553bb4	0	0	6	t	2026-03-05 09:55:52.787837+00	1	1	2026-04-24 14:19:25.195154+00
13	45ef0325-e165-4aef-8836-03099f1d7bd9	2f58705a-25ad-42c9-b953-5137532b3584	4	1	4	t	2026-03-05 09:55:52.787837+00	1	1	2026-04-03 20:00:44.358268+00
10	ff1dccb8-00bc-4042-a869-3a55773f3701	45ef0325-e165-4aef-8836-03099f1d7bd9	1	4	3	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-30 20:57:34.722997+00
15	16f4402c-a1b5-4431-8d98-c454f52a6284	ff1dccb8-00bc-4042-a869-3a55773f3701	3	0	4	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-31 08:37:18.101569+00
20	ff1dccb8-00bc-4042-a869-3a55773f3701	8c1c7bba-636d-42f2-820a-ac1131897e84	0	3	5	t	2026-03-05 09:55:52.787837+00	1	1	2026-03-31 08:38:15.424284+00
50	7d59efea-fc42-4117-a34b-3937905456db	c96625ad-9941-423c-8b5a-6fdc1b54ac20	5	7	6	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-24 15:09:26.708206+00
42	c96625ad-9941-423c-8b5a-6fdc1b54ac20	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	5	2	4	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-03 20:38:32.965917+00
43	00872e2b-9e9c-442f-810c-bfd62ee8a524	449ee91c-f52f-4661-abd4-ebfd556c37c3	2	5	4	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-01 11:37:38.804746+00
23	8c1c7bba-636d-42f2-820a-ac1131897e84	45ef0325-e165-4aef-8836-03099f1d7bd9	1	4	6	t	2026-03-05 09:55:52.787837+00	1	1	2026-04-17 20:28:12.149427+00
19	c06aa55d-9cd6-4f14-8d85-6c5739913994	b5d23981-469b-4353-a615-9e4d6c8d8daf	6	3	5	t	2026-03-05 09:55:52.787837+00	1	1	2026-04-19 10:48:57.901492+00
60	45ef0325-e165-4aef-8836-03099f1d7bd9	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
55	c96625ad-9941-423c-8b5a-6fdc1b54ac20	449ee91c-f52f-4661-abd4-ebfd556c37c3	1	4	7	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-19 13:20:27.30549+00
40	7d59efea-fc42-4117-a34b-3937905456db	00872e2b-9e9c-442f-810c-bfd62ee8a524	7	5	3	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-20 08:31:38.048697+00
47	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	7d59efea-fc42-4117-a34b-3937905456db	3	5	5	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-24 15:48:28.541521+00
32	c96625ad-9941-423c-8b5a-6fdc1b54ac20	9d852873-3b29-4018-adde-c6244679e312	3	6	1	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-01 11:48:59.457342+00
16	b5d23981-469b-4353-a615-9e4d6c8d8daf	8c1c7bba-636d-42f2-820a-ac1131897e84	3	0	4	t	2026-03-05 09:55:52.787837+00	1	1	2026-04-05 20:56:03.973264+00
38	449ee91c-f52f-4661-abd4-ebfd556c37c3	9d852873-3b29-4018-adde-c6244679e312	5	3	3	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-06 17:17:37.384429+00
25	2f58705a-25ad-42c9-b953-5137532b3584	b5d23981-469b-4353-a615-9e4d6c8d8daf	0	0	7	f	2026-03-05 09:55:52.787837+00	1	1	2026-04-27 07:28:07.684845+00
48	449ee91c-f52f-4661-abd4-ebfd556c37c3	2549f3dd-74dd-473b-be44-d5983b70e1ba	7	7	5	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-06 17:52:19.245702+00
17	2f58705a-25ad-42c9-b953-5137532b3584	943a493d-044c-4c88-babc-e64804553bb4	5	4	5	t	2026-03-05 09:55:52.787837+00	1	1	2026-04-08 19:51:03.114362+00
46	9d852873-3b29-4018-adde-c6244679e312	00872e2b-9e9c-442f-810c-bfd62ee8a524	4	1	5	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-09 08:46:20.352956+00
61	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	be618b84-342d-454e-844d-fef4c2970891	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
45	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	c96625ad-9941-423c-8b5a-6fdc1b54ac20	6	3	5	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-10 14:16:11.872039+00
30	7d59efea-fc42-4117-a34b-3937905456db	449ee91c-f52f-4661-abd4-ebfd556c37c3	1	4	1	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-20 08:31:38.048697+00
62	10920fad-ebd2-4be2-8e82-4604204f6139	449ee91c-f52f-4661-abd4-ebfd556c37c3	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
63	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	4408336b-259c-437a-9f78-c4a664506756	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
64	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	9d852873-3b29-4018-adde-c6244679e312	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
35	9d852873-3b29-4018-adde-c6244679e312	7d59efea-fc42-4117-a34b-3937905456db	6	3	2	t	2026-03-05 09:55:52.787837+00	1	2	2026-04-20 08:31:38.420863+00
44	7d59efea-fc42-4117-a34b-3937905456db	2549f3dd-74dd-473b-be44-d5983b70e1ba	0	0	4	f	2026-03-05 09:55:52.787837+00	1	2	2026-04-27 07:28:37.285594+00
65	be618b84-342d-454e-844d-fef4c2970891	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
66	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
67	449ee91c-f52f-4661-abd4-ebfd556c37c3	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
68	10920fad-ebd2-4be2-8e82-4604204f6139	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
69	4408336b-259c-437a-9f78-c4a664506756	be618b84-342d-454e-844d-fef4c2970891	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
70	9d852873-3b29-4018-adde-c6244679e312	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
71	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
72	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	449ee91c-f52f-4661-abd4-ebfd556c37c3	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
73	be618b84-342d-454e-844d-fef4c2970891	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
74	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	10920fad-ebd2-4be2-8e82-4604204f6139	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
75	45ef0325-e165-4aef-8836-03099f1d7bd9	4408336b-259c-437a-9f78-c4a664506756	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
76	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	9d852873-3b29-4018-adde-c6244679e312	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
77	449ee91c-f52f-4661-abd4-ebfd556c37c3	be618b84-342d-454e-844d-fef4c2970891	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
78	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
79	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
80	10920fad-ebd2-4be2-8e82-4604204f6139	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
81	4408336b-259c-437a-9f78-c4a664506756	9d852873-3b29-4018-adde-c6244679e312	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
82	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	449ee91c-f52f-4661-abd4-ebfd556c37c3	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
83	45ef0325-e165-4aef-8836-03099f1d7bd9	be618b84-342d-454e-844d-fef4c2970891	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
84	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
85	9d852873-3b29-4018-adde-c6244679e312	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
86	4408336b-259c-437a-9f78-c4a664506756	10920fad-ebd2-4be2-8e82-4604204f6139	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
87	449ee91c-f52f-4661-abd4-ebfd556c37c3	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
88	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
89	be618b84-342d-454e-844d-fef4c2970891	9d852873-3b29-4018-adde-c6244679e312	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
90	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	4408336b-259c-437a-9f78-c4a664506756	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
91	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	10920fad-ebd2-4be2-8e82-4604204f6139	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
92	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	449ee91c-f52f-4661-abd4-ebfd556c37c3	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
93	9d852873-3b29-4018-adde-c6244679e312	45ef0325-e165-4aef-8836-03099f1d7bd9	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
94	4408336b-259c-437a-9f78-c4a664506756	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
95	10920fad-ebd2-4be2-8e82-4604204f6139	be618b84-342d-454e-844d-fef4c2970891	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
96	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
97	449ee91c-f52f-4661-abd4-ebfd556c37c3	9d852873-3b29-4018-adde-c6244679e312	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
98	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	4408336b-259c-437a-9f78-c4a664506756	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
99	45ef0325-e165-4aef-8836-03099f1d7bd9	10920fad-ebd2-4be2-8e82-4604204f6139	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
100	74d1cfe5-421b-4be6-a055-0b7693ff2f1c	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
101	be618b84-342d-454e-844d-fef4c2970891	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	1	2026-04-27 07:32:13.506492+00
102	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	16f4402c-a1b5-4431-8d98-c454f52a6284	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
103	ec1c03bd-6b21-4574-aff7-39deac5e25bf	1459c5f5-7c55-4f8c-86a0-f049234706a1	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
104	c06aa55d-9cd6-4f14-8d85-6c5739913994	e92aa512-c44f-48c8-b983-7c7705e36a6f	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
105	2f58705a-25ad-42c9-b953-5137532b3584	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
106	2549f3dd-74dd-473b-be44-d5983b70e1ba	8c1c7bba-636d-42f2-820a-ac1131897e84	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
107	1459c5f5-7c55-4f8c-86a0-f049234706a1	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
108	e92aa512-c44f-48c8-b983-7c7705e36a6f	16f4402c-a1b5-4431-8d98-c454f52a6284	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
109	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	ec1c03bd-6b21-4574-aff7-39deac5e25bf	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
110	8c1c7bba-636d-42f2-820a-ac1131897e84	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
111	2549f3dd-74dd-473b-be44-d5983b70e1ba	2f58705a-25ad-42c9-b953-5137532b3584	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
112	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	e92aa512-c44f-48c8-b983-7c7705e36a6f	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
113	1459c5f5-7c55-4f8c-86a0-f049234706a1	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
114	16f4402c-a1b5-4431-8d98-c454f52a6284	8c1c7bba-636d-42f2-820a-ac1131897e84	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
115	ec1c03bd-6b21-4574-aff7-39deac5e25bf	2549f3dd-74dd-473b-be44-d5983b70e1ba	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
116	c06aa55d-9cd6-4f14-8d85-6c5739913994	2f58705a-25ad-42c9-b953-5137532b3584	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
117	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
118	8c1c7bba-636d-42f2-820a-ac1131897e84	e92aa512-c44f-48c8-b983-7c7705e36a6f	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
119	2549f3dd-74dd-473b-be44-d5983b70e1ba	1459c5f5-7c55-4f8c-86a0-f049234706a1	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
120	2f58705a-25ad-42c9-b953-5137532b3584	16f4402c-a1b5-4431-8d98-c454f52a6284	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
121	c06aa55d-9cd6-4f14-8d85-6c5739913994	ec1c03bd-6b21-4574-aff7-39deac5e25bf	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
122	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	8c1c7bba-636d-42f2-820a-ac1131897e84	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
123	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	2549f3dd-74dd-473b-be44-d5983b70e1ba	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
124	e92aa512-c44f-48c8-b983-7c7705e36a6f	2f58705a-25ad-42c9-b953-5137532b3584	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
125	1459c5f5-7c55-4f8c-86a0-f049234706a1	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
126	16f4402c-a1b5-4431-8d98-c454f52a6284	ec1c03bd-6b21-4574-aff7-39deac5e25bf	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
127	2549f3dd-74dd-473b-be44-d5983b70e1ba	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
128	2f58705a-25ad-42c9-b953-5137532b3584	8c1c7bba-636d-42f2-820a-ac1131897e84	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
129	c06aa55d-9cd6-4f14-8d85-6c5739913994	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
130	ec1c03bd-6b21-4574-aff7-39deac5e25bf	e92aa512-c44f-48c8-b983-7c7705e36a6f	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
131	16f4402c-a1b5-4431-8d98-c454f52a6284	1459c5f5-7c55-4f8c-86a0-f049234706a1	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
132	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	2f58705a-25ad-42c9-b953-5137532b3584	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
133	2549f3dd-74dd-473b-be44-d5983b70e1ba	c06aa55d-9cd6-4f14-8d85-6c5739913994	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
134	8c1c7bba-636d-42f2-820a-ac1131897e84	ec1c03bd-6b21-4574-aff7-39deac5e25bf	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
135	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	16f4402c-a1b5-4431-8d98-c454f52a6284	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
136	e92aa512-c44f-48c8-b983-7c7705e36a6f	1459c5f5-7c55-4f8c-86a0-f049234706a1	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
137	c06aa55d-9cd6-4f14-8d85-6c5739913994	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
138	ec1c03bd-6b21-4574-aff7-39deac5e25bf	2f58705a-25ad-42c9-b953-5137532b3584	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
139	16f4402c-a1b5-4431-8d98-c454f52a6284	2549f3dd-74dd-473b-be44-d5983b70e1ba	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
140	1459c5f5-7c55-4f8c-86a0-f049234706a1	8c1c7bba-636d-42f2-820a-ac1131897e84	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
141	e92aa512-c44f-48c8-b983-7c7705e36a6f	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
142	81a8640c-85be-4c54-9e36-9a5ac9c98e4a	ec1c03bd-6b21-4574-aff7-39deac5e25bf	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
143	c06aa55d-9cd6-4f14-8d85-6c5739913994	16f4402c-a1b5-4431-8d98-c454f52a6284	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
144	2f58705a-25ad-42c9-b953-5137532b3584	1459c5f5-7c55-4f8c-86a0-f049234706a1	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
145	2549f3dd-74dd-473b-be44-d5983b70e1ba	e92aa512-c44f-48c8-b983-7c7705e36a6f	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
146	8c1c7bba-636d-42f2-820a-ac1131897e84	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	2	2026-04-27 07:32:13.506492+00
147	0e9bdb55-a555-467d-995a-62d64ab8a509	7d59efea-fc42-4117-a34b-3937905456db	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
148	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	e804e0cf-72af-449e-9816-46518b271b84	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
149	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	ff1dccb8-00bc-4042-a869-3a55773f3701	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
150	943a493d-044c-4c88-babc-e64804553bb4	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
151	b5d23981-469b-4353-a615-9e4d6c8d8daf	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	\N	\N	1	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
152	e804e0cf-72af-449e-9816-46518b271b84	0e9bdb55-a555-467d-995a-62d64ab8a509	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
153	ff1dccb8-00bc-4042-a869-3a55773f3701	7d59efea-fc42-4117-a34b-3937905456db	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
154	c96625ad-9941-423c-8b5a-6fdc1b54ac20	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
155	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
156	b5d23981-469b-4353-a615-9e4d6c8d8daf	943a493d-044c-4c88-babc-e64804553bb4	\N	\N	2	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
157	0e9bdb55-a555-467d-995a-62d64ab8a509	ff1dccb8-00bc-4042-a869-3a55773f3701	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
158	e804e0cf-72af-449e-9816-46518b271b84	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
159	7d59efea-fc42-4117-a34b-3937905456db	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
160	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	b5d23981-469b-4353-a615-9e4d6c8d8daf	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
161	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	943a493d-044c-4c88-babc-e64804553bb4	\N	\N	3	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
162	c96625ad-9941-423c-8b5a-6fdc1b54ac20	0e9bdb55-a555-467d-995a-62d64ab8a509	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
163	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	ff1dccb8-00bc-4042-a869-3a55773f3701	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
164	b5d23981-469b-4353-a615-9e4d6c8d8daf	e804e0cf-72af-449e-9816-46518b271b84	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
165	943a493d-044c-4c88-babc-e64804553bb4	7d59efea-fc42-4117-a34b-3937905456db	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
166	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	\N	\N	4	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
167	0e9bdb55-a555-467d-995a-62d64ab8a509	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
168	c96625ad-9941-423c-8b5a-6fdc1b54ac20	b5d23981-469b-4353-a615-9e4d6c8d8daf	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
169	ff1dccb8-00bc-4042-a869-3a55773f3701	943a493d-044c-4c88-babc-e64804553bb4	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
170	e804e0cf-72af-449e-9816-46518b271b84	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
171	7d59efea-fc42-4117-a34b-3937905456db	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	\N	\N	5	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
172	b5d23981-469b-4353-a615-9e4d6c8d8daf	0e9bdb55-a555-467d-995a-62d64ab8a509	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
173	943a493d-044c-4c88-babc-e64804553bb4	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
174	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
175	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	ff1dccb8-00bc-4042-a869-3a55773f3701	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
176	7d59efea-fc42-4117-a34b-3937905456db	e804e0cf-72af-449e-9816-46518b271b84	\N	\N	6	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
177	0e9bdb55-a555-467d-995a-62d64ab8a509	943a493d-044c-4c88-babc-e64804553bb4	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
178	b5d23981-469b-4353-a615-9e4d6c8d8daf	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
179	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
180	c96625ad-9941-423c-8b5a-6fdc1b54ac20	7d59efea-fc42-4117-a34b-3937905456db	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
181	ff1dccb8-00bc-4042-a869-3a55773f3701	e804e0cf-72af-449e-9816-46518b271b84	\N	\N	7	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
182	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	0e9bdb55-a555-467d-995a-62d64ab8a509	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
183	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	943a493d-044c-4c88-babc-e64804553bb4	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
184	7d59efea-fc42-4117-a34b-3937905456db	b5d23981-469b-4353-a615-9e4d6c8d8daf	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
185	e804e0cf-72af-449e-9816-46518b271b84	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
186	ff1dccb8-00bc-4042-a869-3a55773f3701	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	8	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
187	0e9bdb55-a555-467d-995a-62d64ab8a509	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
188	eae8c25a-a99d-480f-8e3e-854d36c5c8dc	7d59efea-fc42-4117-a34b-3937905456db	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
189	943a493d-044c-4c88-babc-e64804553bb4	e804e0cf-72af-449e-9816-46518b271b84	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
190	b5d23981-469b-4353-a615-9e4d6c8d8daf	ff1dccb8-00bc-4042-a869-3a55773f3701	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
191	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	c96625ad-9941-423c-8b5a-6fdc1b54ac20	\N	\N	9	f	2026-04-27 07:32:13.506492+00	2	3	2026-04-27 07:32:13.506492+00
\.


--
-- Data for Name: matches_rescheduled; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matches_rescheduled (id, match_id, match_id_uid, tipo_partido, player1_id, player2_id, fecha_inicio, fecha_fin, created_at) FROM stdin;
\.


--
-- Data for Name: notificaciones_enviadas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notificaciones_enviadas (id, created_at) FROM stdin;
Acrazunmelliot1990j3 Europa League2026-04-14T22:00:00.000Z	2026-04-13 15:20:35.170513+00
melliot1990Acrazunj3 Europa League2026-04-14T22:00:00.000Z	2026-04-13 15:20:41.928258+00
Juanka13GamesAcrazunj2 Europa League2026-04-14T22:00:00.000Z	2026-04-13 15:20:48.690249+00
AcrazunJuanka13Gamesj2 Europa League2026-04-14T22:00:00.000Z	2026-04-13 15:20:54.514857+00
payomalo89Acrazunj1 Europa League2026-04-14T22:00:00.000Z	2026-04-13 15:21:00.454116+00
Acrazunpayomalo89j1 Europa League2026-04-14T22:00:00.000Z	2026-04-13 15:21:06.210217+00
AdriWinsAngel_RicoDiv 12026-04-19T22:00:00+00:00	2026-04-17 09:56:37.86324+00
Angel_RicoAdriWinsDiv 12026-04-19T22:00:00+00:00	2026-04-17 09:56:44.704808+00
MELIODASthemule089Div 22026-04-19T22:00:00+00:00	2026-04-17 09:56:50.632869+00
themule089MELIODASDiv 22026-04-19T22:00:00+00:00	2026-04-17 09:56:56.450401+00
Don Ptr SquadChava_14Div 12026-04-19T22:00:00+00:00	2026-04-17 09:57:03.062086+00
Chava_14Don Ptr SquadDiv 12026-04-19T22:00:00+00:00	2026-04-17 09:57:08.968413+00
VityCanarioSharkDDiv 22026-04-19T22:00:00+00:00	2026-04-17 09:57:15.364426+00
SharkDVityCanarioDiv 22026-04-19T22:00:00+00:00	2026-04-17 09:57:21.251693+00
Mr.MacsonAdriWinsDiv 12026-04-19T22:00:00+00:00	2026-04-17 09:57:27.311825+00
AdriWinsMr.MacsonDiv 12026-04-19T22:00:00+00:00	2026-04-17 09:57:33.449345+00
VityCanarioFranchescoDiv 22026-04-19T22:00:00+00:00	2026-04-17 09:57:38.862067+00
FranchescoVityCanarioDiv 22026-04-19T22:00:00+00:00	2026-04-17 09:57:45.351634+00
JeybissVityCanarioDiv 22026-04-19T22:00:00+00:00	2026-04-17 09:57:51.260413+00
VityCanarioJeybissDiv 22026-04-19T22:00:00+00:00	2026-04-17 09:57:57.22697+00
Kapi_86L1amAiramOCTAVOS Champions2026-04-17T22:00:00.000Z	2026-04-17 09:58:03.051142+00
L1amAiramKapi_86OCTAVOS Champions2026-04-17T22:00:00.000Z	2026-04-17 09:58:09.691806+00
Chava_14MELIODASOCTAVOS Champions2026-04-17T22:00:00.000Z	2026-04-17 09:58:15.763163+00
MELIODASChava_14OCTAVOS Champions2026-04-17T22:00:00.000Z	2026-04-17 09:58:21.532795+00
Selu AdriWinsDiv 12026-04-26T22:00:00+00:00	2026-04-24 07:28:03.748948+00
AdriWinsSelu Div 12026-04-26T22:00:00+00:00	2026-04-24 07:28:12.00461+00
AdriWinsAngel_RicoDiv 12026-04-26T22:00:00+00:00	2026-04-24 07:36:18.258121+00
Angel_RicoAdriWinsDiv 12026-04-26T22:00:00+00:00	2026-04-24 07:36:26.103453+00
Sueldo analogoFranchescoDiv 22026-04-26T22:00:00+00:00	2026-04-24 07:36:33.891927+00
FranchescoSueldo analogoDiv 22026-04-26T22:00:00+00:00	2026-04-24 07:36:41.045513+00
Sueldo analogoSharkDDiv 22026-04-26T22:00:00+00:00	2026-04-24 07:36:48.156878+00
SharkDSueldo analogoDiv 22026-04-26T22:00:00+00:00	2026-04-24 07:36:56.019133+00
JeybissSueldo analogoDiv 22026-04-26T22:00:00+00:00	2026-04-24 07:37:03.895245+00
Sueldo analogoJeybissDiv 22026-04-26T22:00:00+00:00	2026-04-24 07:37:10.567786+00
Chava_14FelixRGSEMIS Champions2026-04-24T22:00:00.000Z	2026-04-24 07:37:17.84546+00
FelixRGChava_14SEMIS Champions2026-04-24T22:00:00.000Z	2026-04-24 07:37:25.717266+00
Juanka13GamesAcrazunFINAL Europa League2026-04-26T22:00:00.000Z	2026-04-24 07:37:33.008317+00
AcrazunJuanka13GamesFINAL Europa League2026-04-26T22:00:00.000Z	2026-04-24 07:37:40.822394+00
\.


--
-- Data for Name: playoff_matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.playoff_matches (id, playoff_id, round, match_order, home_team, away_team, home_score, away_score, winner_id, next_match_id, played, start_date, end_date, updated_at) FROM stdin;
\.


--
-- Data for Name: playoffs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.playoffs (id, created_at, name, season, is_active, settings, current_round, limit_ga_enabled, max_ga_playoff) FROM stdin;
\.


--
-- Data for Name: playoffs_extra; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.playoffs_extra (id, season_id, nombre, tipo_format, jugadores_por_grupo, estado, created_at, config_eliminatorias, config_fechas, num_grupos, pasan_por_grupo, current_round, use_auto_round, stream_puntos, limit_ga_enabled, max_ga_playoff) FROM stdin;
b8da2430-6d1b-4732-bc62-790d55537a87	2	Champions League	ida	4	activo	2026-04-27 07:38:37.945662+00	{"final": "ida", "semis": "ida_vuelta", "cuartos": "ida", "octavos": "ida", "dieciseisavos": "ida"}	{"j1": {"end_at": "2026-05-04T22:00:00.000Z", "start_at": "2026-04-27T22:00:00.000Z"}, "j2": {"end_at": "2026-05-11T22:00:00.000Z", "start_at": "2026-05-04T22:00:00.000Z"}, "j3": {"end_at": "2026-05-18T22:00:00.000Z", "start_at": "2026-05-11T22:00:00.000Z"}, "final": {"end_at": "2026-06-15T22:00:00.000Z", "start_at": "2026-06-08T22:00:00.000Z"}, "cuartos": {"end_at": "2026-05-25T22:00:00.000Z", "start_at": "2026-05-18T22:00:00.000Z"}, "semis_ida": {"end_at": "2026-06-01T22:00:00.000Z", "start_at": "2026-05-25T22:00:00.000Z"}, "semis_vuelta": {"end_at": "2026-06-08T22:00:00.000Z", "start_at": "2026-06-01T22:00:00.000Z"}}	4	2	j1	t	t	t	5
3cfb1829-52c0-44ff-adf5-e030ca38331b	1	Champions	ida	4	finalizado	2026-03-21 16:02:24.300916+00	{"final": "ida", "semis": "ida", "cuartos": "ida", "octavos": "ida", "dieciseisavos": "ida"}	{"j1": {"end_at": "2026-03-29T22:00:00.000Z", "start_at": "2026-03-22T23:00:00.000Z"}, "j2": {"end_at": "2026-04-07T19:00:00.000Z", "start_at": "2026-03-29T22:00:00.000Z"}, "j3": {"end_at": "2026-04-07T19:00:00.000Z", "start_at": "2026-03-29T22:00:00.000Z"}, "final": {"end_at": "2026-04-26T22:00:00.000Z", "start_at": "2026-04-24T22:00:00.000Z"}, "semis": {"end_at": "2026-04-24T22:00:00.000Z", "start_at": "2026-04-21T22:00:00.000Z"}, "cuartos": {"end_at": "2026-04-21T22:00:00.000Z", "start_at": "2026-04-17T22:00:00.000Z"}, "octavos": {"end_at": "2026-04-17T22:00:00.000Z", "start_at": "2026-04-12T22:00:00.000Z"}, "dieciseisavos": {"end_at": "2026-04-12T22:00:00.000Z", "start_at": "2026-04-07T19:00:00.000Z"}}	7	3	final	t	t	t	5
59b65dd8-3c59-4576-b744-6b2765c73eb6	1	Europa League	ida	4	finalizado	2026-03-27 13:53:19.997891+00	{"final": "ida", "semis": "ida_vuelta", "cuartos": "ida", "octavos": "ida", "dieciseisavos": "ida"}	{"j1": {"end_at": "2026-04-14T22:00:00.000Z", "start_at": "2026-04-05T22:00:00.000Z"}, "j2": {"end_at": "2026-04-14T22:00:00.000Z", "start_at": "2026-04-05T22:00:00.000Z"}, "j3": {"end_at": "2026-04-14T22:00:00.000Z", "start_at": "2026-04-05T22:00:00.000Z"}, "final": {"end_at": "2026-04-26T22:00:00.000Z", "start_at": "2026-04-23T22:00:00.000Z"}, "semis_ida": {"end_at": "2026-04-19T22:00:00.000Z", "start_at": "2026-04-14T22:00:00.000Z"}, "semis_vuelta": {"end_at": "2026-04-23T22:00:00.000Z", "start_at": "2026-04-19T22:00:00.000Z"}}	1	4	final	t	f	t	5
f754ab0c-b7f2-4c0a-be4e-60856d5fd169	2	Europa League	ida	4	activo	2026-04-27 07:41:08.00123+00	{"final": "ida", "semis": "ida_vuelta", "cuartos": "ida", "octavos": "ida", "dieciseisavos": "ida"}	{"j1": {"end_at": "2026-05-04T22:00:00.000Z", "start_at": "2026-04-27T22:00:00.000Z"}, "j2": {"end_at": "2026-05-11T22:00:00.000Z", "start_at": "2026-05-04T22:00:00.000Z"}, "j3": {"end_at": "2026-05-18T22:00:00.000Z", "start_at": "2026-05-11T22:00:00.000Z"}, "final": {"end_at": "2026-06-15T22:00:00.000Z", "start_at": "2026-06-08T22:00:00.000Z"}, "cuartos": {"end_at": "2026-05-25T22:00:00.000Z", "start_at": "2026-05-18T22:00:00.000Z"}, "semis_ida": {"end_at": "2026-06-01T22:00:00.000Z", "start_at": "2026-05-25T22:00:00.000Z"}, "semis_vuelta": {"end_at": "2026-06-08T22:00:00.000Z", "start_at": "2026-06-01T22:00:00.000Z"}}	4	2	j1	t	t	t	5
4f2ec4ba-8989-4a4a-922d-e59f969de4af	2	Copa del Rey	ida	4	activo	2026-04-27 07:43:36.252765+00	{"final": "ida", "semis": "ida_vuelta", "cuartos": "ida", "octavos": "ida", "dieciseisavos": "ida"}	{"j1": {"end_at": "2026-05-04T22:00:00.000Z", "start_at": "2026-04-27T22:00:00.000Z"}, "j2": {"end_at": "2026-05-11T22:00:00.000Z", "start_at": "2026-05-04T22:00:00.000Z"}, "j3": {"end_at": "2026-05-18T22:00:00.000Z", "start_at": "2026-05-11T22:00:00.000Z"}, "final": {"end_at": "2026-06-15T22:00:00.000Z", "start_at": "2026-06-08T22:00:00.000Z"}, "cuartos": {"end_at": "2026-05-25T22:00:00.000Z", "start_at": "2026-05-18T22:00:00.000Z"}, "semis_ida": {"end_at": "2026-06-01T22:00:00.000Z", "start_at": "2026-05-25T22:00:00.000Z"}, "semis_vuelta": {"end_at": "2026-06-08T22:00:00.000Z", "start_at": "2026-06-01T22:00:00.000Z"}}	4	2	j1	t	t	t	5
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.profiles (id, nick, email, avatar_url, is_confirmed, created_at, telegram_user, phone, is_admin, last_seen, is_colaborador, eafc_user) FROM stdin;
4f008550-7b28-4437-923b-3438f4aed317	Retirado (L1amAiram)	retirado_1776676009464@liga.com	\N	f	2026-03-19 11:47:53.522266+00	\N	\N	f	2026-04-12 18:28:10.226+00	f	\N
16f4402c-a1b5-4431-8d98-c454f52a6284	Iker	ikerxu1985@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/16f4402c-a1b5-4431-8d98-c454f52a6284.webp?t=1773441143926	f	2026-03-02 22:26:22.572768+00		+34619776212	f	2026-04-24 21:23:50.894+00	f	jaurewia
38f98f64-f2db-47bf-a5ea-dcd1804ce00a	themule089	david.cvega89@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/38f98f64-f2db-47bf-a5ea-dcd1804ce00a.webp?t=1774259496308	f	2026-03-01 09:34:43.210041+00		+34692675304	f	2026-04-27 08:16:48.447+00	f	themule0089
be618b84-342d-454e-844d-fef4c2970891	Davidsvo96	davidsvalencia.o1@gmail.com	\N	f	2026-03-20 12:40:01.16861+00	\N	+34641754657	f	2026-04-13 14:51:53.282+00	f	\N
00872e2b-9e9c-442f-810c-bfd62ee8a524	Retirado (MELIODAS)	retirado_1776767561644@liga.com	\N	f	2026-02-28 09:22:43.119146+00	\N	\N	f	2026-04-17 14:30:37.197+00	f	\N
2f58705a-25ad-42c9-b953-5137532b3584	Selu 	Jluisdiazmaroto@gmail.com	\N	f	2026-03-01 19:03:49.128611+00	\N	+34684218724	f	2026-04-21 18:01:25.263+00	f	\N
8c1c7bba-636d-42f2-820a-ac1131897e84	Don Ptr Squad	pedrorodriguezmoya83@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/8c1c7bba-636d-42f2-820a-ac1131897e84.webp?t=1772706351861	f	2026-02-28 11:22:16.409045+00	@donptrsquad	+34615475002	f	2026-04-27 08:20:12.66+00	f	\N
449ee91c-f52f-4661-abd4-ebfd556c37c3	Hukha	hukha221@gmail.com	\N	f	2026-02-25 11:50:01.84082+00	@JamesDevG	\N	f	2026-04-27 08:04:54.346+00	f	\N
31984a41-8b67-441c-abd6-2b3880940b87	Retirado (LlaveringL)	retirado_1776256180002@liga.com	\N	f	2026-03-19 13:35:47.385648+00	\N	\N	f	2026-04-09 14:14:57.625+00	f	\N
56f68d15-9c80-4b6a-9537-d8f5e8c1f021	GreekVE	efstathioski@gmail.com	\N	f	2026-04-15 19:27:47.248672+00	Efstathiosk	+34655234082	f	2026-04-24 22:14:51.836+00	f	\N
e804e0cf-72af-449e-9816-46518b271b84	Judas	daniel_moruno@hotmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/e804e0cf-72af-449e-9816-46518b271b84.webp?t=1777278142699	f	2026-04-21 11:41:07.151642+00	Daniele		f	2026-04-27 08:20:48.013+00	f	
7d59efea-fc42-4117-a34b-3937905456db	Sueldo analogo	Pedrocanosanchez1@gmail.com	\N	f	2026-04-19 13:14:01.52785+00	\N	+34621348851	f	2026-04-27 08:05:47.909+00	f	\N
1459c5f5-7c55-4f8c-86a0-f049234706a1	Juanka13Games	Juanka13games@gmail.com	\N	f	2026-03-27 13:45:43.559013+00	\N	+34648787955	f	2026-04-20 20:52:23.936+00	f	\N
eae8c25a-a99d-480f-8e3e-854d36c5c8dc	Jeybiss	57juanjose57@gmail.com	\N	f	2026-02-26 13:49:18.323124+00	\N	+48511397460	f	2026-04-24 19:21:38.663+00	f	\N
943a493d-044c-4c88-babc-e64804553bb4	Angel_Rico	Angel_fgrico@hotmail.com	\N	f	2026-02-25 19:24:06.029584+00	@angelvk	+34626179294	f	2026-04-24 08:53:33.203+00	f	Yigoro
4408336b-259c-437a-9f78-c4a664506756	FelixRG	felixrg1703@gmail.com	\N	f	2026-03-24 17:18:03.945849+00	FelixRG17	+34623916847	f	2026-04-26 14:17:27.388+00	f	\N
05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	Egea	Infoalbertoegea@gmail.com	\N	f	2026-03-20 09:12:32.84487+00		+34653882016	f	2026-04-27 08:09:20.101+00	f	Egea9
10920fad-ebd2-4be2-8e82-4604204f6139	jonny_black83	joni_esnaider@hotmail.com	\N	f	2026-04-19 13:30:06.886462+00	\N	+34684106252	f	2026-04-24 19:23:10.21+00	f	\N
8d16ce77-1836-4ce6-a462-b9d16358fb3f	Retirado (Rubens_saga)	retirado_1774949333177@liga.com	\N	f	2026-03-11 13:13:38.093043+00	\N	\N	f	2026-03-25 13:30:18.403+00	f	\N
4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	Ocarvallo15	ocarvallo23@gmail.com	\N	f	2026-03-21 13:28:47.100071+00	\N	+34671129439	f	2026-04-24 15:58:16.25+00	f	\N
0e9bdb55-a555-467d-995a-62d64ab8a509	libertojeans	libertogil@gmail.com	\N	f	2026-03-19 10:04:47.244235+00	\N	+34655085368	f	2026-04-27 08:43:04.606+00	f	\N
45ef0325-e165-4aef-8836-03099f1d7bd9	Chava_14	Luischava1234@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/45ef0325-e165-4aef-8836-03099f1d7bd9.webp?t=1775502165580	f	2026-03-09 11:59:20.35744+00	@chava_10	+34632657178	f	2026-04-25 13:51:49.265+00	f	Lchava96
ec1c03bd-6b21-4574-aff7-39deac5e25bf	Acrazun	Antoniocruzp80@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/ec1c03bd-6b21-4574-aff7-39deac5e25bf.webp?t=1775911072909	f	2026-04-11 12:32:48.226433+00		+34626915618	f	2026-04-27 08:47:17.48+00	f	
af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	Fernando92	fernandoguardado04@gmail.com	\N	f	2026-03-19 17:06:58.626939+00	\N	+34641822342	f	2026-04-24 16:07:09.444+00	f	\N
9d852873-3b29-4018-adde-c6244679e312	CharGie29	charlie29948@hotmail.com	\N	f	2026-04-01 11:44:06.973586+00		+34691142332	f	2026-04-27 09:01:54.811+00	f	CharGie29
c96625ad-9941-423c-8b5a-6fdc1b54ac20	SharkD	dari970417@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/c96625ad-9941-423c-8b5a-6fdc1b54ac20.webp?t=1773055989449	f	2026-03-09 11:32:15.759243+00		+34603377326	f	2026-04-24 16:24:38.511+00	f	\N
b5d23981-469b-4353-a615-9e4d6c8d8daf	AdriWins	adrianruizmartos16@gmail.com	\N	f	2026-02-21 18:35:14.188818+00	\N	+34601520647	f	2026-04-16 17:04:33.745+00	f	AdriWins16
74d1cfe5-421b-4be6-a055-0b7693ff2f1c	Kapi_86	Kapi_86@hotmail.com	\N	f	2026-03-19 17:01:34.347951+00	Kapi_86	+34663582278	f	2026-04-27 09:05:25.461+00	f	\N
e92aa512-c44f-48c8-b983-7c7705e36a6f	Excobar1208	escobarelkin@coruniamericana.edu.co	\N	f	2026-03-19 11:35:33.448954+00	\N	+34624550144	f	2026-04-26 16:08:02.806+00	f	\N
ff1dccb8-00bc-4042-a869-3a55773f3701	errejota	rjgcolino@gmail.com	\N	f	2026-02-16 15:24:06.155978+00	@rrjjggcc	+34665957216	f	2026-04-27 09:22:53.317+00	f	errejota_20
81a8640c-85be-4c54-9e36-9a5ac9c98e4a	Santi	kokoncholopez@gmail.com	\N	f	2026-04-24 13:17:37.918235+00		628249961	f	2026-04-27 09:46:28.452+00	f	Santilocarri2
2549f3dd-74dd-473b-be44-d5983b70e1ba	Franchesco	francisaditrap@gmail.com	\N	f	2026-02-25 11:51:26.140575+00	\N	+34692547413	f	2026-04-02 19:27:14.028+00	f	\N
f1932726-f713-4b61-8650-bf04f45d5b09	payomalo89	mendyvillacity@gmail.com	\N	f	2026-04-06 10:05:58.478595+00	\N	+34671998795	f	2026-04-08 19:47:20.806+00	f	\N
39b4f188-96fa-4fc8-8d91-4d954f67c5d3	melliot1990	melliot001@hotmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/39b4f188-96fa-4fc8-8d91-4d954f67c5d3.webp?t=1774966642580	f	2026-03-31 13:00:35.883001+00		+34644490107	f	2026-04-27 08:13:13.785+00	f	Melliot1990
c06aa55d-9cd6-4f14-8d85-6c5739913994	Mr.Macson	jhortolano@gmail.com	https://nkecyqwcrsicsyladdhw.supabase.co/storage/v1/object/public/avatars/avatars/c06aa55d-9cd6-4f14-8d85-6c5739913994.webp?t=1771253637914	f	2026-02-16 14:41:52.426307+00	@jl_hvv	+34655391764	t	2026-04-27 08:14:25.612+00	f	Mrmacson
\.


--
-- Data for Name: promo_matches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promo_matches (id, player1_id, player2_id, score1, score2, is_played, season, division, idavuelta, label_info, stream_url, created_at, updated_at, divplayer1, divplayer2) FROM stdin;
\.


--
-- Data for Name: season_rules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.season_rules (season, bonus_enabled, bonus_min_percentage, bonus_points, updated_at, limit_ga_enabled, max_ga_league, auto_week_by_date, auto_playoff_by_date, bonus_min_porcentageb, bonus_min_porcentagec, bonus_pointsb, bonus_pointsc) FROM stdin;
1	t	80	2	2026-03-01 20:09:45.744502+00	t	3	t	t	40	40	1	1
2	t	80	3	2026-04-27 07:32:14.103696+00	t	3	t	t	66	33	2	1
\.


--
-- Data for Name: votos_encuesta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.votos_encuesta (id, encuesta_id, usuario_id, opcion_index, created_at) FROM stdin;
62b0bcae-e11f-43ee-82e7-f4d71ac4b0e4	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	449ee91c-f52f-4661-abd4-ebfd556c37c3	2	2026-04-18 18:54:37.585768+00
58b4c98f-f0bb-43bf-bb22-292c132c8157	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	c06aa55d-9cd6-4f14-8d85-6c5739913994	1	2026-04-19 19:56:30.65751+00
02be1ca0-8349-40d9-9f1f-684e14be2014	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	4408336b-259c-437a-9f78-c4a664506756	1	2026-04-20 17:38:00.378342+00
c772d53e-ed47-4a57-8548-0af13d592d15	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	2f58705a-25ad-42c9-b953-5137532b3584	1	2026-04-21 18:01:44.71491+00
a9014cb5-839d-4a4e-b61f-51fe3645158a	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	05fcf0a8-e2f1-46b3-bad4-8d3b267fd003	0	2026-04-16 14:46:41.225745+00
ec528d81-2b0c-4c13-9c66-b51a8d06e120	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	1	2026-04-16 14:47:00.401012+00
9f7036ac-0a43-4864-aa81-a82819e4c81c	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	ec1c03bd-6b21-4574-aff7-39deac5e25bf	0	2026-04-16 14:55:45.032826+00
47e64e39-9445-40c4-99cd-f1de2c163d25	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	e92aa512-c44f-48c8-b983-7c7705e36a6f	0	2026-04-16 14:57:24.459521+00
98ee3401-6b21-4cd0-b9e6-c2a852461c16	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	0e9bdb55-a555-467d-995a-62d64ab8a509	1	2026-04-16 14:59:39.783232+00
b73501b0-fa14-48de-9ae6-e81c3bea6691	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	4ab9556d-f3d7-41c7-b2e1-dd9c2e630dbd	1	2026-04-16 15:01:42.798335+00
e6085fa3-7a77-432e-883e-777dc058ec4c	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	af7dbfd6-3f00-4823-90f0-e9ee4e7f5d76	1	2026-04-16 15:09:31.863958+00
80770550-527d-4e8c-ab0e-bdb139185bf3	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	0	2026-04-16 15:13:47.743126+00
78928321-6504-42a2-87b9-97ded02899c9	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	b5d23981-469b-4353-a615-9e4d6c8d8daf	0	2026-04-16 17:04:54.435441+00
f7ae1a37-1254-4ee7-89a3-9fbdbbb67dec	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	56f68d15-9c80-4b6a-9537-d8f5e8c1f021	0	2026-04-16 21:07:08.538104+00
c2bc22f3-8b80-47be-a00f-da1ebae93eb1	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	8c1c7bba-636d-42f2-820a-ac1131897e84	2	2026-04-16 14:58:47.636567+00
6b35bf93-a189-4b5d-b709-1425235644be	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	16f4402c-a1b5-4431-8d98-c454f52a6284	0	2026-04-16 23:08:11.490537+00
aa8de785-4b30-46c3-bbe2-71f418253ebe	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	1459c5f5-7c55-4f8c-86a0-f049234706a1	0	2026-04-17 09:22:38.380795+00
c3181bba-61e2-481c-af78-4b2fc0a779f8	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	943a493d-044c-4c88-babc-e64804553bb4	0	2026-04-17 12:12:46.11435+00
1349e6a4-36f3-42e3-98c2-4c0343c9ac6f	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	00872e2b-9e9c-442f-810c-bfd62ee8a524	0	2026-04-17 14:31:12.274909+00
ac3042ec-9831-4969-88bc-de07ead9b7cd	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	9d852873-3b29-4018-adde-c6244679e312	1	2026-04-16 14:51:08.400942+00
799d2ba4-c5f3-465c-9ab3-f9d718c1d7bd	91f9f75d-88a0-4c9f-9f3e-2a43aa3c679a	45ef0325-e165-4aef-8836-03099f1d7bd9	1	2026-04-18 14:52:01.918603+00
\.


--
-- Data for Name: weeks_promo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.weeks_promo (id, season, start_at, end_at, idavuelta, created_at) FROM stdin;
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
54	2	1	2026-04-27 22:00:00+00	2026-05-04 22:00:00+00	f
55	2	2	2026-05-04 22:00:00+00	2026-05-11 22:00:00+00	f
56	2	3	2026-05-11 22:00:00+00	2026-05-18 22:00:00+00	f
57	2	4	2026-05-18 22:00:00+00	2026-05-25 22:00:00+00	f
58	2	5	2026-05-25 22:00:00+00	2026-06-01 22:00:00+00	f
59	2	6	2026-05-25 22:00:00+00	2026-06-01 22:00:00+00	t
60	2	7	2026-06-01 22:00:00+00	2026-06-08 22:00:00+00	f
61	2	8	2026-06-01 22:00:00+00	2026-06-08 22:00:00+00	t
62	2	9	2026-06-08 22:00:00+00	2026-06-15 22:00:00+00	f
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: supabase_admin
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-02-03 13:49:47
20211116045059	2026-02-03 13:49:47
20211116050929	2026-02-03 13:49:47
20211116051442	2026-02-03 13:49:47
20211116212300	2026-02-03 13:49:47
20211116213355	2026-02-03 13:49:48
20211116213934	2026-02-03 13:49:48
20211116214523	2026-02-03 13:49:48
20211122062447	2026-02-03 13:49:48
20211124070109	2026-02-03 13:49:48
20211202204204	2026-02-03 13:49:48
20211202204605	2026-02-03 13:49:48
20211210212804	2026-02-03 13:49:48
20211228014915	2026-02-03 13:49:48
20220107221237	2026-02-03 13:49:48
20220228202821	2026-02-03 13:49:48
20220312004840	2026-02-03 13:49:48
20220603231003	2026-02-03 13:49:48
20220603232444	2026-02-03 13:49:48
20220615214548	2026-02-03 13:49:48
20220712093339	2026-02-03 13:49:48
20220908172859	2026-02-03 13:49:48
20220916233421	2026-02-03 13:49:48
20230119133233	2026-02-03 13:49:48
20230128025114	2026-02-03 13:49:48
20230128025212	2026-02-03 13:49:48
20230227211149	2026-02-03 13:49:48
20230228184745	2026-02-03 13:49:48
20230308225145	2026-02-03 13:49:48
20230328144023	2026-02-03 13:49:48
20231018144023	2026-02-03 13:49:48
20231204144023	2026-02-03 13:49:48
20231204144024	2026-02-03 13:49:48
20231204144025	2026-02-03 13:49:48
20240108234812	2026-02-03 13:49:48
20240109165339	2026-02-03 13:49:48
20240227174441	2026-02-03 13:49:48
20240311171622	2026-02-03 13:49:48
20240321100241	2026-02-03 13:49:48
20240401105812	2026-02-03 13:49:48
20240418121054	2026-02-03 13:49:48
20240523004032	2026-02-03 13:49:48
20240618124746	2026-02-03 13:49:48
20240801235015	2026-02-03 13:49:48
20240805133720	2026-02-03 13:49:48
20240827160934	2026-02-03 13:49:48
20240919163303	2026-02-03 13:49:48
20240919163305	2026-02-03 13:49:48
20241019105805	2026-02-03 13:49:48
20241030150047	2026-02-03 13:58:41
20241108114728	2026-02-03 13:58:41
20241121104152	2026-02-03 13:58:41
20241130184212	2026-02-03 13:58:41
20241220035512	2026-02-03 13:58:41
20241220123912	2026-02-03 13:58:41
20241224161212	2026-02-03 13:58:41
20250107150512	2026-02-03 13:58:41
20250110162412	2026-02-03 13:58:41
20250123174212	2026-02-03 13:58:41
20250128220012	2026-02-03 13:58:41
20250506224012	2026-02-03 13:58:41
20250523164012	2026-02-03 13:58:41
20250714121412	2026-02-03 13:58:41
20250905041441	2026-02-03 13:58:41
20251103001201	2026-02-03 13:58:41
20251120212548	2026-02-09 16:16:15
20251120215549	2026-02-09 16:16:15
20260218120000	2026-04-13 13:08:52
20260326120000	2026-04-13 13:08:52
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
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-02-03 13:50:28.660942
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-02-03 13:50:28.673158
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-02-03 13:50:28.701348
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-02-03 13:50:28.724311
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-02-03 13:50:28.728314
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-02-03 13:50:28.737419
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-02-03 13:50:28.741713
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-02-03 13:50:28.755408
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-02-03 13:50:28.759865
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-02-03 13:50:28.764002
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-02-03 13:50:28.768635
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-02-03 13:50:28.787604
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-02-03 13:50:28.791789
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-02-03 13:50:28.795781
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-02-03 13:50:28.799697
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-02-03 13:50:28.804569
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-02-03 13:50:28.808776
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-02-03 13:50:28.81421
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-02-03 13:50:28.825941
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-02-03 13:50:28.834785
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-02-03 13:50:28.839044
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-02-03 13:50:28.843253
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-02-03 13:50:28.912179
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-02-03 13:50:28.957883
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-02-03 13:50:28.962403
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-02-03 13:50:28.974685
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-02-03 13:50:28.979269
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-02-03 13:50:28.999879
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-02-03 13:50:28.677505
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-02-03 13:50:28.733024
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-02-03 13:50:28.746072
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-02-03 13:50:28.750819
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-02-03 13:50:28.847508
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-02-03 13:50:28.857898
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-02-03 13:50:28.866426
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-02-03 13:50:28.870681
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-02-03 13:50:28.875029
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-02-03 13:50:28.881284
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-02-03 13:50:28.887576
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-02-03 13:50:28.894043
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-02-03 13:50:28.895804
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-02-03 13:50:28.901781
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-02-03 13:50:28.905817
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-02-03 13:50:28.916918
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-02-03 13:50:28.925447
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-02-03 13:50:28.931259
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-02-03 13:50:28.940047
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-02-03 13:50:28.945348
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-02-03 13:50:28.953441
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-02-03 13:50:28.983549
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-02-10 11:16:17.272132
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-02-10 11:16:17.309776
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-02-10 11:16:17.310741
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-02-10 11:16:17.364982
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-02-10 11:16:17.366568
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-02-10 11:16:17.367555
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-02-10 11:16:17.371877
57	s3-multipart-uploads-metadata	f127886e00d1b374fadbc7c6b31e09336aad5287	2026-04-06 18:21:47.735328
58	operation-ergonomics	00ca5d483b3fe0d522133d9002ccc5df98365120	2026-04-06 18:21:47.771949
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
961af7af-6af7-408a-bdd9-ba469586033f	avatars	avatars/.emptyFolderPlaceholder	\N	2026-02-04 14:02:59.284741+00	2026-02-04 14:02:59.284741+00	2026-02-04 14:02:59.284741+00	{"eTag": "\\"d41d8cd98f00b204e9800998ecf8427e\\"", "size": 0, "mimetype": "application/octet-stream", "cacheControl": "max-age=3600", "lastModified": "2026-02-04T14:02:59.283Z", "contentLength": 0, "httpStatusCode": 200}	c4c54646-e8b1-4180-bd45-5d7db3131e2e	\N	{}
f1998eae-205b-4700-a4e5-8ee37b9fb05c	avatars	avatars/c06aa55d-9cd6-4f14-8d85-6c5739913994.webp	c06aa55d-9cd6-4f14-8d85-6c5739913994	2026-02-16 14:53:57.748757+00	2026-02-16 14:53:57.748757+00	2026-02-16 14:53:57.748757+00	{"eTag": "\\"6223f9fded4a6abc8c09a47e1244fd3a\\"", "size": 31248, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-02-16T14:53:58.000Z", "contentLength": 31248, "httpStatusCode": 200}	139724b0-f40f-4548-867c-4ada67c77611	c06aa55d-9cd6-4f14-8d85-6c5739913994	{}
2d04c402-841f-4948-b82c-5eda5f2d6c92	avatars	avatars/3c68098c-1259-465a-b073-6626f755878f.webp	3c68098c-1259-465a-b073-6626f755878f	2026-02-10 15:49:28.959102+00	2026-02-10 15:49:28.959102+00	2026-02-10 15:49:28.959102+00	{"eTag": "\\"a91c452f07ad7e0e5ba9d86ecf6f18ee\\"", "size": 49473, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-02-10T15:49:29.000Z", "contentLength": 49473, "httpStatusCode": 200}	3a47a6cb-3a1a-492a-88d1-f9d7544291f6	3c68098c-1259-465a-b073-6626f755878f	{}
c8c0a8f4-c5ae-4fc8-bff4-c2f448a95316	avatars	avatars/22afa7c4-8a0e-433c-aa5e-8f7d2722c8cb.webp	22afa7c4-8a0e-433c-aa5e-8f7d2722c8cb	2026-02-12 15:21:01.590004+00	2026-02-12 15:21:01.590004+00	2026-02-12 15:21:01.590004+00	{"eTag": "\\"b611a2fa8ae8933035da3b5448890615\\"", "size": 27598, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-02-12T15:21:02.000Z", "contentLength": 27598, "httpStatusCode": 200}	206f889d-a6d6-4592-8883-3c00e624091b	22afa7c4-8a0e-433c-aa5e-8f7d2722c8cb	{}
2e8f4744-d4a8-4fb9-ae7e-655d5bf92853	avatars	avatars/96bbeaee-35b6-4fc2-ac4a-35aa20c0fca0.webp	96bbeaee-35b6-4fc2-ac4a-35aa20c0fca0	2026-02-12 16:50:07.597488+00	2026-02-12 16:50:07.597488+00	2026-02-12 16:50:07.597488+00	{"eTag": "\\"9aeaae97ab27e9c2df368a0e4dd7dbcd\\"", "size": 41835, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-02-12T16:50:08.000Z", "contentLength": 41835, "httpStatusCode": 200}	e3c64b84-0fa1-42cf-9bbb-ac77b1fd1de3	96bbeaee-35b6-4fc2-ac4a-35aa20c0fca0	{}
1e076dd1-8262-4adb-9aa5-77c8331f7205	avatars	avatars/13d9a5fc-0160-4643-9a0f-915ab813ac83.webp	13d9a5fc-0160-4643-9a0f-915ab813ac83	2026-02-12 16:58:49.76573+00	2026-02-12 16:58:49.76573+00	2026-02-12 16:58:49.76573+00	{"eTag": "\\"463901760a7ef24ab0036135f2a0fdd0\\"", "size": 2524, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-02-12T16:58:50.000Z", "contentLength": 2524, "httpStatusCode": 200}	cb573e0d-4b4a-4b87-b390-28f689db698b	13d9a5fc-0160-4643-9a0f-915ab813ac83	{}
824fe016-de67-4887-b7b5-2a59239dad72	avatars	avatars/c3047c54-a5b6-4308-902b-00acb9780ee9.webp	c3047c54-a5b6-4308-902b-00acb9780ee9	2026-02-13 10:00:47.348869+00	2026-02-13 10:00:47.348869+00	2026-02-13 10:00:47.348869+00	{"eTag": "\\"a39b01df1d7cb55299355396151f1a30\\"", "size": 44868, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-02-13T10:00:48.000Z", "contentLength": 44868, "httpStatusCode": 200}	84f12cc1-595d-4ee7-a706-9b4b88dcd95f	c3047c54-a5b6-4308-902b-00acb9780ee9	{}
8db32e32-f56e-4122-8f75-3fa73ff87708	avatars	avatars/00872e2b-9e9c-442f-810c-bfd62ee8a524.webp	00872e2b-9e9c-442f-810c-bfd62ee8a524	2026-02-28 09:29:14.763829+00	2026-02-28 09:29:14.763829+00	2026-02-28 09:29:14.763829+00	{"eTag": "\\"df411a659a2a50e6d751180eaf390876\\"", "size": 5760, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-02-28T09:29:15.000Z", "contentLength": 5760, "httpStatusCode": 200}	036a9f57-8cd3-495e-973b-f7f2ef6567e7	00872e2b-9e9c-442f-810c-bfd62ee8a524	{}
d8026456-5e6d-4aa8-9e3e-be5337960184	avatars	avatars/8c1c7bba-636d-42f2-820a-ac1131897e84.webp	8c1c7bba-636d-42f2-820a-ac1131897e84	2026-03-05 10:25:45.131744+00	2026-03-05 10:25:51.411234+00	2026-03-05 10:25:45.131744+00	{"eTag": "\\"7ed92ca63da3d29b44b7053409b6d62f\\"", "size": 6344, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-05T10:25:52.000Z", "contentLength": 6344, "httpStatusCode": 200}	a5d1a1f0-2c20-4f17-a2d0-ef9d1c31e391	8c1c7bba-636d-42f2-820a-ac1131897e84	{}
6cf035b6-34b1-448c-85a9-6fda95f8e0c8	avatars	avatars/c96625ad-9941-423c-8b5a-6fdc1b54ac20.webp	c96625ad-9941-423c-8b5a-6fdc1b54ac20	2026-03-09 11:33:09.657051+00	2026-03-09 11:33:09.657051+00	2026-03-09 11:33:09.657051+00	{"eTag": "\\"bda8e75b3727765b9b91bf44d121407e\\"", "size": 5876, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-09T11:33:10.000Z", "contentLength": 5876, "httpStatusCode": 200}	542917e2-0fa4-4917-a9e7-3441131945a7	c96625ad-9941-423c-8b5a-6fdc1b54ac20	{}
b774262d-f9a3-4a9e-ac86-635880bef478	avatars	avatars/16f4402c-a1b5-4431-8d98-c454f52a6284.webp	16f4402c-a1b5-4431-8d98-c454f52a6284	2026-03-13 22:32:26.397962+00	2026-03-13 22:32:26.397962+00	2026-03-13 22:32:26.397962+00	{"eTag": "\\"970da3587349d2d6fc376b5001169197\\"", "size": 4244, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-13T22:32:27.000Z", "contentLength": 4244, "httpStatusCode": 200}	1429a405-f448-412e-b53c-2c8e5b4ecc58	16f4402c-a1b5-4431-8d98-c454f52a6284	{}
82d7c2ac-2735-454a-9036-bc77a90a9cd5	avatars	avatars/696d8a57-be9d-40a9-a945-76eb20706f72.webp	696d8a57-be9d-40a9-a945-76eb20706f72	2026-03-19 10:46:38.565515+00	2026-03-19 10:46:38.565515+00	2026-03-19 10:46:38.565515+00	{"eTag": "\\"7f5fa05cf0d9d136f29b27655d112412\\"", "size": 5362, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-03-19T10:46:39.000Z", "contentLength": 5362, "httpStatusCode": 200}	eb909dfc-f0a0-47be-bb13-78f40154c0d0	696d8a57-be9d-40a9-a945-76eb20706f72	{}
9744d52d-3cb2-433a-9614-99920bfe8c56	avatars	avatars/45ef0325-e165-4aef-8836-03099f1d7bd9.webp	45ef0325-e165-4aef-8836-03099f1d7bd9	2026-03-09 12:09:41.678586+00	2026-04-06 19:02:45.422862+00	2026-03-09 12:09:41.678586+00	{"eTag": "\\"a284a2b6c5a5190d1b839d5d37b13bfe\\"", "size": 42142, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-06T19:02:46.000Z", "contentLength": 42142, "httpStatusCode": 200}	add6c859-8133-42f6-9463-7ddecf8e2222	45ef0325-e165-4aef-8836-03099f1d7bd9	{}
76a5d9c2-0f19-4fe2-a943-c331f71dc933	avatars	avatars/38f98f64-f2db-47bf-a5ea-dcd1804ce00a.webp	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	2026-03-23 09:51:36.176067+00	2026-03-23 09:51:36.176067+00	2026-03-23 09:51:36.176067+00	{"eTag": "\\"2ea8827fd809365e7f56f6b16a682565\\"", "size": 44300, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-23T09:51:37.000Z", "contentLength": 44300, "httpStatusCode": 200}	d6875028-20ca-4453-82ad-07525c61ed0b	38f98f64-f2db-47bf-a5ea-dcd1804ce00a	{}
6597188a-68dc-4004-a7a6-2a9b3357f6de	avatars	avatars/39b4f188-96fa-4fc8-8d91-4d954f67c5d3.webp	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	2026-03-31 14:10:37.799477+00	2026-03-31 14:17:22.524299+00	2026-03-31 14:10:37.799477+00	{"eTag": "\\"5e06c61f05793e1ef6e3ca15980df83f\\"", "size": 39530, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-03-31T14:17:23.000Z", "contentLength": 39530, "httpStatusCode": 200}	b1195478-a20a-40a0-89af-95ca832d8a54	39b4f188-96fa-4fc8-8d91-4d954f67c5d3	{}
f730a127-a404-4c64-98ac-ef9c4faef3af	avatars	avatars/ec1c03bd-6b21-4574-aff7-39deac5e25bf.webp	ec1c03bd-6b21-4574-aff7-39deac5e25bf	2026-04-11 12:36:54.296564+00	2026-04-11 12:37:52.563889+00	2026-04-11 12:36:54.296564+00	{"eTag": "\\"2807d2f12d0eb35f1297fe0639cae787\\"", "size": 4088, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2026-04-11T12:37:53.000Z", "contentLength": 4088, "httpStatusCode": 200}	a4fc47e2-8cc9-4aec-a1a5-d9073b84e8fb	ec1c03bd-6b21-4574-aff7-39deac5e25bf	{}
b7fe4839-32dc-4bb9-a3f2-0021ce3f505c	avatars	avatars/e804e0cf-72af-449e-9816-46518b271b84.webp	e804e0cf-72af-449e-9816-46518b271b84	2026-04-27 08:22:22.587174+00	2026-04-27 08:22:22.587174+00	2026-04-27 08:22:22.587174+00	{"eTag": "\\"f05c8f54e6c062d3be6a3d3be871a448\\"", "size": 44073, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2026-04-27T08:22:23.000Z", "contentLength": 44073, "httpStatusCode": 200}	74e956e6-1bab-4297-97b3-4c625850dd1f	e804e0cf-72af-449e-9816-46518b271b84	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata, metadata) FROM stdin;
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

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 2073, true);


--
-- Name: config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.config_id_seq', 1, false);


--
-- Name: extra_playoffs_matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.extra_playoffs_matches_id_seq', 99, true);


--
-- Name: matches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matches_id_seq', 191, true);


--
-- Name: matches_rescheduled_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matches_rescheduled_id_seq', 22, true);


--
-- Name: weeks_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.weeks_schedule_id_seq', 62, true);


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
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


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
-- Name: matches_rescheduled matches_rescheduled_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches_rescheduled
    ADD CONSTRAINT matches_rescheduled_pkey PRIMARY KEY (id);


--
-- Name: notificaciones_enviadas notificaciones_enviadas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notificaciones_enviadas
    ADD CONSTRAINT notificaciones_enviadas_pkey PRIMARY KEY (id);


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
-- Name: promo_matches promo_matches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_matches
    ADD CONSTRAINT promo_matches_pkey PRIMARY KEY (id);


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
-- Name: weeks_promo weeks_promo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.weeks_promo
    ADD CONSTRAINT weeks_promo_pkey PRIMARY KEY (id);


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
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


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
-- Name: extra_matches tr_update_extra_matches; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_update_extra_matches BEFORE UPDATE ON public.extra_matches FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: matches tr_update_matches_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_update_matches_updated_at BEFORE UPDATE ON public.matches FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: playoff_matches tr_update_playoff_matches_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER tr_update_playoff_matches_updated_at BEFORE UPDATE ON public.playoff_matches FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: extra_playoffs_matches update_extra_playoffs_matches_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_extra_playoffs_matches_updated_at BEFORE UPDATE ON public.extra_playoffs_matches FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


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
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


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
-- Name: matches_rescheduled matches_rescheduled_player1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches_rescheduled
    ADD CONSTRAINT matches_rescheduled_player1_id_fkey FOREIGN KEY (player1_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


--
-- Name: matches_rescheduled matches_rescheduled_player2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matches_rescheduled
    ADD CONSTRAINT matches_rescheduled_player2_id_fkey FOREIGN KEY (player2_id) REFERENCES public.profiles(id) ON DELETE CASCADE;


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
-- Name: promo_matches promo_matches_player1_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_matches
    ADD CONSTRAINT promo_matches_player1_id_fkey FOREIGN KEY (player1_id) REFERENCES public.profiles(id);


--
-- Name: promo_matches promo_matches_player2_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promo_matches
    ADD CONSTRAINT promo_matches_player2_id_fkey FOREIGN KEY (player2_id) REFERENCES public.profiles(id);


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
-- Name: promo_matches Admin full access promo_matches; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin full access promo_matches" ON public.promo_matches TO authenticated USING ((( SELECT profiles.is_admin
   FROM public.profiles
  WHERE (profiles.id = auth.uid())) = true));


--
-- Name: weeks_promo Admin full access weeks_promo; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Admin full access weeks_promo" ON public.weeks_promo TO authenticated USING ((( SELECT profiles.is_admin
   FROM public.profiles
  WHERE (profiles.id = auth.uid())) = true));


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
-- Name: extra_playoffs_matches Cualquiera puede ver los partidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Cualquiera puede ver los partidos" ON public.extra_playoffs_matches FOR SELECT TO authenticated, anon USING (true);


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
-- Name: matches_rescheduled Lectura pública para autenticados; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Lectura pública para autenticados" ON public.matches_rescheduled FOR SELECT TO authenticated USING (true);


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
-- Name: matches_rescheduled Permitir actualización pública; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir actualización pública" ON public.matches_rescheduled FOR UPDATE USING (true);


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
-- Name: notificaciones_enviadas Permitir inserción anónima; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir inserción anónima" ON public.notificaciones_enviadas FOR INSERT TO anon WITH CHECK (true);


--
-- Name: matches_rescheduled Permitir inserción pública; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir inserción pública" ON public.matches_rescheduled FOR INSERT WITH CHECK (true);


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
-- Name: notificaciones_enviadas Permitir lectura anónima; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura anónima" ON public.notificaciones_enviadas FOR SELECT TO anon USING (true);


--
-- Name: playoffs Permitir lectura pública a playoffs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura pública a playoffs" ON public.playoffs FOR SELECT USING (true);


--
-- Name: matches_rescheduled Permitir lectura pública a semanas; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura pública a semanas" ON public.matches_rescheduled FOR SELECT USING (true);


--
-- Name: weeks_schedule Permitir lectura pública a semanas; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura pública a semanas" ON public.weeks_schedule FOR SELECT USING (true);


--
-- Name: matches Permitir lectura pública de partidos; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura pública de partidos" ON public.matches FOR SELECT TO anon USING (true);


--
-- Name: promo_matches Permitir lectura pública de partidos de promo; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura pública de partidos de promo" ON public.promo_matches FOR SELECT USING (true);


--
-- Name: profiles Permitir lectura pública de perfiles; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura pública de perfiles" ON public.profiles FOR SELECT TO anon USING (true);


--
-- Name: weeks_promo Permitir lectura pública de promociones; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Permitir lectura pública de promociones" ON public.weeks_promo FOR SELECT USING (true);


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
-- Name: matches_rescheduled Staff o jugadores pueden actualizar; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff o jugadores pueden actualizar" ON public.matches_rescheduled FOR UPDATE TO authenticated USING (((auth.uid() = player1_id) OR (auth.uid() = player2_id) OR public.is_admin_or_collab())) WITH CHECK (((auth.uid() = player1_id) OR (auth.uid() = player2_id) OR public.is_admin_or_collab()));


--
-- Name: matches_rescheduled Staff o jugadores pueden eliminar; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff o jugadores pueden eliminar" ON public.matches_rescheduled FOR DELETE TO authenticated USING (((auth.uid() = player1_id) OR (auth.uid() = player2_id) OR public.is_admin_or_collab()));


--
-- Name: matches_rescheduled Staff o jugadores pueden insertar; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY "Staff o jugadores pueden insertar" ON public.matches_rescheduled FOR INSERT TO authenticated WITH CHECK (((auth.uid() = player1_id) OR (auth.uid() = player2_id) OR public.is_admin_or_collab()));


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
-- Name: extra_playoffs_matches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.extra_playoffs_matches ENABLE ROW LEVEL SECURITY;

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
-- Name: matches_rescheduled; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.matches_rescheduled ENABLE ROW LEVEL SECURITY;

--
-- Name: notificaciones_enviadas; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.notificaciones_enviadas ENABLE ROW LEVEL SECURITY;

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
-- Name: promo_matches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.promo_matches ENABLE ROW LEVEL SECURITY;

--
-- Name: season_rules; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.season_rules ENABLE ROW LEVEL SECURITY;

--
-- Name: votos_encuesta; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.votos_encuesta ENABLE ROW LEVEL SECURITY;

--
-- Name: weeks_promo; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.weeks_promo ENABLE ROW LEVEL SECURITY;

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
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO dashboard_user;
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
GRANT SELECT ON TABLE auth.flow_state TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.flow_state TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.flow_state TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.identities TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.identities TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.identities TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.instances TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.instances TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.instances TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO dashboard_user;
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
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO dashboard_user;
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
GRANT SELECT ON TABLE auth.saml_providers TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_providers TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_providers TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO dashboard_user;
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
GRANT SELECT ON TABLE auth.sessions TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sessions TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sessions TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_domains TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_domains TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_providers TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.sso_providers TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.users TO postgres;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.users TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT SELECT ON TABLE auth.users TO dashboard_user;
RESET SESSION AUTHORIZATION;


--
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


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
-- Name: TABLE matches_rescheduled; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.matches_rescheduled TO anon;
GRANT ALL ON TABLE public.matches_rescheduled TO authenticated;
GRANT ALL ON TABLE public.matches_rescheduled TO service_role;


--
-- Name: TABLE notificaciones_enviadas; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notificaciones_enviadas TO anon;
GRANT ALL ON TABLE public.notificaciones_enviadas TO authenticated;
GRANT ALL ON TABLE public.notificaciones_enviadas TO service_role;


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
-- Name: TABLE promo_matches; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.promo_matches TO anon;
GRANT ALL ON TABLE public.promo_matches TO authenticated;
GRANT ALL ON TABLE public.promo_matches TO service_role;


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
-- Name: TABLE weeks_promo; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.weeks_promo TO anon;
GRANT ALL ON TABLE public.weeks_promo TO authenticated;
GRANT ALL ON TABLE public.weeks_promo TO service_role;


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
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO authenticated;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.buckets TO anon;
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
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO service_role;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO authenticated;
RESET SESSION AUTHORIZATION;
SET SESSION AUTHORIZATION postgres;
GRANT ALL ON TABLE storage.objects TO anon;
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

\unrestrict ggdXxpnpYrAwqBLorfQvENL8xg4UQXakvciRX23pK81XWd84jCAe90C7GJxtyKG

