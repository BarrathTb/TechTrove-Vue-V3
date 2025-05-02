--
-- PostgreSQL database dump
--

-- Dumped from database version 15.12
-- Dumped by pg_dump version 17.4

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
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgsodium;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
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


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
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


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
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


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
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


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
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


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
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


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
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


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
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

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
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


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
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


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
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


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$begin
  insert into public.profiles (id, full_name, avatar_url)
  values (new.id, new.raw_user_meta_data->>'full_name', new.raw_user_meta_data->>'avatar_url');
  return new;
end;$$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
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
        subs.entity = entity_;

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
                        or action = 'DELETE'
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


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
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


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
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


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
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


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
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


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
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


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
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


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
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


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


--
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: -
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
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


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
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


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
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


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
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


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
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


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
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
    tag text
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
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


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: badges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.badges (
    id bigint NOT NULL,
    name text,
    image_url text,
    description text
);


--
-- Name: badges_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.badges ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.badges_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: blog_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_posts (
    id bigint NOT NULL,
    user_id bigint,
    title text,
    content text,
    points_earned integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    image_url text
);


--
-- Name: blog_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.blog_posts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.blog_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: carts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.carts (
    id bigint NOT NULL,
    user_id uuid,
    product_id bigint,
    quantity integer
);

ALTER TABLE public.carts
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id)
REFERENCES public.products (id);


--
-- Name: carts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.carts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.carts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: levels; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.levels (
    id bigint NOT NULL,
    name text,
    points_required bigint,
    discount_percentage numeric,
    badge_id bigint
);


--
-- Name: levels_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.levels ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.levels_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: message_board_posts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.message_board_posts (
    id bigint NOT NULL,
    user_id bigint,
    title text,
    content text,
    points_earned integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: message_board_posts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.message_board_posts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.message_board_posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: order_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.order_items (
    id bigint NOT NULL,
    order_id bigint,
    product_id bigint,
    quantity integer,
    price numeric
);


--
-- Name: order_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.order_items ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.order_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: orders; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.orders (
    id bigint NOT NULL,
    user_id bigint,
    total_amount numeric,
    points_earned numeric,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.orders ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name text,
    brand text,
    category text,
    price numeric,
    image text,
    description text,
    stock integer,
    ratings jsonb,
    features text[],
    dimensions jsonb,
    weight text,
    warranty text
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.products ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    updated_at timestamp with time zone,
    username text,
    full_name text,
    avatar_url text,
    website text,
    CONSTRAINT username_length CHECK ((char_length(username) >= 3))
);


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    user_id bigint,
    product_id bigint,
    rating integer,
    comment text,
    points_earned integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.reviews ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    password text NOT NULL,
    username text NOT NULL,
    email text NOT NULL,
    level_id bigint,
    points integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    profile_id uuid
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: wishlists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.wishlists (
    id bigint NOT NULL,
    user_id uuid,
    product_id bigint
);


--
-- Name: wishlists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

ALTER TABLE public.wishlists ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.wishlists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    id bigint NOT NULL,
    topic text NOT NULL,
    extension text NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

CREATE SEQUENCE realtime.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: realtime; Owner: -
--

ALTER SEQUENCE realtime.messages_id_seq OWNED BY realtime.messages.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
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
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
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
    owner_id text
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
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
    owner_id text
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
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


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages ALTER COLUMN id SET DEFAULT nextval('realtime.messages_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	56ec231f-7da0-46b2-a6c3-370fd47d8c30	{"action":"user_confirmation_requested","actor_id":"48608b22-9315-4e11-96b3-c24c33d3a377","actor_username":"example@email.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-04-28 00:59:02.106833-05	
00000000-0000-0000-0000-000000000000	e4fc3d11-ef83-4feb-9084-8759203df41d	{"action":"user_confirmation_requested","actor_id":"48608b22-9315-4e11-96b3-c24c33d3a377","actor_username":"example@email.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-04-28 16:43:16.545368-05	
00000000-0000-0000-0000-000000000000	c5a957f6-486b-4718-b71a-b004ab96164c	{"action":"logout","actor_id":"41041e94-9db1-44af-a8c3-fae65577e8cc","actor_username":"","actor_via_sso":false,"log_type":"account"}	2024-04-28 18:51:45.856229-05	
00000000-0000-0000-0000-000000000000	c1a86b41-f73f-4673-a36e-abc81d9bd039	{"action":"user_confirmation_requested","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-04-28 19:06:09.587567-05	
00000000-0000-0000-0000-000000000000	4b0a355b-c0c9-476d-982a-c871d249dbd9	{"action":"user_signedup","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"team"}	2024-04-28 22:25:39.351127-05	
00000000-0000-0000-0000-000000000000	f19a016d-ad24-470c-b650-05d8b488269f	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-28 23:24:18.677999-05	
00000000-0000-0000-0000-000000000000	b2f884ca-3dec-4f88-86c5-0e1344e7e9aa	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-28 23:24:18.679392-05	
00000000-0000-0000-0000-000000000000	530382c3-8168-43c0-af7b-1338b96dda0f	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 09:21:31.978231-05	
00000000-0000-0000-0000-000000000000	6665d216-be93-4124-b0b8-8f0463702b58	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 09:21:31.986618-05	
00000000-0000-0000-0000-000000000000	e6712010-f37f-4018-8580-6f8722a175d6	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 09:21:32.753215-05	
00000000-0000-0000-0000-000000000000	d209a675-d66a-4abf-b35d-4755d791c2b4	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 10:19:51.034448-05	
00000000-0000-0000-0000-000000000000	e7bc2a31-1cd2-4205-9e58-5da3fe2001d7	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 10:19:51.035666-05	
00000000-0000-0000-0000-000000000000	72b6deba-7936-4d5e-b78b-cd8a69aa3d6b	{"action":"logout","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-04-29 10:40:59.691571-05	
00000000-0000-0000-0000-000000000000	e4df3afa-21cf-4fb7-b3d8-56019883764d	{"action":"user_recovery_requested","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-04-29 10:41:23.974885-05	
00000000-0000-0000-0000-000000000000	1b2a60f9-a695-4c92-a69c-65ad9a0169f8	{"action":"login","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-04-29 10:47:05.008153-05	
00000000-0000-0000-0000-000000000000	1dd5a917-d9cf-49ad-93d9-3d06e5b490a5	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 11:45:17.211895-05	
00000000-0000-0000-0000-000000000000	39f586d1-430e-4d87-8037-2c7dc7f809d1	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 11:45:17.216716-05	
00000000-0000-0000-0000-000000000000	25c2cb60-ec42-4d03-a5a7-f6f5c3cdfdfc	{"action":"logout","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-04-29 11:59:11.482636-05	
00000000-0000-0000-0000-000000000000	76e9d0b9-087e-4754-b54e-8d512b2220f6	{"action":"user_recovery_requested","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-04-29 11:59:25.733482-05	
00000000-0000-0000-0000-000000000000	5763d06e-cfce-43a3-b9dd-50dc2c8129de	{"action":"user_recovery_requested","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-04-29 12:01:48.800072-05	
00000000-0000-0000-0000-000000000000	5762ec6b-a61f-4f1b-9536-3a8a617cc3a1	{"action":"login","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-04-29 12:02:01.625821-05	
00000000-0000-0000-0000-000000000000	f1ec2347-df5e-4690-8e6c-749187d38c46	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 13:02:11.128662-05	
00000000-0000-0000-0000-000000000000	2d2876ce-0ad3-4e4d-97af-bcc9e4d3add5	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 13:02:11.129852-05	
00000000-0000-0000-0000-000000000000	5a9dec56-0edb-4b12-9f6d-2f36bdd7d5b3	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 14:25:20.094676-05	
00000000-0000-0000-0000-000000000000	87b4b5de-45da-4114-848c-12c7fce3da33	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 14:25:20.095349-05	
00000000-0000-0000-0000-000000000000	bb4536c0-8da4-4f2a-979f-4271e94d84df	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 21:54:23.153964-05	
00000000-0000-0000-0000-000000000000	cf76f118-b369-4982-a49e-73eaa66e69d8	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 21:54:23.156024-05	
00000000-0000-0000-0000-000000000000	aea842c2-3cf4-4368-841b-914d34ecca81	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 22:52:29.728034-05	
00000000-0000-0000-0000-000000000000	6f7d7c3c-cac8-4ce4-b6c2-49dac57c0e7d	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 22:52:29.731358-05	
00000000-0000-0000-0000-000000000000	bf912afe-7002-45c0-b0ec-8143b6ea6413	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 23:50:30.063806-05	
00000000-0000-0000-0000-000000000000	3bb37d4b-09c9-44b8-a9a0-6780c69a628d	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-29 23:50:30.073418-05	
00000000-0000-0000-0000-000000000000	926a5efa-e7cc-4d07-b7d9-df4f8cecef73	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-30 06:49:46.30132-05	
00000000-0000-0000-0000-000000000000	e7e74e56-2d21-4c53-8fa6-c237a70eba15	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-30 06:49:46.315202-05	
00000000-0000-0000-0000-000000000000	ae8462a0-491b-4f7b-b5c9-861911127bbb	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-30 10:38:38.789715-05	
00000000-0000-0000-0000-000000000000	1506a74f-1de8-4706-8d13-b3bca9ce15a5	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-30 10:38:38.790936-05	
00000000-0000-0000-0000-000000000000	c0c68af8-4edc-4c01-9d9f-0ba8cec6d670	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-30 11:43:10.058723-05	
00000000-0000-0000-0000-000000000000	cacf3224-cedc-4919-8934-8582d9ae4831	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-30 11:43:10.059552-05	
00000000-0000-0000-0000-000000000000	aa498c17-d8b9-4bc9-b042-3aeb5219ab9a	{"action":"token_refreshed","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-30 22:31:33.761233-05	
00000000-0000-0000-0000-000000000000	558cf22f-292f-47a5-acfe-82e5d0aaf05e	{"action":"token_revoked","actor_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-04-30 22:31:33.763355-05	
00000000-0000-0000-0000-000000000000	862b5234-cd16-4080-bcbc-de67a495c57e	{"action":"user_confirmation_requested","actor_id":"b6f9c99e-1ba3-4fc9-881b-9053bcd298b5","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-05-01 10:23:06.693317-05	
00000000-0000-0000-0000-000000000000	5c0553a0-36e0-44af-9b1a-81bf87cc3cf3	{"action":"user_signedup","actor_id":"b6f9c99e-1ba3-4fc9-881b-9053bcd298b5","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"team"}	2024-05-01 10:37:25.761844-05	
00000000-0000-0000-0000-000000000000	f56042f4-96f3-4785-b3be-b829a1abb61b	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"thomasbarrath@gmail.com","user_id":"b6f9c99e-1ba3-4fc9-881b-9053bcd298b5","user_phone":""}}	2024-05-01 10:48:41.753099-05	
00000000-0000-0000-0000-000000000000	203d0b04-d20a-4932-887f-e7c53e2fc3a3	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"barrathtb@gmail.com","user_id":"da3bd6ae-93bf-49e0-a587-d295f5d5d1a2","user_phone":""}}	2024-05-01 10:48:45.688454-05	
00000000-0000-0000-0000-000000000000	80a22f2c-966e-429c-8cfc-4dedc728bd8a	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"41041e94-9db1-44af-a8c3-fae65577e8cc","user_phone":""}}	2024-05-01 10:48:49.591683-05	
00000000-0000-0000-0000-000000000000	1720a6e7-2b5a-4e9e-9959-98063c250873	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"example@email.com","user_id":"48608b22-9315-4e11-96b3-c24c33d3a377","user_phone":""}}	2024-05-01 10:48:53.214539-05	
00000000-0000-0000-0000-000000000000	1fca80c7-34d2-4719-a110-bcc342acd58e	{"action":"user_confirmation_requested","actor_id":"028d1c22-0c21-416e-916a-b8543e0ba6a8","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-05-01 10:53:52.99375-05	
00000000-0000-0000-0000-000000000000	7ad7c68e-cc8d-4648-88bb-6856626813cf	{"action":"user_signedup","actor_id":"028d1c22-0c21-416e-916a-b8543e0ba6a8","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"team"}	2024-05-01 10:56:47.165375-05	
00000000-0000-0000-0000-000000000000	c5b31345-1f83-417a-9d84-6f8020f0388b	{"action":"logout","actor_id":"028d1c22-0c21-416e-916a-b8543e0ba6a8","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-01 11:34:27.444888-05	
00000000-0000-0000-0000-000000000000	5cc32e6d-ae03-496a-835c-6c28141782d5	{"action":"user_confirmation_requested","actor_id":"dd36109d-05b5-4e0a-b5be-a6025c5b5c59","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-05-01 12:28:08.642458-05	
00000000-0000-0000-0000-000000000000	46398252-5ce0-41a6-9316-1c282e78152d	{"action":"user_signedup","actor_id":"dd36109d-05b5-4e0a-b5be-a6025c5b5c59","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"team"}	2024-05-01 12:30:04.751647-05	
00000000-0000-0000-0000-000000000000	1d4353f3-bcc7-41cc-a241-93ddcce93907	{"action":"user_recovery_requested","actor_id":"028d1c22-0c21-416e-916a-b8543e0ba6a8","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-05-01 13:37:23.934976-05	
00000000-0000-0000-0000-000000000000	91796600-8a47-4b22-8b63-c8275da6477f	{"action":"user_recovery_requested","actor_id":"028d1c22-0c21-416e-916a-b8543e0ba6a8","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-05-01 13:39:55.097161-05	
00000000-0000-0000-0000-000000000000	b25de8e1-bccd-47ac-831b-a32ee5f93531	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"a96f756d-79f9-4f4e-a00d-e2b5b9520004","user_phone":""}}	2024-05-01 13:48:41.787362-05	
00000000-0000-0000-0000-000000000000	56f1723b-5e56-435c-91be-48b75c6e0714	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"","user_id":"a874a276-af3d-4d86-8512-fd6a6fbfe15c","user_phone":""}}	2024-05-01 13:48:46.369248-05	
00000000-0000-0000-0000-000000000000	6a920d52-d248-4bfb-b729-6bfdd5df4ad7	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"thomasbarrath@gmail.com","user_id":"dd36109d-05b5-4e0a-b5be-a6025c5b5c59","user_phone":""}}	2024-05-01 13:48:50.369585-05	
00000000-0000-0000-0000-000000000000	1be54aa2-dce0-4ef9-967b-fcec80991bc0	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"barrathtb@gmail.com","user_id":"028d1c22-0c21-416e-916a-b8543e0ba6a8","user_phone":""}}	2024-05-01 13:48:53.913037-05	
00000000-0000-0000-0000-000000000000	375f14dc-10bd-48b1-bdee-015a1994eb72	{"action":"user_confirmation_requested","actor_id":"3e877824-fec6-4b87-a818-4ae233c08cea","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-05-01 16:25:31.298808-05	
00000000-0000-0000-0000-000000000000	bff94cda-2797-4643-80b0-d871003c7b0d	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"barrathtb@gmail.com","user_id":"3e877824-fec6-4b87-a818-4ae233c08cea","user_phone":""}}	2024-05-01 21:21:44.245187-05	
00000000-0000-0000-0000-000000000000	2fb56fed-ea55-48c2-8d62-ae82f5431ec4	{"action":"user_confirmation_requested","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-05-01 21:29:44.870774-05	
00000000-0000-0000-0000-000000000000	d08bf6b8-52bf-465c-ba06-4327053a61e7	{"action":"user_signedup","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"team"}	2024-05-01 21:31:13.643736-05	
00000000-0000-0000-0000-000000000000	6fcd9571-f849-41d4-ad3d-936cc8862910	{"action":"token_refreshed","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-01 22:31:06.18328-05	
00000000-0000-0000-0000-000000000000	ed86e94d-ef56-41d8-925f-eb9e5bbaeb2e	{"action":"token_revoked","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-01 22:31:06.18657-05	
00000000-0000-0000-0000-000000000000	b0084dd9-5f86-4547-a683-edf866833f2a	{"action":"logout","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-01 23:02:32.029171-05	
00000000-0000-0000-0000-000000000000	0811d06d-4f00-439c-8c4a-3dbca8e6b4ac	{"action":"user_recovery_requested","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-05-01 23:02:44.366386-05	
00000000-0000-0000-0000-000000000000	34032d9d-49eb-423e-8a23-fe73b1ea3d50	{"action":"login","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-01 23:03:23.844498-05	
00000000-0000-0000-0000-000000000000	bbfec242-827d-4087-b0d1-627246eb5649	{"action":"logout","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-01 23:11:11.476816-05	
00000000-0000-0000-0000-000000000000	2db6ad3c-072f-4bcd-89bd-7c713231b030	{"action":"user_confirmation_requested","actor_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-05-01 23:11:35.457342-05	
00000000-0000-0000-0000-000000000000	987dbab8-c3d8-46ff-a2cc-1cdda5f3a80b	{"action":"user_signedup","actor_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"team"}	2024-05-01 23:12:46.978656-05	
00000000-0000-0000-0000-000000000000	91a27170-e00a-4733-987b-63e10ecf56cf	{"action":"token_refreshed","actor_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-02 00:10:51.894649-05	
00000000-0000-0000-0000-000000000000	7895cb6d-5c9b-4f91-a5a2-8b182145ce99	{"action":"token_revoked","actor_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-02 00:10:51.896373-05	
00000000-0000-0000-0000-000000000000	c29fab3f-7658-4ede-b7cc-22c84d124695	{"action":"token_refreshed","actor_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-02 09:21:41.555912-05	
00000000-0000-0000-0000-000000000000	7b1484e8-b8cf-4f72-a4ac-3975351a0f63	{"action":"token_revoked","actor_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-02 09:21:41.565898-05	
00000000-0000-0000-0000-000000000000	54cfb3b7-b76b-4baf-bc27-b4e6d94ff096	{"action":"token_refreshed","actor_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-02 09:21:42.528526-05	
00000000-0000-0000-0000-000000000000	6c41e8e3-b2c1-44ae-a952-cd5278319898	{"action":"user_recovery_requested","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-05-06 12:11:03.446265-05	
00000000-0000-0000-0000-000000000000	fddf3777-96fd-4178-aa29-aa82d97df4af	{"action":"user_recovery_requested","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-05-06 12:22:42.920184-05	
00000000-0000-0000-0000-000000000000	6da32661-d6f3-4a91-836a-e441d15bf61d	{"action":"login","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-06 12:24:17.641878-05	
00000000-0000-0000-0000-000000000000	d4c6adf2-ef43-420b-96a6-3641a3fff746	{"action":"token_refreshed","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-06 13:25:09.545642-05	
00000000-0000-0000-0000-000000000000	925c040c-f597-4d22-b89f-64e5719b9a3b	{"action":"token_revoked","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-06 13:25:09.546279-05	
00000000-0000-0000-0000-000000000000	22f13761-6b02-425b-978f-e535d7db492d	{"action":"logout","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-06 13:46:56.434799-05	
00000000-0000-0000-0000-000000000000	33ecc814-e14a-43b8-bedd-eabbf3b1df86	{"action":"user_recovery_requested","actor_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-05-06 13:53:46.521371-05	
00000000-0000-0000-0000-000000000000	8f35ea52-9d5c-4817-85ca-e389f1b80f54	{"action":"login","actor_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-06 13:54:27.695079-05	
00000000-0000-0000-0000-000000000000	0cdca9a3-6c11-4ddc-8f8b-64c72901dfe1	{"action":"logout","actor_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-06 14:06:13.894685-05	
00000000-0000-0000-0000-000000000000	0c09bece-31ca-489e-a9c7-07a7bcbd2558	{"action":"user_recovery_requested","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-05-06 14:10:46.651377-05	
00000000-0000-0000-0000-000000000000	159bf52f-496d-4459-bace-fc4659d03ed0	{"action":"login","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-06 14:11:04.342739-05	
00000000-0000-0000-0000-000000000000	5c3254df-2a33-4335-adc4-672f749f03c0	{"action":"token_refreshed","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-06 15:13:18.010177-05	
00000000-0000-0000-0000-000000000000	e2d2925a-ac3c-4856-8b1c-f01fbbd2fd0f	{"action":"token_revoked","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-06 15:13:18.011642-05	
00000000-0000-0000-0000-000000000000	dcbd0099-2de8-4896-8ac8-0836d6a395b2	{"action":"token_refreshed","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-06 19:34:58.641478-05	
00000000-0000-0000-0000-000000000000	75090f8c-c667-4cb4-a4b2-ffb73c55ded6	{"action":"token_revoked","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-06 19:34:58.647525-05	
00000000-0000-0000-0000-000000000000	f9730608-36c9-486b-9f45-8f8ddc1b1023	{"action":"logout","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-06 19:40:41.986247-05	
00000000-0000-0000-0000-000000000000	8f9b5073-157a-4e16-8cd9-9f4418b42544	{"action":"user_recovery_requested","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-05-06 19:40:59.710399-05	
00000000-0000-0000-0000-000000000000	3e8bedce-e36e-4b5d-85c5-d63cfbc51d94	{"action":"login","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-06 19:41:23.445519-05	
00000000-0000-0000-0000-000000000000	a8ece747-c5f7-4c58-9d17-9669a49237c1	{"action":"token_refreshed","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-06 20:48:56.461954-05	
00000000-0000-0000-0000-000000000000	5fc86ba7-faa5-49df-a733-cc30d923e58d	{"action":"token_revoked","actor_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-06 20:48:56.4689-05	
00000000-0000-0000-0000-000000000000	81ca6d4c-0035-418b-92e1-21aad353189c	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"thomasbarrath@gmail.com","user_id":"1c1916f9-bc60-4ac4-8e5e-0e7d37af2df6","user_phone":""}}	2024-05-06 20:50:03.118307-05	
00000000-0000-0000-0000-000000000000	f3211d8c-f8a9-4f0f-9329-ef5616a81b60	{"action":"user_deleted","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","actor_via_sso":false,"log_type":"team","traits":{"user_email":"barrathtb@gmail.com","user_id":"17a2d13b-a47a-47ed-b2ed-072ebea46d7a","user_phone":""}}	2024-05-06 20:50:06.581185-05	
00000000-0000-0000-0000-000000000000	ec437332-b0df-4852-88cf-79366377b8ac	{"action":"user_confirmation_requested","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-05-07 00:06:02.970914-05	
00000000-0000-0000-0000-000000000000	dd343401-ff50-4c3e-81a6-7f6900674c01	{"action":"user_signedup","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"team"}	2024-05-07 00:10:34.119621-05	
00000000-0000-0000-0000-000000000000	cae003ea-89d9-438f-9b38-2b3daa66d8c5	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-07 00:33:15.069534-05	
00000000-0000-0000-0000-000000000000	9e233e64-b00d-4b43-8a89-098d9cd2348f	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-07 01:08:33.909932-05	
00000000-0000-0000-0000-000000000000	e9a670ab-17ab-433d-95f3-f77682bf9c44	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-07 10:07:06.303973-05	
00000000-0000-0000-0000-000000000000	a47e071d-f619-47b9-9b4d-130dad0e2e2d	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-07 10:07:06.304571-05	
00000000-0000-0000-0000-000000000000	c0011e75-be28-4b08-a710-8d05a42133d7	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-07 10:07:07.296481-05	
00000000-0000-0000-0000-000000000000	f8bf2586-e30b-4e8e-a5d8-72a3056d467d	{"action":"user_recovery_requested","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-05-08 15:26:12.478122-05	
00000000-0000-0000-0000-000000000000	54f2d99f-4a67-4df4-bfaa-8c7b277d7a75	{"action":"user_recovery_requested","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"user"}	2024-05-08 16:11:02.995247-05	
00000000-0000-0000-0000-000000000000	f705f769-8194-40c2-a40a-0c9910634e2d	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-08 16:11:45.315458-05	
00000000-0000-0000-0000-000000000000	8c586298-e444-4ae3-9dc4-c7b3e4867c5c	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 17:09:50.282198-05	
00000000-0000-0000-0000-000000000000	0dab03c0-3424-4fa6-8b89-3e7d9193ea1d	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 17:09:50.282822-05	
00000000-0000-0000-0000-000000000000	2a3cfc40-d5fc-49af-8398-a35c5e472ccf	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 18:08:16.020741-05	
00000000-0000-0000-0000-000000000000	f6bb66a3-ae20-46a8-a81d-d54d17a71ca4	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 18:08:16.02227-05	
00000000-0000-0000-0000-000000000000	43377633-c132-4dde-92cc-bae83ba3f70c	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 19:06:41.708673-05	
00000000-0000-0000-0000-000000000000	d55b41fd-ee83-4043-ab15-91a5829a9c35	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 19:06:41.709237-05	
00000000-0000-0000-0000-000000000000	8cc20275-cfb2-49d9-afee-cb01b8a657a0	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 20:06:50.044703-05	
00000000-0000-0000-0000-000000000000	13165c22-97c1-446c-ac5c-07ebf67443e5	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 20:06:50.046282-05	
00000000-0000-0000-0000-000000000000	18592c07-af29-4aa1-aca9-3cdadb1d781e	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 21:41:57.65477-05	
00000000-0000-0000-0000-000000000000	74cb84ec-468e-4b3c-9e7c-39e1e6d5d835	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 21:41:57.655353-05	
00000000-0000-0000-0000-000000000000	fefba44f-c7f5-4429-826c-77903787414b	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 22:40:24.538291-05	
00000000-0000-0000-0000-000000000000	677e6ebe-b6e0-4563-97a6-915658c1ad72	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 22:40:24.538923-05	
00000000-0000-0000-0000-000000000000	fb1ffb0d-33ee-4427-9ed4-053adf7d1bc6	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 23:38:54.58417-05	
00000000-0000-0000-0000-000000000000	bc3a1eea-a9b4-49df-915a-a3b8414633c4	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-08 23:38:54.584768-05	
00000000-0000-0000-0000-000000000000	435f1849-9470-44ae-a19f-0dbae4fd51d2	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 00:36:55.354568-05	
00000000-0000-0000-0000-000000000000	604f7b77-2b92-4fbe-81a2-45bef7cf2904	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 00:36:55.355267-05	
00000000-0000-0000-0000-000000000000	4137b41f-c6ff-4b7c-bfe0-685660ba4587	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 01:35:21.687271-05	
00000000-0000-0000-0000-000000000000	a4115f68-a909-45da-9e2d-fb1906e94350	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 01:35:21.687887-05	
00000000-0000-0000-0000-000000000000	de7c8c50-dc9e-4619-af0f-1ecc98b9d4b0	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 08:24:54.339272-05	
00000000-0000-0000-0000-000000000000	b65f7edf-c9b8-43bc-ad15-36763dd63d07	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 08:24:54.342067-05	
00000000-0000-0000-0000-000000000000	5a82e185-0866-40c2-a03b-7ec23609d67d	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 09:39:05.631118-05	
00000000-0000-0000-0000-000000000000	76c65413-9c5d-4153-aaf6-24045250ebe0	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 09:39:05.631752-05	
00000000-0000-0000-0000-000000000000	e7e2227c-7459-4ae8-bb32-bd3a5d6a333f	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 10:40:06.586587-05	
00000000-0000-0000-0000-000000000000	d4acd96b-7ce9-4286-a4f4-da70999d44e2	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 10:40:06.587224-05	
00000000-0000-0000-0000-000000000000	1f567dd6-34fe-4b43-ac6e-81c43515e135	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 11:38:23.956879-05	
00000000-0000-0000-0000-000000000000	6d0eb1be-1aa5-4a81-bc9c-f6d048e484ca	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 11:38:23.957488-05	
00000000-0000-0000-0000-000000000000	165d68d4-737b-4fde-b789-7a4af5ed2130	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 22:36:49.514394-05	
00000000-0000-0000-0000-000000000000	09b2374e-86a2-49a5-aa8b-0a333814a4ba	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-09 22:36:49.515319-05	
00000000-0000-0000-0000-000000000000	4fd3068c-9299-4b93-a58e-a0814a0ab1a6	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-09 23:01:08.218031-05	
00000000-0000-0000-0000-000000000000	71e8f529-33f8-4841-8c06-4eda94b8282a	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-09 23:01:23.3406-05	
00000000-0000-0000-0000-000000000000	a4f79899-359b-4cf5-abbb-52339e9e9920	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-09 23:01:53.01925-05	
00000000-0000-0000-0000-000000000000	f786479d-f482-4ffb-867a-97bf33b81dd7	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-09 23:14:51.96121-05	
00000000-0000-0000-0000-000000000000	98b9e1c6-a9ae-4c9a-9a69-241fd40cd7c2	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 00:13:09.512921-05	
00000000-0000-0000-0000-000000000000	c3efdf04-8def-4edb-b19e-4a28b4ebe8c4	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 00:13:09.51378-05	
00000000-0000-0000-0000-000000000000	22f8f261-4de1-406a-b7e1-ca77d2a42040	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 07:56:52.710561-05	
00000000-0000-0000-0000-000000000000	0170692a-bd54-4257-9f80-e30bc0a5c03b	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 07:56:52.711836-05	
00000000-0000-0000-0000-000000000000	3af4e11c-299e-4650-8f2e-d778e95ebcab	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 08:50:18.896511-05	
00000000-0000-0000-0000-000000000000	0f4cdbe8-e7bc-41c3-887c-17010df381dc	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 09:48:31.12536-05	
00000000-0000-0000-0000-000000000000	5a97a6b7-1078-48fb-ac52-d06bc71f7fb0	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 09:48:31.12632-05	
00000000-0000-0000-0000-000000000000	d3610d40-fde2-4cef-8a2d-9ee8c5ef7ab9	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 22:57:26.337127-05	
00000000-0000-0000-0000-000000000000	0ae1644e-fbd7-49ee-8e9b-e0f7d8a1862d	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 22:57:26.338113-05	
00000000-0000-0000-0000-000000000000	266c24b0-a36c-4c7c-906c-a0a7d7e84e84	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 23:55:37.964306-05	
00000000-0000-0000-0000-000000000000	6cb33fba-ed51-4a41-bd23-8e510989765e	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-10 23:55:37.965384-05	
00000000-0000-0000-0000-000000000000	e7ac005e-357a-4ee0-8f83-25dcc093533e	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-11 00:53:56.027469-05	
00000000-0000-0000-0000-000000000000	9af94e9d-cb84-4a63-b99a-736be3fb4b0a	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-11 00:53:56.028568-05	
00000000-0000-0000-0000-000000000000	841a8610-ee82-447f-bdff-6bba8779d3db	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 18:02:43.26881-05	
00000000-0000-0000-0000-000000000000	99289305-c237-4d2e-82d5-a16843fba43c	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 18:02:43.269737-05	
00000000-0000-0000-0000-000000000000	8793ab66-77a1-4e39-a3f8-a4f8515bd172	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 19:00:44.822632-05	
00000000-0000-0000-0000-000000000000	e1fa3132-a34f-49ef-b93d-148997ee731e	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 19:00:44.8235-05	
00000000-0000-0000-0000-000000000000	c540b944-5eb0-4b23-9f75-9f5d18487d5b	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-12 19:01:05.202452-05	
00000000-0000-0000-0000-000000000000	869106d1-8eb3-4747-a5b6-c1be44bf11bf	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-12 19:01:20.323488-05	
00000000-0000-0000-0000-000000000000	b2192ed8-801f-48eb-889f-e4c0bbb0a057	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 19:59:44.980209-05	
00000000-0000-0000-0000-000000000000	9f25c186-2e71-4c19-84b3-ff75503b9e0b	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 19:59:44.981022-05	
00000000-0000-0000-0000-000000000000	b32aaece-1611-4e1e-8f05-0f0657caed6e	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 20:58:08.192723-05	
00000000-0000-0000-0000-000000000000	019de1b4-e3da-4256-841f-6906c5288b3e	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 20:58:08.193576-05	
00000000-0000-0000-0000-000000000000	d6ef683a-442c-434e-ad3e-eacf43bb7724	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 21:56:11.426789-05	
00000000-0000-0000-0000-000000000000	2c975c27-a9ca-426c-b72e-68986cda2889	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 21:56:11.427702-05	
00000000-0000-0000-0000-000000000000	cd98fd5a-fd1a-4491-b501-5ab305fcf054	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 22:54:11.375919-05	
00000000-0000-0000-0000-000000000000	d83b6f5a-c6a0-455a-abad-45957654f733	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 22:54:11.376831-05	
00000000-0000-0000-0000-000000000000	b14b07a6-96ff-4111-ad56-560e412354ec	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 23:52:12.924455-05	
00000000-0000-0000-0000-000000000000	427e4f81-a483-4b77-b4c9-a23c93eb4323	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-12 23:52:12.925272-05	
00000000-0000-0000-0000-000000000000	aed448e2-eb70-4587-9218-bc4551f674cc	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 08:59:46.210127-05	
00000000-0000-0000-0000-000000000000	5e50ffc4-5ad5-4dd5-a846-9d5c2ce3002a	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 08:59:46.210985-05	
00000000-0000-0000-0000-000000000000	a63e9484-1831-44a2-9532-023af1793ce6	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 09:35:28.714389-05	
00000000-0000-0000-0000-000000000000	64f3cea5-4579-40f1-a316-4a9b19050e6a	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 09:35:49.530089-05	
00000000-0000-0000-0000-000000000000	14e56e56-1469-4517-a99e-26004f6dab2b	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 09:40:29.518413-05	
00000000-0000-0000-0000-000000000000	d127c3d9-79fa-4002-bfa8-5cd5e5e4e408	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 09:40:37.062432-05	
00000000-0000-0000-0000-000000000000	25ac8a55-5004-4716-a9be-59f6beafd066	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 09:41:25.729049-05	
00000000-0000-0000-0000-000000000000	66ff0182-72ce-431f-8a1e-1e971370a704	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 09:41:34.088197-05	
00000000-0000-0000-0000-000000000000	65b8637c-32bf-469c-a614-159eb8b821cb	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 09:44:15.302653-05	
00000000-0000-0000-0000-000000000000	9dcf750b-6555-47ff-baf0-17f592792c07	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 09:44:22.526738-05	
00000000-0000-0000-0000-000000000000	9c87ce5e-f266-4fe1-b039-97acfb30e42a	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 09:45:38.211536-05	
00000000-0000-0000-0000-000000000000	86a4c231-723c-49d9-91ac-695df490835b	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 09:45:59.553147-05	
00000000-0000-0000-0000-000000000000	b10a9700-2510-4b1b-ac2a-399ae4f6b918	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 09:49:58.5265-05	
00000000-0000-0000-0000-000000000000	00cac055-b446-45d9-956b-03318994d9aa	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 09:50:05.618177-05	
00000000-0000-0000-0000-000000000000	f800ef09-53f8-4fcb-820b-2057157835ef	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 09:56:27.933009-05	
00000000-0000-0000-0000-000000000000	8b35484b-56c0-445e-a091-58a98a268773	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 09:59:08.436306-05	
00000000-0000-0000-0000-000000000000	f39ace0b-033e-468f-8c2d-bb38aecb69aa	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 10:41:38.903504-05	
00000000-0000-0000-0000-000000000000	7c400899-dabe-4fc6-8313-92d8ffd5c46e	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 10:41:58.992694-05	
00000000-0000-0000-0000-000000000000	12201d3f-097d-4be4-a280-be932e4b3262	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 10:42:11.508158-05	
00000000-0000-0000-0000-000000000000	83be71c5-dc4b-403c-9c6e-0550f6cc5198	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 10:42:27.510305-05	
00000000-0000-0000-0000-000000000000	f81500b7-03ed-4708-aa3e-de75db879a29	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 10:51:40.995316-05	
00000000-0000-0000-0000-000000000000	d97da273-d3d4-493e-afbe-287ee97805da	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 10:51:46.242601-05	
00000000-0000-0000-0000-000000000000	f3b15d16-591b-44a9-8d75-19c1c2a4099a	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 10:52:31.55886-05	
00000000-0000-0000-0000-000000000000	0f3f9f86-d6da-4b87-8268-267df287568d	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 11:02:56.127335-05	
00000000-0000-0000-0000-000000000000	6fbfba25-2604-4339-90c8-b8a5f1e19fe6	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 11:05:54.181367-05	
00000000-0000-0000-0000-000000000000	370553a3-5d74-4090-991b-3b1854a09957	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 11:11:55.97756-05	
00000000-0000-0000-0000-000000000000	3830ee57-9ea5-4312-b09e-2abe91927e19	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 11:14:19.337415-05	
00000000-0000-0000-0000-000000000000	096c3f30-2263-4872-9fb6-63de24fa1c5a	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 11:58:31.187-05	
00000000-0000-0000-0000-000000000000	cf641cf4-3cb8-4162-a21f-e87edd1e8e9c	{"action":"user_confirmation_requested","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"user","traits":{"provider":"email"}}	2024-05-13 11:59:50.85312-05	
00000000-0000-0000-0000-000000000000	a4be9218-5732-43b2-8bbb-1678deef6b0f	{"action":"user_signedup","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"team"}	2024-05-13 12:12:04.218322-05	
00000000-0000-0000-0000-000000000000	3d616af7-998e-4656-b141-44641ffb5013	{"action":"logout","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 12:27:06.503769-05	
00000000-0000-0000-0000-000000000000	17a5306a-6db8-48c0-94cf-2d6756517cff	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 13:27:43.879474-05	
00000000-0000-0000-0000-000000000000	1840bcef-1eca-4277-aee0-f9e7f8a9165f	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 13:29:21.141686-05	
00000000-0000-0000-0000-000000000000	e063ec45-f026-4927-bc53-ae75bb8a403a	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 14:32:59.633652-05	
00000000-0000-0000-0000-000000000000	b4c51fa0-1a78-4d0e-8173-95ae2840d9fb	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 14:32:59.634561-05	
00000000-0000-0000-0000-000000000000	a22c4114-6a7a-48e8-aeea-2bf45d6e66fe	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 15:33:22.397205-05	
00000000-0000-0000-0000-000000000000	e9fa23f5-a7f5-4a45-9767-67ae2d06174d	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 15:33:22.397998-05	
00000000-0000-0000-0000-000000000000	cd159997-17b3-4ed6-b0a1-fc5a4941adf7	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 16:31:41.423737-05	
00000000-0000-0000-0000-000000000000	6cb44e08-5d7c-424b-b6c4-84c87ed641da	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 16:31:41.424602-05	
00000000-0000-0000-0000-000000000000	106bdd11-2f22-45bd-9fcf-d663a3bd9b3a	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 17:29:56.390389-05	
00000000-0000-0000-0000-000000000000	f4b6ec09-975c-4153-827c-c712d01a47b3	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 17:29:56.391243-05	
00000000-0000-0000-0000-000000000000	522dc841-ea22-4523-b293-b8755aa424fc	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 19:31:51.792523-05	
00000000-0000-0000-0000-000000000000	c15deb30-1ae0-4724-9ad5-c83d90e0500a	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 19:31:51.793338-05	
00000000-0000-0000-0000-000000000000	f417efae-7cc1-4b55-a903-e3ee9d24ad9b	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 20:30:03.809008-05	
00000000-0000-0000-0000-000000000000	5efc610a-44e2-4e7b-a4af-414f9358c130	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 20:30:03.809907-05	
00000000-0000-0000-0000-000000000000	5528d6a3-ad71-4d26-8e1b-79e9226dbdab	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 21:28:10.843055-05	
00000000-0000-0000-0000-000000000000	8870487d-e675-4d20-8e48-dfb6eb75e57e	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 21:28:10.843992-05	
00000000-0000-0000-0000-000000000000	aab193d0-eedf-4b15-a314-c0e364543885	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 22:26:17.261258-05	
00000000-0000-0000-0000-000000000000	a3b04dd5-6438-402d-95c8-d9adb80221eb	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-13 22:26:17.262092-05	
00000000-0000-0000-0000-000000000000	bff4b5b9-72cd-4a00-8b7a-6f2ad6266f09	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-13 23:13:04.806784-05	
00000000-0000-0000-0000-000000000000	2f556cae-8206-42b1-9d2a-c78fa18e9f92	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-13 23:13:12.286646-05	
00000000-0000-0000-0000-000000000000	8c99cea0-6ca4-4ec1-b8c8-979ff95cb39a	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-14 00:11:27.572-05	
00000000-0000-0000-0000-000000000000	2a718265-6207-42e9-ac0f-d509974ee568	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-14 00:11:27.572871-05	
00000000-0000-0000-0000-000000000000	881faf17-a0d5-4f27-8465-8259f79906a1	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-14 01:09:29.409153-05	
00000000-0000-0000-0000-000000000000	17330517-e951-4352-859c-609f3d87aeac	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-14 01:09:29.410045-05	
00000000-0000-0000-0000-000000000000	a0d6f49b-0511-4ff9-a8c0-3b89b8c1fd80	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-14 10:10:49.11194-05	
00000000-0000-0000-0000-000000000000	5c662122-89e0-44b7-a448-31bfb0dfb0e2	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-14 10:10:49.114319-05	
00000000-0000-0000-0000-000000000000	a2cc0715-e73a-46b6-a547-2037507bcad8	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-14 11:15:51.499989-05	
00000000-0000-0000-0000-000000000000	1b8eb73e-e1ac-4e4a-be4a-2278885cabac	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-14 11:15:51.501484-05	
00000000-0000-0000-0000-000000000000	0e7dbe87-e8e9-4e0b-8546-10d3c3da9585	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 12:55:31.668048-05	
00000000-0000-0000-0000-000000000000	b798162f-acd0-4a57-8428-2a52e7c49377	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 12:55:31.669871-05	
00000000-0000-0000-0000-000000000000	892533df-37bd-466f-bdb1-50eb9ecade6c	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 13:53:45.469936-05	
00000000-0000-0000-0000-000000000000	34aa4068-fd1c-40ba-acae-e160a71c0211	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 13:53:45.471701-05	
00000000-0000-0000-0000-000000000000	9265fcea-818a-4ccd-aba6-ced5ac768906	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 14:52:06.069846-05	
00000000-0000-0000-0000-000000000000	1a1f4b79-40ab-416b-b6ce-1486f3b15007	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 14:52:06.070735-05	
00000000-0000-0000-0000-000000000000	0b4afeba-8506-4623-a3a0-664220b00d7a	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 15:50:26.010713-05	
00000000-0000-0000-0000-000000000000	3d27b36a-cb0c-4696-a0d9-bd378e103a19	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 15:50:26.012649-05	
00000000-0000-0000-0000-000000000000	938cc8cd-1f00-4e48-8915-98a9b35675d2	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-15 16:09:57.703569-05	
00000000-0000-0000-0000-000000000000	dfe71181-00c4-4d88-9b7e-d65c3332974f	{"action":"login","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-15 16:15:50.960308-05	
00000000-0000-0000-0000-000000000000	1b908dc8-53fb-4ceb-8b20-6cb2652986e9	{"action":"token_refreshed","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 17:14:12.011014-05	
00000000-0000-0000-0000-000000000000	09a29aa0-61f5-4fe8-81fd-9e3296531c10	{"action":"token_revoked","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 17:14:12.012735-05	
00000000-0000-0000-0000-000000000000	1b0770c0-8b42-4d7a-9d55-0c20fb5ec029	{"action":"token_refreshed","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 18:12:42.091593-05	
00000000-0000-0000-0000-000000000000	8a6f45d1-3210-46c1-bbba-69cccc631d00	{"action":"token_revoked","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 18:12:42.094514-05	
00000000-0000-0000-0000-000000000000	d6db6e98-ae1b-4c48-8db0-b9636b760abd	{"action":"token_refreshed","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 19:11:12.180151-05	
00000000-0000-0000-0000-000000000000	f2dad97c-7483-4a48-b0c4-a71eb65fb0d9	{"action":"token_revoked","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 19:11:12.181866-05	
00000000-0000-0000-0000-000000000000	9e4e94b7-5095-46fe-be47-ae7688e52ba3	{"action":"token_refreshed","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 20:09:42.109408-05	
00000000-0000-0000-0000-000000000000	bca155bd-b8ff-4790-abe9-260c53334df7	{"action":"token_revoked","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 20:09:42.11127-05	
00000000-0000-0000-0000-000000000000	231b4f98-e8e8-489d-8960-7cd7f6f1ec18	{"action":"token_refreshed","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 21:08:12.11045-05	
00000000-0000-0000-0000-000000000000	c83aaba9-b60a-47ec-b48a-4bc0bf37c666	{"action":"token_revoked","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 21:08:12.112758-05	
00000000-0000-0000-0000-000000000000	3d34f9b9-ec85-41da-beae-2965274df8da	{"action":"token_refreshed","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 22:06:42.07701-05	
00000000-0000-0000-0000-000000000000	43b41a44-e552-4d79-9659-f22878516753	{"action":"token_revoked","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-15 22:06:42.07939-05	
00000000-0000-0000-0000-000000000000	bfbd5436-c1b9-48f9-ba71-132203f52ac5	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:01:45.32665-05	
00000000-0000-0000-0000-000000000000	15fc5e17-cbc1-4d95-88b4-3e7f257716a9	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:08:01.409883-05	
00000000-0000-0000-0000-000000000000	0376d167-3c73-480e-8e93-930a87aa793b	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:08:26.66654-05	
00000000-0000-0000-0000-000000000000	7fed5513-3b69-4f63-81cc-a9ff4147a39f	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:11:27.441429-05	
00000000-0000-0000-0000-000000000000	5eb51089-e611-4831-a2e1-d7b67267a236	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:13:27.913815-05	
00000000-0000-0000-0000-000000000000	f0b38449-c540-47bc-9302-83b334b9510a	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:14:40.604301-05	
00000000-0000-0000-0000-000000000000	32f74727-5399-40bd-9b88-2b2e3be58a39	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:15:02.396334-05	
00000000-0000-0000-0000-000000000000	f81c7529-5d48-4e58-a5d6-c5464ad4eab9	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:16:03.31544-05	
00000000-0000-0000-0000-000000000000	bd927915-aff9-4153-89f6-931314406ebd	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:16:23.849896-05	
00000000-0000-0000-0000-000000000000	31854238-3e72-4f43-9881-aa7a75b83859	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:17:23.021702-05	
00000000-0000-0000-0000-000000000000	41600436-12a1-49ea-9100-0a39686f8b6c	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:31:17.968805-05	
00000000-0000-0000-0000-000000000000	e8f0e44b-c01d-4c25-92a4-3ccdcb3aabd6	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:37:26.477831-05	
00000000-0000-0000-0000-000000000000	c318c0ce-b690-4463-abfd-3f89baff84a4	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 11:41:05.207422-05	
00000000-0000-0000-0000-000000000000	7210e143-2c6e-4e10-af6e-7d7dd00b80e6	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-16 11:51:58.486938-05	
00000000-0000-0000-0000-000000000000	7dd662ea-23d9-46f8-8d5e-1729c7c2faf5	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 12:29:10.425279-05	
00000000-0000-0000-0000-000000000000	56693c0e-3fc9-4424-b405-6494f0e89474	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 12:31:37.347781-05	
00000000-0000-0000-0000-000000000000	2e98d3c1-c50f-4840-a793-40427a80100c	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 12:46:10.96067-05	
00000000-0000-0000-0000-000000000000	4f2f6ed6-fe49-4b54-a821-b8af13849778	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 12:57:06.825935-05	
00000000-0000-0000-0000-000000000000	11916a3e-594b-43d5-829f-8f6417d28276	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 12:58:07.281395-05	
00000000-0000-0000-0000-000000000000	4258679e-d7c3-4a87-99ae-cc2ac50e1029	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 13:04:26.814633-05	
00000000-0000-0000-0000-000000000000	46844e0e-ae32-4edb-aa7b-51f8bdca7376	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 13:05:07.883274-05	
00000000-0000-0000-0000-000000000000	d8cc396c-6fc1-4bc6-bbd2-d91f85f75a7b	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-16 13:28:54.50148-05	
00000000-0000-0000-0000-000000000000	7302c04f-6bc0-42eb-bc44-49f5d0a45dae	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2024-05-16 13:44:25.540109-05	
00000000-0000-0000-0000-000000000000	84eadea6-1305-4d67-967c-4a7cfb1cd766	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-16 13:51:10.387315-05	
00000000-0000-0000-0000-000000000000	5e069738-a473-411a-a1b7-658cb64525c1	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2024-05-16 13:56:50.533958-05	
00000000-0000-0000-0000-000000000000	a91317fa-5ed0-41ac-bb9c-2cd66c454cb8	{"action":"logout","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account"}	2024-05-16 14:00:07.518434-05	
00000000-0000-0000-0000-000000000000	8a01238e-b4a8-405e-a7e1-ae84d5492739	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"google"}}	2024-05-16 14:22:48.080657-05	
00000000-0000-0000-0000-000000000000	210e7b7b-7a75-4c44-b4e3-555ec623fd74	{"action":"login","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"account","traits":{"provider":"email"}}	2024-05-16 14:23:39.499711-05	
00000000-0000-0000-0000-000000000000	d076a629-f054-4a68-bad7-70cffd706f52	{"action":"token_refreshed","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-16 14:25:31.613609-05	
00000000-0000-0000-0000-000000000000	8fee299d-c7a7-42c7-a6a5-25bdb7483a6a	{"action":"token_revoked","actor_id":"febd26f0-a0f3-45e1-ae65-dbdad2947429","actor_name":"Thomas Barrath","actor_username":"thomasbarrath@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-16 14:25:31.614433-05	
00000000-0000-0000-0000-000000000000	5a922de9-9726-4a1b-b906-7bede3132183	{"action":"token_refreshed","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-26 12:18:18.350067-05	
00000000-0000-0000-0000-000000000000	e0e59801-34bf-494e-b608-5376a8aff4ce	{"action":"token_revoked","actor_id":"2fa8db11-64cd-4b26-b8bf-94b2191bb88b","actor_name":"Thomas Barrath","actor_username":"barrathtb@gmail.com","actor_via_sso":false,"log_type":"token"}	2024-05-26 12:18:18.355456-05	
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	{"sub": "2fa8db11-64cd-4b26-b8bf-94b2191bb88b", "email": "barrathtb@gmail.com", "email_verified": false, "phone_verified": false}	email	2024-05-07 00:06:02.968214-05	2024-05-07 00:06:02.968277-05	2024-05-07 00:06:02.968277-05	e5bf444e-8af9-40b4-b7c1-d919112595af
114196564114831451267	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	{"iss": "https://accounts.google.com", "sub": "114196564114831451267", "name": "Thomas Barrath", "email": "barrathtb@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocJGpJahlLWtnCBZ5CcN6PxwQSE2TZdf7kQ49LI8Nbo886_31mM=s96-c", "full_name": "Thomas Barrath", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocJGpJahlLWtnCBZ5CcN6PxwQSE2TZdf7kQ49LI8Nbo886_31mM=s96-c", "provider_id": "114196564114831451267", "email_verified": true, "phone_verified": false}	google	2024-05-07 01:08:33.906963-05	2024-05-07 01:08:33.907017-05	2024-05-16 14:22:48.066438-05	1fd9547a-d403-489f-8528-d6a1b010a096
febd26f0-a0f3-45e1-ae65-dbdad2947429	febd26f0-a0f3-45e1-ae65-dbdad2947429	{"sub": "febd26f0-a0f3-45e1-ae65-dbdad2947429", "email": "thomasbarrath@gmail.com", "email_verified": false, "phone_verified": false}	email	2024-05-13 11:59:50.850772-05	2024-05-13 11:59:50.850827-05	2024-05-13 11:59:50.850827-05	b932d1a7-0fb2-415e-96e5-2f033e752fa2
113173765869777981430	febd26f0-a0f3-45e1-ae65-dbdad2947429	{"iss": "https://accounts.google.com", "sub": "113173765869777981430", "name": "Thomas Barrath", "email": "thomasbarrath@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocKCYVVII3Cq0xLkYDqyqwjqQmFR_3nIJD4bSlxqWaumL0soOg=s96-c", "full_name": "Thomas Barrath", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocKCYVVII3Cq0xLkYDqyqwjqQmFR_3nIJD4bSlxqWaumL0soOg=s96-c", "provider_id": "113173765869777981430", "email_verified": true, "phone_verified": false}	google	2024-05-15 16:15:50.956414-05	2024-05-15 16:15:50.956468-05	2024-05-15 16:15:50.956468-05	7434e3f6-9710-44b9-818c-b69f1791c7f2
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
c50ba08d-3ba8-48e0-9533-5b240aedb562	2024-05-16 14:22:48.090541-05	2024-05-16 14:22:48.090541-05	oauth	d456df4e-d49d-48ae-9be5-7d61f8e94bc8
5d0a1db7-5099-48d9-b5cc-a2172d5b725e	2024-05-16 14:23:39.502619-05	2024-05-16 14:23:39.502619-05	password	873d9aad-1997-478d-8156-86dfd8da4600
0a82630f-88b0-46ae-a00e-e0dc45eee9d6	2024-05-15 16:15:50.969248-05	2024-05-15 16:15:50.969248-05	oauth	83cec78c-21f2-4678-aa85-73dbac8040ee
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	105	R3MpmPWJi1CRK8HpTaIBwQ	febd26f0-a0f3-45e1-ae65-dbdad2947429	t	2024-05-15 16:15:50.964789-05	2024-05-15 17:14:12.013412-05	\N	0a82630f-88b0-46ae-a00e-e0dc45eee9d6
00000000-0000-0000-0000-000000000000	106	kXr2BopgUP7_9KiN083o4w	febd26f0-a0f3-45e1-ae65-dbdad2947429	t	2024-05-15 17:14:12.014828-05	2024-05-15 18:12:42.095202-05	R3MpmPWJi1CRK8HpTaIBwQ	0a82630f-88b0-46ae-a00e-e0dc45eee9d6
00000000-0000-0000-0000-000000000000	107	jQeu8hUGmc4G7y6Ts3XE5w	febd26f0-a0f3-45e1-ae65-dbdad2947429	t	2024-05-15 18:12:42.0961-05	2024-05-15 19:11:12.182454-05	kXr2BopgUP7_9KiN083o4w	0a82630f-88b0-46ae-a00e-e0dc45eee9d6
00000000-0000-0000-0000-000000000000	108	0b9REoCwWc2xCxsOiGKRIg	febd26f0-a0f3-45e1-ae65-dbdad2947429	t	2024-05-15 19:11:12.183195-05	2024-05-15 20:09:42.111966-05	jQeu8hUGmc4G7y6Ts3XE5w	0a82630f-88b0-46ae-a00e-e0dc45eee9d6
00000000-0000-0000-0000-000000000000	109	P5lvoWdwErFTzAvp_VXxwA	febd26f0-a0f3-45e1-ae65-dbdad2947429	t	2024-05-15 20:09:42.11282-05	2024-05-15 21:08:12.113342-05	0b9REoCwWc2xCxsOiGKRIg	0a82630f-88b0-46ae-a00e-e0dc45eee9d6
00000000-0000-0000-0000-000000000000	110	hMLms2jF_7BxlrkHzZ9m2A	febd26f0-a0f3-45e1-ae65-dbdad2947429	t	2024-05-15 21:08:12.114064-05	2024-05-15 22:06:42.080087-05	P5lvoWdwErFTzAvp_VXxwA	0a82630f-88b0-46ae-a00e-e0dc45eee9d6
00000000-0000-0000-0000-000000000000	134	Etw36Odw5tN0WuOlILYHpg	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	f	2024-05-16 14:22:48.084168-05	2024-05-16 14:22:48.084168-05	\N	c50ba08d-3ba8-48e0-9533-5b240aedb562
00000000-0000-0000-0000-000000000000	111	QkVKOpN5F3z0IYnjChp9hg	febd26f0-a0f3-45e1-ae65-dbdad2947429	t	2024-05-15 22:06:42.08094-05	2024-05-16 14:25:31.61493-05	hMLms2jF_7BxlrkHzZ9m2A	0a82630f-88b0-46ae-a00e-e0dc45eee9d6
00000000-0000-0000-0000-000000000000	136	VSLaGo1oxwdReHvkQRmHGA	febd26f0-a0f3-45e1-ae65-dbdad2947429	f	2024-05-16 14:25:31.616127-05	2024-05-16 14:25:31.616127-05	QkVKOpN5F3z0IYnjChp9hg	0a82630f-88b0-46ae-a00e-e0dc45eee9d6
00000000-0000-0000-0000-000000000000	135	mLcnVsBXLQQn9BRt_pSIoQ	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	t	2024-05-16 14:23:39.501383-05	2024-05-26 12:18:18.356062-05	\N	5d0a1db7-5099-48d9-b5cc-a2172d5b725e
00000000-0000-0000-0000-000000000000	137	xtBVa68Stp3tTqXSrk4KAA	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	f	2024-05-26 12:18:18.358714-05	2024-05-26 12:18:18.358714-05	mLcnVsBXLQQn9BRt_pSIoQ	5d0a1db7-5099-48d9-b5cc-a2172d5b725e
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
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
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
c50ba08d-3ba8-48e0-9533-5b240aedb562	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-16 14:22:48.082665-05	2024-05-16 14:22:48.082665-05	\N	aal1	\N	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0	76.58.188.194	\N
0a82630f-88b0-46ae-a00e-e0dc45eee9d6	febd26f0-a0f3-45e1-ae65-dbdad2947429	2024-05-15 16:15:50.962141-05	2024-05-16 14:25:31.618447-05	\N	aal1	\N	2024-05-16 19:25:31.618378	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36	76.58.188.194	\N
5d0a1db7-5099-48d9-b5cc-a2172d5b725e	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-16 14:23:39.500599-05	2024-05-26 12:18:18.366548-05	\N	aal1	\N	2024-05-26 17:18:18.366466	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36 Edg/125.0.0.0	98.144.140.207	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	febd26f0-a0f3-45e1-ae65-dbdad2947429	authenticated	authenticated	thomasbarrath@gmail.com	$2a$10$lkEMcQJOeUvKG6isTsi6Be4z3uFCbCPo01mbiZJ/9o7w8YyzPZtMW	2024-05-13 12:12:04.219152-05	\N		2024-05-13 11:59:50.853768-05		\N			\N	2024-05-15 16:15:50.962053-05	{"provider": "email", "providers": ["email", "google"]}	{"iss": "https://accounts.google.com", "sub": "113173765869777981430", "name": "Thomas Barrath", "email": "thomasbarrath@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocKCYVVII3Cq0xLkYDqyqwjqQmFR_3nIJD4bSlxqWaumL0soOg=s96-c", "full_name": "Thomas Barrath", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocKCYVVII3Cq0xLkYDqyqwjqQmFR_3nIJD4bSlxqWaumL0soOg=s96-c", "provider_id": "113173765869777981430", "email_verified": true, "phone_verified": false}	\N	2024-05-13 11:59:50.846057-05	2024-05-16 14:25:31.617246-05	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	authenticated	authenticated	barrathtb@gmail.com	$2a$10$07/UZGBS4FwkpIAt26x5/O8yCJ8mlFOmwtALi31NvyfIbsWwfUZL2	2024-05-07 00:10:34.121137-05	\N		2024-05-07 00:06:02.973883-05		2024-05-08 16:11:02.995849-05			\N	2024-05-16 14:23:39.500514-05	{"provider": "email", "providers": ["email", "google"]}	{"iss": "https://accounts.google.com", "sub": "114196564114831451267", "name": "Thomas Barrath", "email": "barrathtb@gmail.com", "picture": "https://lh3.googleusercontent.com/a/ACg8ocJGpJahlLWtnCBZ5CcN6PxwQSE2TZdf7kQ49LI8Nbo886_31mM=s96-c", "full_name": "Thomas Barrath", "avatar_url": "https://lh3.googleusercontent.com/a/ACg8ocJGpJahlLWtnCBZ5CcN6PxwQSE2TZdf7kQ49LI8Nbo886_31mM=s96-c", "provider_id": "114196564114831451267", "email_verified": true, "phone_verified": false}	\N	2024-05-07 00:06:02.956362-05	2024-05-26 12:18:18.361773-05	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: badges; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.badges (id, name, image_url, description) FROM stdin;
1	sign_up_badge	\N	Welcome to TechTrove! You have earned the Sign Uop Badge
\.


--
-- Data for Name: blog_posts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.blog_posts (id, user_id, title, content, points_earned, created_at, updated_at, image_url) FROM stdin;
\.


--
-- Data for Name: carts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.carts (id, user_id, product_id, quantity) FROM stdin;
\.


--
-- Data for Name: levels; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.levels (id, name, points_required, discount_percentage, badge_id) FROM stdin;
2	1	0	0	1
\.


--
-- Data for Name: message_board_posts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.message_board_posts (id, user_id, title, content, points_earned, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: order_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.order_items (id, order_id, product_id, quantity, price) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.orders (id, user_id, total_amount, points_earned, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (id, name, brand, category, price, image, description, stock, ratings, features, dimensions, weight, warranty) FROM stdin;
81	Asus Rog Crosshairs	ASUS	Motherboards	859.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-crosshairs.jpg	High-performance gaming motherboard with RGB lighting and advanced cooling.	25	{"average": 4.5, "totalReviews": 123}	{"Supports AMD Ryzen processors","PCIe 4.0 ready","Onboard WiFi and Ethernet","SupremeFX audio technology"}	{"width": "30.5 cm", "height": "5 cm", "length": "24.4 cm"}	1.35 kg	3 years
82	Asus Rog Matrix	ASUS	Motherboards	999.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-matrix-cooling.jpg	The ultimate overclocking motherboard with water-cooling readiness.	15	{"average": 4.8, "totalReviews": 80}	{"Optimized for Intel processors","Enhanced power solution","Multiple GPU support","Comprehensive cooling controls"}	{"width": "30.5 cm", "height": "5 cm", "length": "27.7 cm"}	1.4 kg	3 years
83	Asus Rog Rampage	ASUS	Motherboards	1249.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-rampage-mother.webp	A flagship motherboard built for extreme performance and gaming.	10	{"average": 4.7, "totalReviews": 60}	{"Supports latest generation Intel CPUs","Quad-channel memory","High-speed networking options","AI Overclocking"}	{"width": "30.5 cm", "height": "5.1 cm", "length": "27.7 cm"}	1.5 kg	4 years
84	EK Rog Maximus	ASUS	Motherboards	729.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/ek-rog-maximus-xiv-extreme-glacial-landing-page-product-2x-999x1030.png	Custom-designed motherboard with premium liquid cooling capabilities.	20	{"average": 4.6, "totalReviews": 45}	{"Designed for liquid cooling enthusiasts","Integrated I/O shield","Aura Sync RGB lighting","Premium components for maximum durability"}	{"width": "24 cm", "height": "5 cm", "length": "24 cm"}	1.25 kg	3 years
85	Asus Rog Strix Z590-E	ASUS	Motherboards	379.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-strix-z590-e.webp	Gaming motherboard with advanced power delivery and optimized cooling.	30	{"average": 4.4, "totalReviews": 150}	{"AI Overclocking and cooling","WiFi 6E onboard","Dual PCIe 4.0 M.2 slots","USB 3.2 Gen 2x2 Type-C"}	{"width": "30.5 cm", "height": "5 cm", "length": "24.4 cm"}	1.3 kg	3 years
86	MSI MEG X590 Godlike	MSI	Motherboards	699.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/msi-meg-x590-godlike.webp	A masterclass in motherboard engineering with unrivaled performance.	5	{"average": 4.9, "totalReviews": 30}	{"Extended Heat-pipe design","Frozr Heatsink","Triple Lightning Gen 4 M.2 slots","Dynamic OLED screen"}	{"width": "27 cm", "height": "5.5 cm", "length": "30 cm"}	1.6 kg	5 years
87	Gigabyte Z690 Aorus Master	Gigabyte	Motherboards	459.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-z690-aorus-master.webp	Top-tier Z690 motherboard with advanced thermal design for enthusiasts.	12	{"average": 4.5, "totalReviews": 25}	{"Supports 12th Gen Intel Core Processors","DDR5 memory support","Thermal Reactive Armor","E-ATX form factor"}	{"width": "30.5 cm", "height": "5 cm", "length": "27 cm"}	1.7 kg	3 years
88	MSI MPG B550 Gaming Edge WiFi	MSI	Motherboards	209.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/msi-mpg-b550-gaming-edge-wifi.webp	Performance gaming motherboard with WiFi 6 and ample connectivity options.	18	{"average": 4.2, "totalReviews": 75}	{"Supports AMD Ryzen 5000 Series processors","Extended Heatsink Design","Pre-installed I/O Shielding","Mystic Light RGB"}	{"width": "30.5 cm", "height": "5 cm", "length": "24.4 cm"}	1.2 kg	3 years
89	Asus TUF Gaming X570-Plus (Wi-Fi)	ASUS	Motherboards	189.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-tuf-gaming-x570-plus-wi-fi.webp	Durable motherboard with military-grade components and integrated Wi-Fi.	25	{"average": 4.3, "totalReviews": 90}	{"AMD AM4 Socket for 3rd and 2nd Gen AMD Ryzen","Dual PCIe 4.0 M.2 slots","Exclusive DTS Custom audio","TUF Protection"}	{"width": "30.5 cm", "height": "5 cm", "length": "24.4 cm"}	1.3 kg	3 years
90	EVGA Z490 Dark	EVGA	Motherboards	499.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/evga-z390-dark.webp	An elite motherboard designed for record-breaking performance.	8	{"average": 4.8, "totalReviews": 10}	{"Designed for Intel 9th Gen processors","Highly-efficient 17 Phase Digital VRM","Creative Sound Core3D Audio","Triple BIOS Support"}	{"width": "27 cm", "height": "5 cm", "length": "30.5 cm"}	1.45 kg	3 years
91	Biostar Racing TZ590-BTC	Biostar	Motherboards	159.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/biostar-racing-z490gtn.webp	Mini-ITX motherboard perfect for building a compact yet powerful system.	20	{"average": 4, "totalReviews": 40}	{"Supports 10th Generation Intel Core Processor","Dual Channel DDR4, 2 DIMMs","Direct 6 Phase power design","PCIe M.2 32Gb/s"}	{"width": "17 cm", "height": "5 cm", "length": "17 cm"}	0.85 kg	2 years
92	NVIDIA GeForce RTX 3080	NVIDIA	Graphics Cards	699.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/rtx-3080.webp	The GeForce RTX™ 3080 delivers the ultra performance that gamers crave, powered by Ampere—NVIDIA's 2nd gen RTX architecture.	10	{"average": 4.8, "totalReviews": 120}	{"10GB GDDR6X","PCI Express 4.0","HDMI 2.1, 3x DisplayPort 1.4a","Ray Tracing Cores, Tensor Cores"}	{"width": "40 mm", "height": "112 mm", "length": "285 mm"}	1.35 kg	3 years
93	AMD Radeon RX 6800 XT	AMD	Graphics Cards	649.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/rx-6800-xt.jpg	The AMD Radeon RX 6800 XT graphics card, powered by AMD RDNA 2 architecture, featuring 72 powerful enhanced Compute Units, and 16GB of GDDR6 memory.	8	{"average": 4.7, "totalReviews": 80}	{"16GB GDDR6","PCI Express 4.0","HDMI 2.1, 2x DisplayPort 1.4","Ray Accelerators, FidelityFX"}	{"width": "50 mm", "height": "120 mm", "length": "267 mm"}	1.5 kg	3 years
94	ASUS ROG Strix NVIDIA GeForce RTX 3070	ASUS	Graphics Cards	599.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/rtx-3070-rog.jpg	Built with the breakthrough graphics performance of the award-winning NVIDIA Turing architecture, this is your blazing-fast supercharger for today's most popular games.	15	{"average": 4.6, "totalReviews": 60}	{"8GB GDDR6","OC Edition",ROG-STRIX-RTX3070-O8G-GAMING,"Axial-tech fan design"}	{"width": "52 mm", "height": "126 mm", "length": "299 mm"}	1.47 kg	3 years
95	MSI Gaming GeForce GTX 1660 Super	MSI	Graphics Cards	249.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gtx-1660-super-msi.webp	A strong backplate reinforces the graphics card while providing passive cooling by applying thermal pads.	20	{"average": 4.5, "totalReviews": 150}	{"6GB GDDR6","TWIN FROZR 7 Thermal Design","TORX Fan 3.0","Afterburner Overclocking Utility"}	{"width": "46 mm", "height": "127 mm", "length": "247 mm"}	0.86 kg	3 years
96	Gigabyte AORUS GeForce RTX 2060 Super	Gigabyte	Graphics Cards	399.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/rtx-2060-super-aorus.webp	The AORUS GeForce RTX 2060 Super comes with an all-around cooling solution that keeps the GPU cool from every angle.	13	{"average": 4.3, "totalReviews": 45}	{"8GB GDDR6","WINDFORCE Stack 3x 100mm Fan Cooling System","RGB light reinvented","7 Video Outputs"}	{"width": "59 mm", "height": "134 mm", "length": "290 mm"}	1.29 kg	4 years
97	EVGA GeForce RTX 3090 FTW3 Ultra Gaming	EVGA	Graphics Cards	1499.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/evga-3090-ftw.webp	The EVGA GeForce RTX 3090 is colossally powerful in every way imaginable, giving you a whole new tier of performance at 8K resolution.	5	{"average": 4.9, "totalReviews": 40}	{"24GB GDDR6X","iCX3 Technology","ARGB LED","Ray Tracing Cores, Tensor Cores"}	{"width": "56 mm", "height": "137 mm", "length": "300 mm"}	1.77 kg	3 years
98	EVGA GeForce RTX 3080 XC3 Ultra Gaming	EVGA	Graphics Cards	729.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/evga-3080-ftw.jpg	Experience the best gaming experience with the new EVGA GeForce RTX 3080's enhanced Ray Tracing Cores and Tensor Cores, new streaming multiprocessors, and high-speed GDDR6X memory.	7	{"average": 4.8, "totalReviews": 90}	{"10GB GDDR6X","iCX3 Cooling","Adjustable ARGB LED","Built for EVGA Precision X1"}	{"width": "44 mm", "height": "112 mm", "length": "285 mm"}	1.35 kg	3 years
99	EVGA GeForce RTX 3070 XC3 Black Gaming	EVGA	Graphics Cards	549.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/evga-3080-ftw.jpg	With the EVGA GeForce RTX 3070, you can count on incredible performance for ray tracing and AI-powered DLSS to deliver the ultimate PC gaming experience.	12	{"average": 4.7, "totalReviews": 70}	{"8GB GDDR6","iCX3 Cooling","Ray Tracing Cores, Tensor Cores","EVGA Precision X1"}	{"width": "40 mm", "height": "111 mm", "length": "280 mm"}	1.23 kg	3 years
100	ASUS ROG Strix GeForce RTX 4090 OC Edition	ASUS	Graphics Cards	1999.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-strix-4090-btf.png	The ASUS ROG Strix GeForce RTX 4090 OC edition is built with enhanced RT Cores and Tensor Cores, new streaming multiprocessors, and superfast GDDR6X memory for an amazing gaming experience.	3	{"average": 5, "totalReviews": 25}	{"24GB GDDR6X","OC Edition","Axial-tech Fan Design","Super Alloy Power II"}	{"width": "71 mm", "height": "149 mm", "length": "357 mm"}	2.1 kg	4 years
101	ASUS ROG Strix GeForce RTX 4080	ASUS	Graphics Cards	1199.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-strix-4080-super.png	The ASUS ROG Strix GeForce RTX 4080 has been redesigned to harness the incredible power of the new Ada Lovelace architecture and provides gamers with an unrivaled experience.	4	{"average": 4.9, "totalReviews": 30}	{"16GB GDDR6X","OC Edition","Axial-tech Fan Design","GPU Tweak III"}	{"width": "68 mm", "height": "140 mm", "length": "348 mm"}	1.98 kg	4 years
102	Gigabyte GeForce RTX 4080 Ti	Gigabyte	Graphics Cards	1399.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-rtx-3080-ti-aorus-master.webp	The Gigabyte GeForce RTX 4080 Ti boasts cutting-edge performance with its next-gen RT Cores, Tensor Cores, and fast GDDR6X memory, making it ideal for the most demanding gamers and creators.	6	{"average": 4.8, "totalReviews": 52}	{"20GB GDDR6X","Next-gen Ray Tracing Cores","Tensor Cores for AI Acceleration","High-speed Memory Interface"}	{"width": "55 mm", "height": "130 mm", "length": "320 mm"}	1.55 kg	3 years
103	Gigabyte AORUS GeForce RTX 3090 Xtreme	Gigabyte	Graphics Cards	1599.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-aorus-rtx-3090-xtreme.jpg	The Gigabyte AORUS GeForce RTX 3090 Xtreme is engineered with the highest-grade chokes and capacitors, this graphic card delivers outstanding performance and durable system lifespan.	4	{"average": 4.8, "totalReviews": 35}	{"24GB GDDR6X","Max-Covered Cooling","LCD Edge View","NVIDIA Ampere Streaming Multiprocessors"}	{"width": "70 mm", "height": "140 mm", "length": "319 mm"}	1.89 kg	4 years
104	Gigabyte GeForce RTX 3080 Ti AORUS MASTER	Gigabyte	Graphics Cards	1199.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-rtx-3080-ti-aorus-master.webp	Powered by NVIDIA's new Ampere architecture, the Gigabyte GeForce RTX 3080 Ti AORUS MASTER delivers an incredible leap in performance and fidelity with acclaimed features such as ray tracing, tensor cores for AI acceleration, and much more.	3	{"average": 4.9, "totalReviews": 45}	{"12GB GDDR6X","WINDFORCE Stack 3X Cooling System","RGB Fusion 2.0","Protection Metal Back Plate"}	{"width": "75 mm", "height": "142 mm", "length": "324 mm"}	1.82 kg	4 years
105	Gigabyte AORUS GeForce RTX 4080 MASTER	Gigabyte	Graphics Cards	1299.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-aorus-rtx-4080-master.jpg	Experience gaming excellence with Gigabyte's AORUS GeForce RTX 4080 MASTER. This formidable card is packed with all-new Ampere SM units delivering 2x the FP32 throughput and improved power efficiency.	2	{"average": 5, "totalReviews": 20}	{"16GB GDDR6X","Advanced Copper Back Plate Cooling","RGB Fusion 2.0 – synchronize with other AORUS devices","Dual BIOS & Anti-Sag Bracket"}	{"width": "71 mm", "height": "149 mm", "length": "336 mm"}	1.96 kg	4 years
106	Intel Core i9-12900K	Intel	Processors	589.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i9-12900k.webp	12th Gen Intel Core i9 processor offers peak performance with up to 5.2 GHz and advanced overclocking capabilities for gaming and heavy workloads.	10	{"average": 4.8, "totalReviews": 250}	{"16 cores (8 Performance-cores, 8 Efficient-cores)","24 threads","Up to 5.2 GHz with Intel Turbo Boost Max Technology 3.0","Supports PCIe Gen 5.0 & DDR5 memory"}	\N	\N	\N
107	AMD Ryzen 9 5950X	AMD	Processors	799.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-9-5950x.webp	The AMD Ryzen 9 5950X boasts high core and thread counts for demanding applications and can push performance with aggressive boost clocks.	8	{"average": 4.9, "totalReviews": 200}	{"16 cores & 32 threads","Boost clock up to 4.9 GHz","72 MB of combined cache","Compatible with AMD AM4 socket motherboards"}	\N	\N	\N
108	Intel Core i7-12700K	Intel	Processors	409.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i7-12700k.webp	The Intel Core i7-12700K features hybrid architecture that combines performance cores with efficient cores to deliver a new level of gaming and multitasking performance.	15	{"average": 4.7, "totalReviews": 180}	{"12 cores (8 Performance-cores, 4 Efficient-cores)","20 threads","Up to 5.0 GHz with Intel Turbo Boost Max Technology 3.0","Compatible with Intel 600 series chipset based motherboards"}	\N	\N	\N
109	AMD Ryzen 7 5800X	AMD	Processors	449	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-7-5800x.jpg	With the AMD Ryzen 7 5800X, experience elite gaming with 8 cores optimized for high-FPS gaming rigs, and handle demanding tasks like content creation with ease.	12	{"average": 4.6, "totalReviews": 220}	{"8 cores & 16 threads","Boost clock up to 4.7 GHz","36 MB of total cache","Compatible with AMD AM4 socket motherboards"}	\N	\N	\N
110	Intel Core i5-12600K	Intel	Processors	299.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i5-12600k.jpg	The Intel Core i5-12600K offers excellent mid-range performance with its new hybrid architecture optimized for gaming and productivity.	20	{"average": 4.7, "totalReviews": 100}	{"10 cores (6 Performance-cores, 4 Efficient-cores)","16 threads","Up to 4.9 GHz with Intel Turbo Boost Technology","Compatible with Intel 600 series chipset based motherboards"}	\N	\N	\N
111	AMD Ryzen 5 5600X	AMD	Processors	309.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-5-5600x.webp	The AMD Ryzen 5 5600X is a powerful six-core processor that excels in gaming and productivity tasks with its high boost clocks.	25	{"average": 4.8, "totalReviews": 150}	{"6 cores & 12 threads","Boost clock up to 4.6 GHz","35 MB of total cache","Compatible with AMD AM4 socket motherboards"}	\N	\N	\N
112	Intel Core i7-11700K	Intel	Processors	374.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i7-11700k.webp	Unlocked 11th Gen Intel Core i7-11700K desktop processor, designed for gamers and creative professionals who want to push their experience to higher levels.	20	{"average": 4.5, "totalReviews": 140}	{"8 cores & 16 threads","3.6 GHz base clock, up to 5.0 GHz with Intel Turbo Boost Max Technology 3.0","16 MB Intel Smart Cache","Compatible with Intel 500 series & select 400 series chipset based motherboards"}	\N	\N	\N
113	AMD Ryzen Threadripper 3960X	AMD	Processors	1399.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-threadripper-3960x.webp	The AMD Ryzen Threadripper 3960X is a powerhouse for creators and enthusiasts, featuring 24 cores and 48 threads to handle complex workloads with ease.	5	{"average": 4.9, "totalReviews": 85}	{"24 cores & 48 threads","Base clock of 3.8 GHz, Boost clock of up to 4.5 GHz","140 MB of combined cache","sTRX4 Socket, compatible with AMD TRX40 chipset motherboards"}	\N	\N	\N
114	Intel Core i3-10100	Intel	Processors	122.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i3-10100.jpg	Intel Core i3-10100 provides solid performance for everyday computing, with a quad-core design and Intel Hyper-Threading Technology.	30	{"average": 4.5, "totalReviews": 80}	{"4 cores & 8 threads","3.6 GHz base clock, up to 4.3 GHz with Turbo Boost","6 MB cache","Compatible with Intel 400 series chipset based motherboards"}	\N	\N	\N
115	AMD Ryzen 3 3300X	AMD	Processors	129.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-3-3300x.webp	AMD Ryzen 3 3300X offers great entry-level gaming and multitasking with impressive single-threaded performance and unlocked overclocking potential.	18	{"average": 4.4, "totalReviews": 60}	{"4 cores & 8 threads","Boost clock up to 4.3 GHz","18 MB of total cache","Compatible with AMD AM4 socket motherboards"}	\N	\N	\N
116	Intel Core i5-10400F	Intel	Processors	157.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/intel-core-i5-12600k.jpg	A fantastic choice for budget gaming rigs, the Intel Core i5-10400F offers six cores of processing power without integrated graphics.	22	{"average": 4.6, "totalReviews": 90}	{"6 cores & 12 threads","2.9 GHz base clock, up to 4.3 GHz with Turbo Boost","12 MB cache","Compatible with Intel 400 series chipset based motherboards"}	\N	\N	\N
117	AMD Ryzen 7 PRO 4750G	AMD	Processors	359.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/amd-ryzen-7-pro-4750g.webp	Designed for professional use in mind, the AMD Ryzen 7 PRO 4750G includes Radeon graphics and robust security features catering to business environments.	14	{"average": 4.5, "totalReviews": 40}	{"8 cores & 16 threads","Boost clock up to 4.4 GHz","12 MB of total cache","Radeon Graphics","Compatible with AMD AM4 socket motherboards"}	\N	\N	\N
118	Corsair Dominator Platinum RGB 32GB (2x16GB) DDR4 3200MHz	Corsair	Memory	229.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/corsair-dominator-platinum.webp	The Corsair Dominator Platinum RGB is the perfect blend of performance and aesthetics, featuring iconic design, patented DHX cooling technology, and a wide range of customization options with iCUE software.	35	{"average": 4.8, "totalReviews": 215}	{"32GB (2 x 16GB) DDR4 DRAM 3200MHz C16","Patented DHX cooling technology","Dynamic multi-zone RGB lighting","Custom performance PCB for high signal quality and stability"}	\N	\N	\N
119	G.SKILL Trident Z Royal Series 16GB (2x8GB) DDR4 4000MHz	G.SKILL	Memory	199.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/g-skill-trident-z-royal.jpg	Trident Z Royal series represents one of the highest echelons in performance memory, designed with a crown jewel-like design, crystalline light bars, and luxury aluminum heatsinks.	18	{"average": 4.9, "totalReviews": 152}	{"16GB (2 x 8GB) DDR4 DRAM 4000MHz C17","Luxury aluminum heat spreaders with crystalline light bar","Extreme overclocking performance","Intel XMP 2.0 profile support for easy overclocking"}	\N	\N	\N
120	Teamgroup T-Force Xtreem ARGB 16GB (2x8GB) DDR4 3600MHz	Teamgroup	Memory	159.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/teamgroup-t-force-xtreem-argb.webp	The T-Force Xtreem ARGB features mesmerizing RGB lighting with mirror reflection design, offering both striking visuals and outstanding performance.	25	{"average": 4.7, "totalReviews": 89}	{"16GB (2 x 8GB) DDR4 DRAM 3600MHz C14","Full mirror reflection design with ARGB lighting","High-efficiency aluminum heat spreader","Supports Intel & AMD motherboards","XMP 2.0 support for overclocking"}	\N	\N	\N
121	Crucial Ballistix MAX 32GB (2x16GB) DDR4 4400MHz	Crucial	Memory	349.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/crucial-ballistix-max.jpg	Crucial Ballistix MAX offers maximum speeds and responsiveness for gaming enthusiasts and extreme overclockers with its meticulously engineered design and XMP profiles.	10	{"average": 4.9, "totalReviews": 47}	{"32GB (2 x 16GB) DDR4 DRAM 4400MHz C19","Precision temperature sensor integrated","Aluminum heat spreader for efficient thermal management","Included Ballistix M.O.D. Utility software for real-time temperature monitoring","Designed for extreme overclocking enthusiasts"}	\N	\N	\N
122	G.SKILL Trident Z Royal Series 32GB (2x16GB) DDR4 3200MHz	G.SKILL	Memory	219.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/g-skill-trident-z-royal-series.jpg	Experience luxury and performance with the Trident Z Royal Series, featuring a polished aluminum heat spreader in magnificent gold or silver and crystalline light bar.	15	{"average": 4.8, "totalReviews": 115}	{"32GB (2 x 16GB) DDR4 DRAM 3200MHz C16","Polished aluminum heat spreaders in gold or silver","Brilliant RGB lighting with software control","Highly screened ICs for peak performance potential","Supports Intel & AMD motherboards"}	\N	\N	\N
123	Corsair Dominator Platinum RGB 64GB (4x16GB) DDR4 3600MHz	Corsair	Memory	549.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/corsair-dominator-platinum-rgb.jpg	The Corsair Dominator Platinum RGB is the pinnacle of premium craftsmanship, intelligent design, and stunning RGB lighting powered by Corsair iCUE software.	8	{"average": 4.9, "totalReviews": 76}	{"64GB (4 x 16GB) DDR4 DRAM 3600MHz C18","Patented DHX cooling technology","Iconic design with a precision forged die-cast zinc alloy top cap","12 ultra-bright, individually addressable CAPELLIX RGB LEDs per module","Custom high-performance PCB for superior overclocking capability"}	\N	\N	\N
124	G.SKILL Trident Z Neo Series 32GB (2x16GB) DDR4 3200MHz	G.SKILL	Memory	299.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/g-skill-trident-z-neo.webp	Designed for gaming and PC enthusiasts, the Trident Z Neo DDR4 memory series brings performance and style with sleek exterior design and dazzling RGB lighting effects using G.SKILL's Trident Z Lighting Control software.	15	{"average": 4.8, "totalReviews": 45}	{"32GB (2 x 16GB) DDR4 DRAM 3200MHz C16","Optimized for AMD Ryzen platforms","Neo Design Elements","Trident Z RGB heatspreader for improved heat dissipation","Custom engineered ten-layer PCB for better signal stability"}	\N	\N	\N
126	Teamgroup T-Force Vulcan Z 16GB (2x8GB) DDR4 3000MHz	Teamgroup	Memory	79.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/teamgroup-vulcan-z.webp	The Teamgroup T-Force Vulcan Z is designed for complete protection and enhanced heat dissipation. The heat spreader is made of a punch press process with a 0.8mm thick, one-piece alloy aluminum to reinforce the body structure.	25	{"average": 4.6, "totalReviews": 104}	{"16GB (2 x 8GB) DDR4 DRAM 3000MHz C16","Simple design to fit into mainstream gaming systems","High thermal conductive adhesive","Supports Intel & AMD motherboards","Selected high-quality IC chips"}	\N	\N	\N
127	Samsung 980 PRO PCIe 4.0 NVMe M.2	Samsung	SSD	229.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/samsung-980-pro.webp	The Samsung 980 PRO offers exceptional speed and reliability with PCIe 4.0 connectivity and up to 7000 MB/s read speeds.	50	{"average": 4.9, "totalReviews": 2150}	{"PCIe 4.0 NVMe M.2 Interface","Read speeds up to 7000 MB/s","Capacity options up to 2TB"}	\N	\N	\N
128	Western Digital WD Black SN850 NVMe M.2	Western Digital	SSD	199.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/wd-black-sn850.webp	High-performance gaming SSD with PCIe 4.0 technology for blazing fast read and write speeds.	40	{"average": 4.8, "totalReviews": 1875}	{"PCIe 4.0 NVMe M.2 Interface","Read speeds up to 7000 MB/s","Capacity options up to 2TB"}	\N	\N	\N
129	Crucial P5 1TB 3D NAND NVMe M.2 SSD	Crucial	SSD	109.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/crucial-p5.webp	The Crucial P5 redefines what's possible with innovations that transform the speed of storage.	35	{"average": 4.7, "totalReviews": 680}	{"NVMe M.2 Interface","Read speeds up to 3400 MB/s","Dynamic Write Acceleration technology","Available in capacities up to 2TB"}	\N	\N	\N
130	SK hynix Gold P31 PCIe NVMe M.2	SK hynix	SSD	134.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/sk-hynix-gold-p31.webp	One of the world's first 128-layer NAND flash-based consumer SSDs, delivering unparalleled speed and efficiency.	30	{"average": 4.7, "totalReviews": 965}	{"PCIe 3.0 NVMe M.2 Interface","Read speeds up to 3500 MB/s","Power-efficient performance","Capacity up to 1TB"}	\N	\N	\N
131	ADATA XPG SX8200 Pro 1TB	ADATA	SSD	129.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/adata-xpg-sx8200-pro.jpg	Utilizing PCIe Gen3x4 interface and featuring NVMe 1.3 support, the XPG SX8200 Pro delivers fast read/write speeds for accelerated performance.	25	{"average": 4.6, "totalReviews": 312}	{"PCIe Gen3x4 NVMe 1.3 Interface","Read/Write speeds up to 3500/3000 MB/s","Advanced 3D NAND Technology","Capacity options ranging from 256GB to 1TB"}	\N	\N	\N
132	Corsair Force Series MP600 2TB	Corsair	SSD	369.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/corsair-force-mp600.webp	The Corsair Force Series MP600 uses Gen4 PCIe technology with blazing fast sequential read speeds of up to 4950MB/s for top-tier performance.	20	{"average": 4.5, "totalReviews": 789}	{"Gen4 PCIe x4 NVMe 1.3 M.2 Interface","Sequential read speeds up to 4950 MB/s","High-density 3D TLC NAND","Integrated aluminum heat spreader","Capacities up to 2TB"}	\N	\N	\N
133	Seagate FireCuda 520 1TB NVMe	Seagate	SSD	219.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/seagate-firecuda-520.webp	The Seagate FireCuda 520 SSD offers enthusiasts and pro-level gamers the fastest data transfer rates available in a solid state drive.	15	{"average": 4.7, "totalReviews": 528}	{"PCIe Gen4 ×4 NVMe 1.3 Interface","Zoned Performance for Gaming","Sequential read/write speeds of up to 5000/4400 MB/s","Capacities up to 2TB"}	\N	\N	\N
134	Samsung 970 EVO Plus 1TB	Samsung	SSD	199.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/samsung-970-evo-plus.webp	The Samsung 970 EVO Plus delivers breakthrough speeds and best-in-class reliability.	30	{"average": 4.8, "totalReviews": 850}	{"NVMe M.2 Interface","Read speeds up to 3,500 MB/s","Write speeds up to 3,300 MB/s","Samsung V-NAND Technology"}	\N	\N	\N
135	Crucial MX500 1TB	Crucial	SSD	114.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/crucial-mx500.webp	The Crucial MX500 offers solid performance and reliability with dynamic write acceleration technology.	40	{"average": 4.7, "totalReviews": 920}	{"SATA Interface for easy upgrade","Read speeds up to 560 MB/s","Write speeds up to 510 MB/s","Integrated Power Loss Immunity"}	\N	\N	\N
136	Western Digital Blue SN550 1TB	Western Digital	SSD	109.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/wd-blue-sn550.jpg	The WD Blue SN550 NVMe SSD can deliver over 4 times the speed of our best SATA SSDs.	35	{"average": 4.6, "totalReviews": 780}	{"NVMe drive not compatible with SATA interface","Read speeds up to 2,400 MB/s","Uses Western Digital-designed controller and firmware for optimized performance","Low power efficiency"}	\N	\N	\N
139	Corsair RM750x	Corsair	Power Supply	129.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/corsair-rm750x.webp	The Corsair RM750x is a high-performance power supply boasting full modular cables and 80+ Gold efficiency for quiet operation and less heat generation.	25	{"average": 4.9, "totalReviews": 3200}	{"750W continuous power output","80 PLUS Gold certified","Zero RPM fan mode","Fully modular cables","10-year warranty"}	\N	\N	\N
140	EVGA SuperNOVA 850 G3	EVGA	Power Supply	159.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/evga-supernova-850-g3.jpg	The EVGA SuperNOVA 850 G3 provides reliable power with 80+ Gold efficiency, fully modular design, and Eco Mode for ultra-quiet performance.	20	{"average": 4.7, "totalReviews": 2500}	{"850W output capacity","80 PLUS Gold efficiency","Fully modular to reduce clutter","ECO Mode for silent operation","7-year warranty"}	\N	\N	\N
141	Seasonic FOCUS Plus 650 Gold	Seasonic	Power Supply	99.9	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/seasonic-focus-plus-650-gold.webp	The Seasonic FOCUS Plus 650 Gold is a compact, highly reliable power supply with 80+ Gold certification and fully modular cables for easy installation.	25	{"average": 4.6, "totalReviews": 75}	{"650 watts of output","80 PLUS Gold efficiency","Fully modular cabling","Compact size fits in standard cases","10-year manufacturer's warranty"}	\N	\N	\N
142	ASUS ROG Thor 850	ASUS	Power Supply	219.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-thor-850.webp	The ASUS ROG Thor 850 is the choice for gamers, featuring 80+ Platinum efficiency, customizable Aura Sync RGB lighting, and an OLED power display.	5	{"average": 4.6, "totalReviews": 12}	{"850 watts of stable power","80 PLUS Platinum certification","Customizable RGB lighting with Aura Sync","Integrated OLED power display","Fully modular cable design"}	\N	\N	\N
143	Cooler Master V750	Cooler Master	Power Supply	119.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/cooler-master-v750.webp	Cooler Master V750 offers high efficiency and stability with its 80+ Gold certification and fully modular design, ideal for a variety of PC builds.	15	{"average": 4.6, "totalReviews": 32}	{"750W continuous power output","80 PLUS Gold certified for high efficiency","Silent 135mm fan with semi-fanless operation","Fully modular cables for a clean build","5-year warranty"}	\N	\N	\N
144	Thermaltake Toughpower 1050W	Thermaltake	Power Supply	209.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/thermaltake-toughpower-grand-rgb-1050w.jpg	With 1050W of power, 80+ Platinum certification, and a patented 256-color RGB fan, the Toughpower Grand RGB is a premium PSU for performance PCs.	4	{"average": 4.2, "totalReviews": 12}	{"1050 watts for high-demand systems","80 PLUS Platinum efficiency for optimal energy use","RGB LED fan for aesthetic customizations","Smart zero fan for near silent operation","Fully modular cable management"}	\N	\N	\N
145	NZXT C650	NZXT	Power Supply	109.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/nzxt-c650.webp	The NZXT C650 PSU delivers clean, stable power with 80+ Gold efficiency and a silent operation, perfect for your gaming rig.	35	{"average": 4.5, "totalReviews": 67}	{"650 watts of reliable power","80 PLUS Gold certified","Fully modular design simplifies cable management","NZXT's E-Series offers real-time power monitoring","10-year warranty"}	\N	\N	\N
146	Be Quiet! Straight Power 11 650W	Be Quiet!	Power Supply	129.9	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/be-quiet-straight-power-11-650w.jpg	Designed for computer enthusiasts seeking quiet operation, the Be Quiet! Straight Power 11 650W offers exceptional reliability and performance.	21	{"average": 4.7, "totalReviews": 39}	{"650W output to support demanding systems","80 PLUS Gold certified for high energy efficiency","Virtually inaudible Silent Wings 3 fan","Fully modular cable setup for a neat build","5-year manufacturer's warranty"}	\N	\N	\N
147	Fractal Design Ion+ 760P	Fractal Design	Power Supply	139.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/fractal-design-ion-760p.jpg	Fractal Design's Ion+ 760P is a premium power supply unit with stellar performance, ultra-flexible cables, and 80+ Platinum efficiency.	18	{"average": 4.8, "totalReviews": 58}	{"760 watts for high-performance PCs","80 PLUS Platinum rating ensures top-notch efficiency","Fully modular design and premium UltraFlex cables","Quiet operation with dynamic bearing fan","10-year warranty"}	\N	\N	\N
148	XPG Core Reactor 650W	XPG	Power Supply	109.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/xpg-core-reactor.webp	The XPG Core Reactor 650W is a compact, powerful PSU with 80+ Gold efficiency, suited for gamers and enthusiasts looking for top performance.	24	{"average": 4.6, "totalReviews": 48}	{"650 watts of continuous power","80 PLUS Gold certification for efficient power usage","Fully modular cables for an easy and clean build","120mm fluid dynamic bearing fan for near-silent operation","10-year manufacturer's warranty"}	\N	\N	\N
149	Apple MacBook Pro 16-inch	Apple	Laptop	2399.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/mac-book.jpg	Designed for professionals, the MacBook Pro features a stunning 16-inch Retina display, powerful processors and graphics, and up to 20 hours of battery life.	15	{"average": 4.7, "totalReviews": 532}	{"16-inch Retina display with True Tone technology","Latest-generation Intel Core processors or M1 Pro/Max chips","Up to 64GB RAM and 8TB of superfast SSD storage","Incredible battery life","Touch Bar and Touch ID"}	\N	\N	\N
150	Dell XPS 15	Dell	Laptop	1850	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/dell-xps-15.jpg	With its stunning 4K UHD display, powerful performance from Intel's latest CPUs, and premium construction, the Dell XPS 15 is an ideal choice for power users.	20	{"average": 4.5, "totalReviews": 215}	{"15.6-inch 4K UHD InfinityEdge touchscreen display","10th Gen Intel Core i7 or i9 processors","NVIDIA GeForce GTX 1650 Ti GPU","Up to 32GB DDR4 RAM and 1TB PCIe SSD","CNC machined aluminum and carbon fiber build"}	\N	\N	\N
151	Lenovo ThinkPad X1 Carbon Gen 9	Lenovo	Laptop	1429.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-tuf-gaming-laptop.webp	The Lenovo ThinkPad X1 Carbon offers robust security, durability, and performance in an ultralight and thin package, perfect for business professionals.	25	{"average": 4.6, "totalReviews": 98}	{"14-inch FHD+ (1920 x 1200) IPS anti-glare display","11th Gen Intel Core processors","Intel Iris Xe Graphics","Up to 32GB LPDDR4x RAM and 1TB PCIe SSD","Mil-spec tested for durability"}	\N	\N	\N
152	ASUS ROG Zephyrus G15	ASUS	Laptop	1799.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/rog-strix-17-gaming.jpg	The ASUS ROG Zephyrus G15 balances exceptional portability with potent performance, including a high-refresh-rate display and strong gaming capabilities.	18	{"average": 4.8, "totalReviews": 123}	{"15.6-inch QHD display with a 165Hz refresh rate","AMD Ryzen 9 processor","NVIDIA GeForce RTX 3080 Graphics","Up to 32GB DDR4 RAM and 1TB NVMe PCIe SSD","Ergonomic backlit keyboard and multiple I/O ports"}	\N	\N	\N
153	ASUS ROG Zephyrus Duo 15	ASUS	Laptop	2899.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/asus-rog-zephyrus-duo-15.jpg	The ASUS ROG Zephyrus Duo 15 features an innovative dual-screen design, high-end performance hardware, and exceptional cooling for a top-tier gaming experience.	10	{"average": 4.8, "totalReviews": 75}	{"15.6-inch primary display with secondary touchscreen panel","Intel Core i9 processor","NVIDIA GeForce RTX 3080 GPU","Up to 32GB RAM and 2TB RAID 0 SSD storage","ROG ScreenPad Plus for multitasking"}	\N	\N	\N
154	Alienware Area-51m R2	Dell Alienware	Laptop	2229.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/alienware-area-51m.webp	The Alienware Area-51m R2 is designed for gamers seeking desktop-level power in a laptop form-factor, featuring upgradable components and a bold design.	12	{"average": 4.6, "totalReviews": 89}	{"17.3-inch FHD (1920 x 1080) 144Hz display","10th Gen Intel Core i7/i9 processors","NVIDIA GeForce GTX or RTX series GPUs","Up to 64GB DDR4 RAM and multiple SSD + HDD options","Advanced Cryo-Tech cooling technology"}	\N	\N	\N
155	MSI GE66 Raider	MSI	Laptop	1999.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/msi-ge66-raider.webp	The MSI GE66 Raider delivers a powerful punch with its high performance components and custom RGB lighting, making it a hit among gamers.	14	{"average": 4.7, "totalReviews": 110}	{"15.6-inch FHD 240Hz display","Latest-gen Intel Core i7/i9 processors","NVIDIA GeForce RTX 3070/3080 GPU","Up to 32GB RAM and 1TB NVMe SSD","Panoramic Aurora lighting"}	\N	\N	\N
156	Razer Blade Pro 17	Razer	Laptop	2599.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/razer-blade-pro-17.jpg	The Razer Blade Pro 17 is a premium gaming laptop that offers a blend of portability, sleek design, and high-end performance for demanding users.	8	{"average": 4.5, "totalReviews": 45}	{"17.3-inch FHD 360Hz or 4K Touch display","8-Core 10th Gen Intel Core i7-10875H processor","NVIDIA GeForce RTX 30 Series GPUs","Up to 32GB DDR4 RAM and up to 1TB PCIe NVMe SSD","Vapor Chamber Cooling System"}	\N	\N	\N
157	HP Omen 15	HP	Laptop	1599.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/hp-omen-15.webp	The HP Omen 15 is a well-rounded gaming laptop offering powerful specs, a sleek design, and a high refresh rate display for a smoother gaming experience.	16	{"average": 4.5, "totalReviews": 68}	{"15.6-inch FHD (1920 x 1080) 300Hz IPS display","AMD Ryzen 7 or Intel Core i7 processor options","NVIDIA GeForce RTX 3070 GPU","Up to 32GB DDR4 RAM and 1TB PCIe NVMe M.2 SSD","OMEN Tempest Cooling Technology"}	\N	\N	\N
158	Acer Predator Helios 300	Acer	Laptop	1299.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/acer-predator-helios-300.jpg	The Acer Predator Helios 300 is a popular choice among gamers for its performance at a competitive price point, featuring customizable RGB lighting.	20	{"average": 4.6, "totalReviews": 95}	{"15.6-inch FHD 240Hz 3ms display","10th Gen Intel Core i7 processor","NVIDIA GeForce RTX 2070 with Max-Q Design","16GB DDR4 RAM and 512GB NVMe SSD","4-Zone RGB Backlit Keyboard"}	\N	\N	\N
159	Lenovo Legion 5 Pro	Lenovo	Laptop	1799.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/lenovo-legion-5-pro.webp	The Lenovo Legion 5 Pro offers a superb balance between work and play, equipped with top-tier hardware and an impressive display with high resolution and refresh rate.	10	{"average": 4.7, "totalReviews": 78}	{"16-inch QHD (2560 x 1600) 165Hz display","AMD Ryzen 7 processors","NVIDIA GeForce RTX 3060/3070 GPUs","Up to 32 GB DDR4 RAM and up to 2 TB PCIe SSD","Coldfront 3.0 cooling technology"}	\N	\N	\N
160	Gigabyte AORUS 17G	Gigabyte	Laptop	2199.99	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/tech-trove-data/product-images/gigabyte-aorus-17g.webp	The Gigabyte AORUS 17G stands out with its mechanical keyboard in a portable form factor, along with impressive specs designed for intense gaming sessions.	6	{"average": 4.4, "totalReviews": 52}	{"17.3-inch FHD 300Hz display","10th Gen Intel Core i7/i9 processors","NVIDIA GeForce RTX 3080 GPU","32GB RAM and 512GB PCIe SSD","OMRON mechanical key switches"}	\N	\N	\N
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profiles (id, updated_at, username, full_name, avatar_url, website) FROM stdin;
2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-08 23:58:33.364-05	barrathtb	Thomas Barrath	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/avatars/0.6945566470599647.gif	\N
febd26f0-a0f3-45e1-ae65-dbdad2947429	\N	barra123	Thomas Barrath	https://dcwlthpdbjrgmusqwprj.supabase.co/storage/v1/object/public/avatars/0.11768257317868658.png	\N
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reviews (id, user_id, product_id, rating, comment, points_earned, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, password, username, email, level_id, points, created_at, updated_at, profile_id) FROM stdin;
\.


--
-- Data for Name: wishlists; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.wishlists (id, user_id, product_id) FROM stdin;
60	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	81
61	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	149
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.messages (id, topic, extension, inserted_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2024-04-21 20:27:10
20211116045059	2024-04-21 20:27:10
20211116050929	2024-04-21 20:27:10
20211116051442	2024-04-21 20:27:10
20211116212300	2024-04-21 20:27:10
20211116213355	2024-04-21 20:27:10
20211116213934	2024-04-21 20:27:10
20211116214523	2024-04-21 20:27:10
20211122062447	2024-04-21 20:27:10
20211124070109	2024-04-21 20:27:10
20211202204204	2024-04-21 20:27:10
20211202204605	2024-04-21 20:27:10
20211210212804	2024-04-21 20:27:10
20211228014915	2024-04-21 20:27:10
20220107221237	2024-04-21 20:27:10
20220228202821	2024-04-21 20:27:10
20220312004840	2024-04-21 20:27:10
20220603231003	2024-04-21 20:27:11
20220603232444	2024-04-21 20:27:11
20220615214548	2024-04-21 20:27:11
20220712093339	2024-04-21 20:27:11
20220908172859	2024-04-21 20:27:11
20220916233421	2024-04-21 20:27:11
20230119133233	2024-04-21 20:27:11
20230128025114	2024-04-21 20:27:11
20230128025212	2024-04-21 20:27:11
20230227211149	2024-04-21 20:27:11
20230228184745	2024-04-21 20:27:11
20230308225145	2024-04-21 20:27:11
20230328144023	2024-04-21 20:27:11
20231018144023	2024-04-21 20:27:11
20231204144023	2024-04-21 20:27:11
20231204144024	2024-04-21 20:27:11
20231204144025	2024-04-21 20:27:11
20240108234812	2024-04-21 20:27:11
20240109165339	2024-04-21 20:27:11
20240227174441	2024-04-21 20:27:11
20240311171622	2024-04-21 20:27:11
20240321100241	2024-04-21 20:27:11
20240401105812	2024-04-21 20:27:11
20240418121054	2024-04-21 20:27:11
20240523004032	2024-06-20 15:56:55
20240618124746	2024-06-20 15:56:55
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
tech-trove-data	tech-trove-data	\N	2024-04-27 18:08:39.628165-05	2024-04-27 18:08:39.628165-05	t	f	\N	\N	\N
avatars	avatars	\N	2024-04-28 16:24:10.914773-05	2024-04-28 16:24:10.914773-05	t	f	\N	\N	\N
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2024-04-21 20:26:09.297103
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2024-04-21 20:26:09.378443
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2024-04-21 20:26:09.441744
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2024-04-21 20:26:09.484868
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2024-04-21 20:26:09.570055
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2024-04-21 20:26:09.628999
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2024-04-21 20:26:09.700318
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2024-04-21 20:26:09.735883
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2024-04-21 20:26:09.792403
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2024-04-21 20:26:09.860258
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2024-04-21 20:26:09.874463
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2024-04-21 20:26:09.888137
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2024-04-21 20:26:09.903129
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2024-04-21 20:26:09.919307
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2024-04-21 20:26:09.932462
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2024-04-21 20:26:10.03011
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2024-04-21 20:26:10.050436
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2024-04-21 20:26:10.071166
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2024-04-21 20:26:10.15145
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2024-04-21 20:26:10.1724
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2024-04-21 20:26:10.189143
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2024-04-21 20:26:10.255745
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2024-04-21 20:26:10.306093
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2024-04-21 20:26:10.389262
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2024-06-20 15:56:54.374609
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id) FROM stdin;
3a6e9fca-91ce-48d9-8b31-0aadcd16396f	tech-trove-data	product-images/fractal-design-ion-760p.jpg	\N	2024-04-27 22:27:27.546551-05	2024-04-27 22:27:27.546551-05	2024-04-27 22:27:27.546551-05	{"eTag": "\\"c5cc9c9f6cae760290685af3ea78182d\\"", "size": 25922, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:27:28.000Z", "contentLength": 25922, "httpStatusCode": 200}	2c80ad46-bca9-4c00-8590-8ea81270db9b	\N
897d3590-dc32-4913-b87c-02f619b17af9	tech-trove-data	product-images/tech-entry-2.png	\N	2024-04-27 18:10:38.258241-05	2024-04-27 18:10:38.258241-05	2024-04-27 18:10:38.258241-05	{"eTag": "\\"a1ab0b7f320f3f6dda82838ca119b7be\\"", "size": 35984, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:39.000Z", "contentLength": 35984, "httpStatusCode": 200}	bcc73b3c-882f-4f20-86ed-9787b6508501	\N
821f1025-81b2-4751-8c04-db76758915bd	tech-trove-data	product-images/adata-xpg-sx8200-pro.jpg	\N	2024-04-27 18:10:26.198264-05	2024-04-27 21:33:27.284956-05	2024-04-27 18:10:26.198264-05	{"eTag": "\\"9b304fcd3afd80c53f818dfb9ceabd68\\"", "size": 72076, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:33:28.000Z", "contentLength": 72076, "httpStatusCode": 200}	ba26209d-8b5a-4597-8127-70fe1c796f1b	\N
90b2bddc-b14d-42f6-a609-2732d21d90a2	tech-trove-data	product-images/amd-ryzen-3-3300x.webp	\N	2024-04-27 18:10:25.911553-05	2024-04-27 21:35:14.211685-05	2024-04-27 18:10:25.911553-05	{"eTag": "\\"b3b3ef2b5636408cdfb059b6bc534b65\\"", "size": 18448, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:35:15.000Z", "contentLength": 18448, "httpStatusCode": 200}	5e66d1de-ab10-4604-89b8-64ca488fcf67	\N
34e9c8bc-dec4-430b-ab14-577c3bafdfb3	tech-trove-data	product-images/amd-ryzen-5-5600x.webp	\N	2024-04-27 18:10:26.038519-05	2024-04-27 21:35:22.591172-05	2024-04-27 18:10:26.038519-05	{"eTag": "\\"48fe55c2b9fb57252da4d543c4446c01\\"", "size": 9772, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:35:23.000Z", "contentLength": 9772, "httpStatusCode": 200}	b54114fa-63be-47d7-99c9-b60f1f0ade10	\N
0845b084-f981-440a-8a27-d3ec6f06be30	tech-trove-data	product-images/amd-ryzen-7-5800x.jpg	\N	2024-04-27 18:10:26.181609-05	2024-04-27 21:35:35.632071-05	2024-04-27 18:10:26.181609-05	{"eTag": "\\"a7e159d0bbf226df5cdcaaf3a56f40c6\\"", "size": 13426, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:35:36.000Z", "contentLength": 13426, "httpStatusCode": 200}	a709103f-ab89-4264-8a92-df3443989985	\N
9f9a21c5-2d84-413e-8a27-ef034d032b8b	tech-trove-data	product-images/alienware-area-51m.webp	\N	2024-04-27 18:10:26.011819-05	2024-04-27 18:10:26.011819-05	2024-04-27 18:10:26.011819-05	{"eTag": "\\"e1d47c78ce44bb27ad4a30ba6d9e12d4\\"", "size": 10534, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:26.000Z", "contentLength": 10534, "httpStatusCode": 200}	83a686bf-a318-4bac-a71b-371fb974efec	\N
7ddf4c7b-f785-45dd-b894-705e7b4bef42	tech-trove-data	product-images/acer-predator-helios-300.jpg	\N	2024-04-27 18:10:26.180455-05	2024-04-27 18:10:26.180455-05	2024-04-27 18:10:26.180455-05	{"eTag": "\\"19292bbef3ab32df2f9bccfbef8f5261\\"", "size": 67220, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:27.000Z", "contentLength": 67220, "httpStatusCode": 200}	b6a6f71e-215c-4529-9b65-fb1fb4e7a924	\N
d7015875-6449-4345-baa3-00e7b0fcd589	tech-trove-data	product-images/amd-ryzen-7-pro-4750g.webp	\N	2024-04-27 18:10:26.125098-05	2024-04-27 21:35:44.593156-05	2024-04-27 18:10:26.125098-05	{"eTag": "\\"8c50a75674a917d36bb471a80841bff4\\"", "size": 17362, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:35:45.000Z", "contentLength": 17362, "httpStatusCode": 200}	c16323b9-197c-4a2c-a865-13e498231c67	\N
2a0b975a-530b-43c1-bd30-eacedca2054b	tech-trove-data	product-images/amd-ryzen-9-5950x.webp	\N	2024-04-27 18:10:26.075818-05	2024-04-27 21:35:54.475804-05	2024-04-27 18:10:26.075818-05	{"eTag": "\\"608897a5e2b43300f541c27594d88e4a\\"", "size": 7448, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:35:55.000Z", "contentLength": 7448, "httpStatusCode": 200}	78348fc6-a2eb-409a-89d3-9ee3b1c0b2e8	\N
ec24735e-102a-4d62-9c30-69231fe653fc	tech-trove-data	product-images/amd-ryzen-threadripper-3960x.webp	\N	2024-04-27 18:10:26.105283-05	2024-04-27 21:36:03.33911-05	2024-04-27 18:10:26.105283-05	{"eTag": "\\"f4095ce02d983c43a02d60be736acdaf\\"", "size": 8914, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:36:04.000Z", "contentLength": 8914, "httpStatusCode": 200}	5652850f-6e39-4fcb-a7b9-621200a41efe	\N
2d71bab9-2049-42f3-80a0-97cfce4f9315	tech-trove-data	product-images/asus-rog-strix-z590-e.webp	\N	2024-04-27 18:10:25.938177-05	2024-04-27 21:36:27.709768-05	2024-04-27 18:10:25.938177-05	{"eTag": "\\"b5171a90cf5e6bac67b2c01533fc2203\\"", "size": 19522, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:36:28.000Z", "contentLength": 19522, "httpStatusCode": 200}	0127fe38-7561-4fd6-b7dd-436e4a918cbe	\N
56657265-8c98-48df-8a97-9902fedc6d56	tech-trove-data	product-images/seagate-firecuda-520.webp	\N	2024-04-27 18:10:37.36454-05	2024-04-27 18:10:37.36454-05	2024-04-27 18:10:37.36454-05	{"eTag": "\\"f5c98caf53cf0c6d9a1ad6adac2b14e0\\"", "size": 5650, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:38.000Z", "contentLength": 5650, "httpStatusCode": 200}	7156e672-3e8e-46e5-961b-c90a3a136b3c	\N
9d55b3d8-8263-49e8-9878-d6a14dacc2ec	tech-trove-data	product-images/generic-rtx-4080-ti.webp	\N	2024-04-27 18:10:34.398856-05	2024-04-27 22:19:02.895705-05	2024-04-27 18:10:34.398856-05	{"eTag": "\\"652f771e99e6fce6a0b0d61866abf409\\"", "size": 5362, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:19:03.000Z", "contentLength": 5362, "httpStatusCode": 200}	988cc09c-0ead-4565-b8d6-4f434ac83eeb	\N
839b7250-f3d6-4c8c-816e-34f1da131b02	tech-trove-data	product-images/xfx-amd-radeon-rx-6800-xt.jpg	\N	2024-04-27 22:51:29.842867-05	2024-04-27 22:51:29.842867-05	2024-04-27 22:51:29.842867-05	{"eTag": "\\"c152b69515382b6d99b21c30913e02b8\\"", "size": 44098, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:51:30.000Z", "contentLength": 44098, "httpStatusCode": 200}	2e9fb5cb-5d1a-44f4-95ff-324de78a1c31	\N
5c8600dc-db3c-4196-ad9a-44cb0f604da9	tech-trove-data	product-images/avatar.png	\N	2024-04-27 18:10:28.135784-05	2024-04-27 18:10:28.135784-05	2024-04-27 18:10:28.135784-05	{"eTag": "\\"498671bdba1f6d465d4913b8c3e9e5c3\\"", "size": 3450, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:29.000Z", "contentLength": 3450, "httpStatusCode": 200}	e3b68bb7-e44c-4a6b-896d-e2c6cf5ab53f	\N
c7f220f4-2b9a-4fab-91e9-7e1fe5da0a43	tech-trove-data	product-images/wd-black-sn850.webp	\N	2024-04-27 18:10:39.284757-05	2024-04-27 22:24:36.635166-05	2024-04-27 18:10:39.284757-05	{"eTag": "\\"4f11a2ef3a037574c87e6fc3bbbefa81\\"", "size": 4470, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:24:37.000Z", "contentLength": 4470, "httpStatusCode": 200}	5fb0fa5b-af69-4c68-ace3-d158bfa31497	\N
e39acf1a-7b17-4351-931e-96f2be376e24	tech-trove-data	product-images/tech-entry-8.png	\N	2024-04-27 18:10:38.587744-05	2024-04-27 18:10:38.587744-05	2024-04-27 18:10:38.587744-05	{"eTag": "\\"2deccd582a0f69d3dfc8ea5d781d5443\\"", "size": 308693, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:39.000Z", "contentLength": 308693, "httpStatusCode": 200}	6caebd31-0ae4-4a34-b751-7fb9cfb8ebe7	\N
673eae8c-9db2-4b4e-a0b5-f5ec200dbddd	tech-trove-data	product-images/evga-3090-ftw.webp	\N	2024-04-27 18:10:33.583929-05	2024-04-27 18:10:33.583929-05	2024-04-27 18:10:33.583929-05	{"eTag": "\\"43f20bbcfbd2d8dc20c532b6fdc602cd\\"", "size": 13646, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:34.000Z", "contentLength": 13646, "httpStatusCode": 200}	73659034-f59c-4c85-8d7d-f2489b0ef010	\N
68040a16-6b61-489c-8a97-0b07bae1740e	tech-trove-data	product-images/asus-tuf-gaming-x570-plus-wi-fi.webp	\N	2024-04-27 18:10:27.310294-05	2024-04-27 21:36:41.514711-05	2024-04-27 18:10:27.310294-05	{"eTag": "\\"020128537e1e8e59901af33d4704ed74\\"", "size": 14284, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:36:42.000Z", "contentLength": 14284, "httpStatusCode": 200}	fccf242b-3d9f-4712-a5c5-95335abdf140	\N
17283582-7c1f-46d3-8aeb-941f54345264	tech-trove-data	product-images/corsair-rm750x.webp	\N	2024-04-27 18:10:29.985561-05	2024-04-27 21:37:50.990807-05	2024-04-27 18:10:29.985561-05	{"eTag": "\\"83ea0f0aaf33e8a300b756ce4668845f\\"", "size": 11880, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:37:51.000Z", "contentLength": 11880, "httpStatusCode": 200}	e5382af1-8a1a-4f64-9a68-5ab5a303ddac	\N
86e0720b-d7a9-49ef-97bb-16e9e431697b	tech-trove-data	product-images/ek-mana-g2-pc-o11d-evo-distribution-plate-front.webp	\N	2024-04-27 18:10:32.158856-05	2024-04-27 21:38:31.872927-05	2024-04-27 18:10:32.158856-05	{"eTag": "\\"4dde438b5703a696e74cfdb1cb191f69\\"", "size": 37714, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:38:32.000Z", "contentLength": 37714, "httpStatusCode": 200}	108dcff6-27d3-4886-bb69-bd9a46f138bf	\N
b32d02f5-32bf-48ce-af29-b326986eb476	avatars	0.9659437179174146.png	febd26f0-a0f3-45e1-ae65-dbdad2947429	2024-05-15 16:24:29.993124-05	2024-05-15 16:24:29.993124-05	2024-05-15 16:24:29.993124-05	{"eTag": "\\"e16231c72dc45dbdb5f2085298285824\\"", "size": 317089, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-05-15T21:24:30.000Z", "contentLength": 317089, "httpStatusCode": 200}	b78baa07-e3b2-439f-ab83-0a7ba727bdc2	febd26f0-a0f3-45e1-ae65-dbdad2947429
4c58100b-f87f-4220-924c-ed0bb2872ed2	tech-trove-data	product-images/asus-rog-strix-4070-ti.png	\N	2024-04-27 18:10:27.107449-05	2024-04-27 18:10:27.107449-05	2024-04-27 18:10:27.107449-05	{"eTag": "\\"4c179174069f585cc18f5b53952368c6\\"", "size": 50677, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:28.000Z", "contentLength": 50677, "httpStatusCode": 200}	5ba987c3-c583-407e-ae1b-1e1783576110	\N
56eda638-b938-40cc-8296-a04c64b6a449	tech-trove-data	product-images/asus-rog-crosshairs.jpg	\N	2024-04-27 18:10:27.20207-05	2024-04-27 18:10:27.20207-05	2024-04-27 18:10:27.20207-05	{"eTag": "\\"85886f0774f82443ac672cf6451c7c30\\"", "size": 46255, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:28.000Z", "contentLength": 46255, "httpStatusCode": 200}	fccb9f5a-7a53-4ad9-a064-16d0af022780	\N
e988b30d-5f66-426a-94a2-ec0e86ba3451	tech-trove-data	product-images/asus-rog-zephyrus-duo-15.jpg	\N	2024-04-27 18:10:28.098573-05	2024-04-27 18:10:28.098573-05	2024-04-27 18:10:28.098573-05	{"eTag": "\\"9cd3982d3d29ba95f5338a330db38d12\\"", "size": 50356, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:29.000Z", "contentLength": 50356, "httpStatusCode": 200}	6552493c-0c2d-44c9-a82a-63618459fac2	\N
3f36f699-a7fe-4a11-9b0f-c1811e050edb	tech-trove-data	product-images/ek-quantum-vector2-ftw3-3090-bestseller-hp.webp	\N	2024-04-27 18:10:33.489098-05	2024-04-27 21:39:24.120554-05	2024-04-27 18:10:33.489098-05	{"eTag": "\\"ecdcb62c7d698b3df2dc401573bd91d9\\"", "size": 23280, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:39:25.000Z", "contentLength": 23280, "httpStatusCode": 200}	6fde7620-4a7f-4136-bf16-10f9168d6483	\N
b2c5ed9d-996d-41ee-b320-20bcbba383a0	tech-trove-data	product-images/msi-meg-x590-godlike.webp	\N	2024-04-27 18:10:36.45245-05	2024-04-27 22:21:07.365055-05	2024-04-27 18:10:36.45245-05	{"eTag": "\\"899642d8edc04dcb26c3d2789a3ab39d\\"", "size": 13468, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:21:08.000Z", "contentLength": 13468, "httpStatusCode": 200}	91155651-8a72-45a0-bc79-71c7265e429f	\N
3936d5e6-5b5c-4689-9f0b-6874e8041fed	tech-trove-data	product-images/ek-quantum-reflection2-o11xl-bestseller-hp.webp	\N	2024-04-27 18:10:32.099788-05	2024-04-27 21:38:54.881869-05	2024-04-27 18:10:32.099788-05	{"eTag": "\\"dfd687cbff1ace6381efb94d2ca4dcd2\\"", "size": 62558, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:38:55.000Z", "contentLength": 62558, "httpStatusCode": 200}	23c5e14f-ebdf-4543-a6e2-ef6d6191fcac	\N
fa85f4ce-ae33-4004-af13-785361f24e36	tech-trove-data	product-images/heart-outline-shape-svgrepo-com.svg	\N	2024-04-27 18:10:34.310668-05	2024-04-27 18:10:34.310668-05	2024-04-27 18:10:34.310668-05	{"eTag": "\\"232e80573269135aea53ad1ec1b4e023\\"", "size": 1539, "mimetype": "image/svg+xml", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:35.000Z", "contentLength": 1539, "httpStatusCode": 200}	a8a9b88c-541f-4322-9ebb-a371e1127279	\N
b7d23f42-6b7b-4fe7-b0f1-d3bedbb13ac1	tech-trove-data	product-images/seasonic-focus-plus-650-gold.webp	\N	2024-04-27 18:10:37.345304-05	2024-04-27 22:23:43.959423-05	2024-04-27 18:10:37.345304-05	{"eTag": "\\"07a7f843a3c93fef1dcb248bbd319459\\"", "size": 7998, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:23:44.000Z", "contentLength": 7998, "httpStatusCode": 200}	cba64bff-39a8-4508-a02c-882bc41fbdc9	\N
fa7cb423-d584-4d87-a24b-21dd70ea7def	tech-trove-data	product-images/rog-strix-17-gaming.jpg	\N	2024-04-27 18:10:36.595369-05	2024-04-27 18:10:36.595369-05	2024-04-27 18:10:36.595369-05	{"eTag": "\\"a3f2df1fe4654892c06913cbeafba65d\\"", "size": 61439, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:37.000Z", "contentLength": 61439, "httpStatusCode": 200}	2734a3d1-126b-4752-b693-4d4d597c405d	\N
071fbd09-2a0c-4d3b-8edd-15a71acfbc59	avatars	0.19362489390788196.gif	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-09 08:59:17.32943-05	2024-05-09 08:59:17.32943-05	2024-05-09 08:59:17.32943-05	{"eTag": "\\"1155e377899b0d0a5b9ad4dadb56921e\\"", "size": 971817, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2024-05-09T13:59:18.000Z", "contentLength": 971817, "httpStatusCode": 200}	b3b21fc2-b347-4fab-9b90-2fc0e3758068	2fa8db11-64cd-4b26-b8bf-94b2191bb88b
ddcb6386-51cb-4921-a025-0136b9076d40	tech-trove-data	product-images/asus-rog-matrix-cooling.webp	\N	2024-04-27 18:10:27.121139-05	2024-04-27 18:10:27.121139-05	2024-04-27 18:10:27.121139-05	{"eTag": "\\"866582d6eb4be3b9607a710104654bc8\\"", "size": 14460, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:28.000Z", "contentLength": 14460, "httpStatusCode": 200}	ccad517e-d956-4684-b376-abfb2a4c0d94	\N
51bc3f1e-fe38-4eeb-aa7b-eff42b909856	tech-trove-data	product-images/intel-core-i3-10100.jpg	\N	2024-04-27 18:10:35.272318-05	2024-04-27 22:19:58.303846-05	2024-04-27 18:10:35.272318-05	{"eTag": "\\"648a78a13a99c0006b8120397b3a9c51\\"", "size": 9681, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:19:59.000Z", "contentLength": 9681, "httpStatusCode": 200}	7dbf43a1-7528-4b24-8cc0-a5304b88664f	\N
d22cc24a-a4d6-4cd0-8200-45973a1eca20	tech-trove-data	product-images/tech-entry-3.png	\N	2024-04-27 18:10:38.423601-05	2024-04-27 18:10:38.423601-05	2024-04-27 18:10:38.423601-05	{"eTag": "\\"6f03b5c3bbd283718c13ff4ebac87a4d\\"", "size": 122500, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:39.000Z", "contentLength": 122500, "httpStatusCode": 200}	cdc62e6d-c962-4184-9768-0e7c63b710f3	\N
e5ef2f73-c358-4086-a0d2-1591ce564220	tech-trove-data	product-images/rtx-2060-super-aorus.webp	\N	2024-04-27 18:10:36.303319-05	2024-04-27 22:21:47.020612-05	2024-04-27 18:10:36.303319-05	{"eTag": "\\"2cc45e7af705e434d19267f881163604\\"", "size": 16026, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:21:47.000Z", "contentLength": 16026, "httpStatusCode": 200}	66863476-6d54-4d61-bd1b-202414b44990	\N
77e7724c-3fa7-4073-83bc-2e4cffdd7370	tech-trove-data	product-images/samsung-980-pro.webp	\N	2024-04-27 18:10:37.343447-05	2024-04-27 22:23:22.039528-05	2024-04-27 18:10:37.343447-05	{"eTag": "\\"453503bbd14563ee80067f77f2223a5c\\"", "size": 2720, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:23:22.000Z", "contentLength": 2720, "httpStatusCode": 200}	287ea0d2-4f0f-4ea8-a8c3-41feb1a8ec36	\N
38e8e46f-3021-468e-81f5-7d9b5a7318fe	tech-trove-data	product-images/xpg-core-reactor.webp	\N	2024-04-27 18:10:39.277433-05	2024-04-27 18:10:39.277433-05	2024-04-27 18:10:39.277433-05	{"eTag": "\\"5d3d26f48cca2a8215a36dcb8af922aa\\"", "size": 17652, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:40.000Z", "contentLength": 17652, "httpStatusCode": 200}	6fb32196-4e0a-4e14-b032-a669d78e20bb	\N
59533288-c368-4859-992a-cbbca6fbe32f	tech-trove-data	product-images/lenovo-legion-5-pro.webp	\N	2024-04-27 18:10:35.462108-05	2024-04-27 18:10:35.462108-05	2024-04-27 18:10:35.462108-05	{"eTag": "\\"28f88fb6405a2e62007b7882cb6577ed\\"", "size": 10998, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:36.000Z", "contentLength": 10998, "httpStatusCode": 200}	bf761ca2-68da-4685-b93d-bc63c893e549	\N
afded7db-02ca-423b-a976-16b084d302e4	tech-trove-data	product-images/cooler-master-v750.webp	\N	2024-04-27 18:10:28.144784-05	2024-04-27 21:37:09.716528-05	2024-04-27 18:10:28.144784-05	{"eTag": "\\"7ad4f180d780666f42ac4aad5c947bc0\\"", "size": 8422, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:37:10.000Z", "contentLength": 8422, "httpStatusCode": 200}	a6fc1760-43e1-43d7-85fc-e02869d13dfd	\N
0d620256-afe2-49e5-9f68-11659cbeafa3	tech-trove-data	product-images/rog-dominus-extream-motherboard.jpg	\N	2024-04-27 18:10:36.504225-05	2024-04-27 18:10:36.504225-05	2024-04-27 18:10:36.504225-05	{"eTag": "\\"c309458ff6c71fe3b84f4aa8e2fbe9e1\\"", "size": 118149, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:37.000Z", "contentLength": 118149, "httpStatusCode": 200}	4951e9d8-b684-4771-b686-c7ad59462dc0	\N
ddde055e-6c3a-4720-ac0e-64a7c8eab632	tech-trove-data	product-images/techtrove-logo.png	\N	2024-04-27 18:10:38.227443-05	2024-04-27 22:24:16.053294-05	2024-04-27 18:10:38.227443-05	{"eTag": "\\"a5b8794e144c8b2fd4853a7147294dc5\\"", "size": 28375, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:24:16.000Z", "contentLength": 28375, "httpStatusCode": 200}	4d5823a0-855e-4ad5-ae39-76c262f5a0cb	\N
8c3134cd-c3b4-4bcf-869f-4f8045631e3b	tech-trove-data	product-images/corsair-dominator-platinum.webp	\N	2024-04-27 18:10:29.986574-05	2024-04-27 21:37:30.192202-05	2024-04-27 18:10:29.986574-05	{"eTag": "\\"9f21480f7f882981b58384d4eba7205c\\"", "size": 9222, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:37:31.000Z", "contentLength": 9222, "httpStatusCode": 200}	0f6e8940-7dc3-48f3-8e5b-ca9c7a14a10d	\N
9f4c67f6-95f8-4c98-bff6-3d2b0dead51a	tech-trove-data	product-images/ek-loot-mousepad-quantum-dimensions-l.jpg	\N	2024-04-27 18:10:31.956754-05	2024-04-27 21:38:23.9464-05	2024-04-27 18:10:31.956754-05	{"eTag": "\\"6e2d38e2adb8b0cea4aa2c27370317d5\\"", "size": 49166, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:38:24.000Z", "contentLength": 49166, "httpStatusCode": 200}	26c286c5-ff91-4324-a83f-4b0c15ca4dda	\N
7b5a0efa-a16f-43ab-8f50-e9d89ca59af7	tech-trove-data	product-images/ek-quantum-momentum2-rog-strix-x670e-i-d-rgb-plexi-front.webp	\N	2024-04-27 18:10:32.136161-05	2024-04-27 21:38:42.605043-05	2024-04-27 18:10:32.136161-05	{"eTag": "\\"20d1df53a46ce28ac034b9b6432315fb\\"", "size": 29880, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:38:43.000Z", "contentLength": 29880, "httpStatusCode": 200}	f576b5e9-9c4a-40ea-8eaf-997f99739e13	\N
6db08fea-b68d-4f46-b655-6a8256897ca3	tech-trove-data	product-images/asus-ROG-strix-4070-oc-edition.webp	\N	2024-04-27 18:10:27.101199-05	2024-04-27 18:10:27.101199-05	2024-04-27 18:10:27.101199-05	{"eTag": "\\"4064c84806472237a3e1082f0ddfc098\\"", "size": 15490, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:28.000Z", "contentLength": 15490, "httpStatusCode": 200}	83d2518b-f8e0-4cfe-8154-7e053bf68797	\N
40d0fb4d-4d02-4589-ad9e-00c81ef69c98	tech-trove-data	product-images/samsung-970-evo-plus.webp	\N	2024-04-27 18:10:37.339782-05	2024-04-27 18:10:37.339782-05	2024-04-27 18:10:37.339782-05	{"eTag": "\\"44a5bdc247b50256641b8fd2b36a6348\\"", "size": 6764, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:38.000Z", "contentLength": 6764, "httpStatusCode": 200}	a37830f2-6ab9-4cae-8453-0cea09450b0b	\N
5bbbb2cb-c6cb-4e19-9a31-1f094f2ff41b	tech-trove-data	product-images/ek-fluid-gaming-product-listing-conqueror-intel-4090.webp	\N	2024-04-27 18:10:32.515222-05	2024-04-27 23:09:43.196177-05	2024-04-27 18:10:32.515222-05	{"eTag": "\\"354ec0432ffe8f614dc093a6d0012f4e\\"", "size": 857554, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T04:09:43.000Z", "contentLength": 857554, "httpStatusCode": 200}	191731b5-0e3d-4e81-ad28-f6bde8c89aed	\N
55047a5a-f81b-413d-80b9-f43a419b824e	tech-trove-data	product-images/g-skill-trident-z-royal.jpg	\N	2024-04-27 18:10:34.380496-05	2024-04-27 22:18:35.707935-05	2024-04-27 18:10:34.380496-05	{"eTag": "\\"f941e205526f8622d33689fa827bb385\\"", "size": 39530, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:18:36.000Z", "contentLength": 39530, "httpStatusCode": 200}	1215c95d-c237-4dbe-903d-4dc4d9e42291	\N
40217cd9-0869-4fee-bc72-50ded0ddb869	tech-trove-data	product-images/tech-entry-7.png	\N	2024-04-27 18:10:38.341432-05	2024-04-27 18:10:38.341432-05	2024-04-27 18:10:38.341432-05	{"eTag": "\\"464fc7b4daef005f47bdc1eabb1c5b60\\"", "size": 130624, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:39.000Z", "contentLength": 130624, "httpStatusCode": 200}	8df208aa-d80a-456e-9a15-dc368997ac7e	\N
30bb7aa3-a26a-4b98-b54c-01200dfdb741	tech-trove-data	product-images/tech-entry-6.png	\N	2024-04-27 18:10:38.50738-05	2024-04-27 18:10:38.50738-05	2024-04-27 18:10:38.50738-05	{"eTag": "\\"3979702b2b3fea3120a87e14443584a6\\"", "size": 116874, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:39.000Z", "contentLength": 116874, "httpStatusCode": 200}	ad076e4e-ffbc-45a3-a333-3a24a80770c5	\N
677255e3-8754-41f5-8ec2-61815c288d8f	tech-trove-data	product-images/intel-core-i7-11700k.webp	\N	2024-04-27 18:10:35.358357-05	2024-04-27 22:20:35.081228-05	2024-04-27 18:10:35.358357-05	{"eTag": "\\"de03626f04ab15f76701a9e070cdee6d\\"", "size": 5824, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:20:35.000Z", "contentLength": 5824, "httpStatusCode": 200}	5ee9d3a9-7491-4d36-aa1a-e4d81ab84ecd	\N
514c2fa4-8348-41fd-bfb5-2e75413b372a	tech-trove-data	product-images/wd-blue-sn550.jpg	\N	2024-04-27 18:10:39.390224-05	2024-04-27 18:10:39.390224-05	2024-04-27 18:10:39.390224-05	{"eTag": "\\"fcb81b7febd5f1b3a6a8ec07e4c43061\\"", "size": 42828, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:40.000Z", "contentLength": 42828, "httpStatusCode": 200}	f60a1993-94dd-4291-968a-047941cd0c2c	\N
cf9c30a7-2481-424e-838d-22223989fa77	tech-trove-data	product-images/biostar-racing-z490gtn.webp	\N	2024-04-27 18:10:28.217-05	2024-04-27 21:36:57.92066-05	2024-04-27 18:10:28.217-05	{"eTag": "\\"679f219ba419b8b780d4db96a04b9b11\\"", "size": 9218, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:36:58.000Z", "contentLength": 9218, "httpStatusCode": 200}	853a1510-8eaa-4768-a61e-8fe1d655d6b5	\N
f6c2a0d9-1b6c-4d3b-aed8-7b9af79c5d16	tech-trove-data	product-images/rog-strix-z790-h-gaming.png	\N	2024-04-27 18:10:36.457849-05	2024-04-27 22:21:35.573501-05	2024-04-27 18:10:36.457849-05	{"eTag": "\\"9e8336cd0061516f724d08b93848aa48\\"", "size": 341157, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:21:36.000Z", "contentLength": 341157, "httpStatusCode": 200}	fd2aef4b-309b-4b9b-a6ec-01844a6112e0	\N
9119498f-35a4-4458-ad9d-5dc6e6d9c614	tech-trove-data	product-images/crucial-ballistix-max.jpg	\N	2024-04-27 18:10:29.968139-05	2024-04-27 21:38:04.4345-05	2024-04-27 18:10:29.968139-05	{"eTag": "\\"48caeea6e8a141b00e55b4cffe31112f\\"", "size": 11106, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:38:05.000Z", "contentLength": 11106, "httpStatusCode": 200}	693af254-e135-457c-b72e-8ee2325c797c	\N
3830bb50-709d-4c55-b594-56a081ba3268	tech-trove-data	product-images/ek-quantum-surface-p360m-bestseller-hp.webp	\N	2024-04-27 18:10:32.141662-05	2024-04-27 21:39:07.571507-05	2024-04-27 18:10:32.141662-05	{"eTag": "\\"465a669cd93cca5d4631e5c7e82baf9f\\"", "size": 30244, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:39:08.000Z", "contentLength": 30244, "httpStatusCode": 200}	343fbb36-b67f-4f7b-bb44-f83a0426e835	\N
d0a3a5fa-3882-4338-bda5-cec19ed2fa56	tech-trove-data	product-images/asus-rog-rampage-mother.webp	\N	2024-04-27 18:10:26.990039-05	2024-04-27 18:10:26.990039-05	2024-04-27 18:10:26.990039-05	{"eTag": "\\"398307d1f78bd4c02b7a6358bd539b9d\\"", "size": 23822, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:27.000Z", "contentLength": 23822, "httpStatusCode": 200}	006df423-f2b3-466d-b6bb-34da7f89703a	\N
51d61be7-651d-4f9e-bd6a-cafb3d79207f	tech-trove-data	product-images/asus-rog-rampage-mother.jpg	\N	2024-04-27 18:10:27.07436-05	2024-04-27 18:10:27.07436-05	2024-04-27 18:10:27.07436-05	{"eTag": "\\"c9f09bcb6d7fa62c361af35186be43ef\\"", "size": 35924, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:27.000Z", "contentLength": 35924, "httpStatusCode": 200}	a5970ae8-74a1-42f9-8456-79653a93d0f5	\N
0eea200d-74ff-4590-ac3f-971fd0ab668f	tech-trove-data	product-images/ek-quantum-vector-tuf-rtx-3070-d-rgb-nickelplexi-front.webp	\N	2024-04-27 18:10:32.045255-05	2024-04-27 22:15:34.153745-05	2024-04-27 18:10:32.045255-05	{"eTag": "\\"6184438227815237e18287b4ff88de5f\\"", "size": 31088, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:15:34.000Z", "contentLength": 31088, "httpStatusCode": 200}	c3a88c44-82f9-4d91-812c-a7b8a820adf0	\N
4bf614f8-6635-4114-bbb0-52668b083bd4	tech-trove-data	product-images/tech-entry-1.png	\N	2024-04-27 18:10:38.188868-05	2024-04-27 18:10:38.188868-05	2024-04-27 18:10:38.188868-05	{"eTag": "\\"60191aa53c05896429bbf938a40328a9\\"", "size": 36084, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:39.000Z", "contentLength": 36084, "httpStatusCode": 200}	a049e970-16fa-46e1-bfa2-020bb3d85a8b	\N
d76f5eb2-ed71-48a6-8eb0-1ace703332ab	tech-trove-data	product-images/tech-entry-4.png	\N	2024-04-27 18:10:38.451799-05	2024-04-27 18:10:38.451799-05	2024-04-27 18:10:38.451799-05	{"eTag": "\\"11ab4799267a17127c1e3bb9689e764f\\"", "size": 109916, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:39.000Z", "contentLength": 109916, "httpStatusCode": 200}	58fab2f8-dc18-4125-9290-510656aa7842	\N
c3a335e3-c850-42ca-b353-280e30c22bbd	tech-trove-data	product-images/evga-3080-ftw.jpg	\N	2024-04-27 18:10:33.565297-05	2024-04-27 18:10:33.565297-05	2024-04-27 18:10:33.565297-05	{"eTag": "\\"8921922f6b799ad1f8cb3f0141cce17b\\"", "size": 69625, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:34.000Z", "contentLength": 69625, "httpStatusCode": 200}	dadf1fcf-859a-461b-b12b-9f02036eac57	\N
f9d4b616-8289-48f2-bd9c-19491fbbd778	tech-trove-data	product-images/gtx-1660-super-msi.webp	\N	2024-04-27 18:10:34.549678-05	2024-04-27 22:18:54.128269-05	2024-04-27 18:10:34.549678-05	{"eTag": "\\"bb17e73c475c46f2573db80623fbb1a5\\"", "size": 15890, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:18:55.000Z", "contentLength": 15890, "httpStatusCode": 200}	33262e87-f1ba-436a-a196-59db692b5f88	\N
bf02053a-4e11-4456-a9d1-4eb657442ef9	avatars	0.0660150166228457.png	febd26f0-a0f3-45e1-ae65-dbdad2947429	2024-05-15 16:32:17.317654-05	2024-05-15 16:32:17.317654-05	2024-05-15 16:32:17.317654-05	{"eTag": "\\"e16231c72dc45dbdb5f2085298285824\\"", "size": 317089, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-05-15T21:32:18.000Z", "contentLength": 317089, "httpStatusCode": 200}	43959564-6527-408d-a009-bb9663b6eb89	febd26f0-a0f3-45e1-ae65-dbdad2947429
88302917-4f0a-44ea-870c-ac345e88cbc8	tech-trove-data	product-images/thermaltake-toughpower-grand-rgb-1050w.jpg	\N	2024-04-27 18:10:39.288697-05	2024-04-27 18:10:39.288697-05	2024-04-27 18:10:39.288697-05	{"eTag": "\\"de479344e98304f7aa248a60c8c83cc1\\"", "size": 33624, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:40.000Z", "contentLength": 33624, "httpStatusCode": 200}	a4ad30cc-7a4c-4e37-8ac4-93ef08ab90c5	\N
5115e32a-1a43-4f87-8905-713aa8aef1ba	tech-trove-data	product-images/logo.svg	\N	2024-04-27 18:10:35.393872-05	2024-04-27 18:10:35.393872-05	2024-04-27 18:10:35.393872-05	{"eTag": "\\"346e12ee28bb0e5f5600d47beb4c7a47\\"", "size": 276, "mimetype": "image/svg+xml", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:36.000Z", "contentLength": 276, "httpStatusCode": 200}	450138e8-95d0-493c-98bf-7ae3cfaffc12	\N
9ec6a8ae-1d2a-470d-8296-802e666aeb39	tech-trove-data	product-images/be-quiet-straight-power-11-650w.jpg	\N	2024-04-27 18:10:28.205094-05	2024-04-27 21:36:49.568002-05	2024-04-27 18:10:28.205094-05	{"eTag": "\\"5172ebdd459670d01d3a9ee7a9833245\\"", "size": 17152, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:36:50.000Z", "contentLength": 17152, "httpStatusCode": 200}	914eb376-8100-49d9-87cc-009aca5db8a5	\N
4dd622a6-9eb0-40ea-8cf3-7a8551552fed	tech-trove-data	product-images/msi-ge66-raider.webp	\N	2024-04-27 18:10:36.327014-05	2024-04-27 18:10:36.327014-05	2024-04-27 18:10:36.327014-05	{"eTag": "\\"301ed107545ce2a317572150cad0d048\\"", "size": 8586, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:37.000Z", "contentLength": 8586, "httpStatusCode": 200}	6c2c82d6-18a5-498d-bb80-c22c022d2ba7	\N
b96afaa4-082f-4525-bd61-e8f88decc81f	tech-trove-data	product-images/crucial-p5.webp	\N	2024-04-27 18:10:29.989776-05	2024-04-27 21:38:12.458219-05	2024-04-27 18:10:29.989776-05	{"eTag": "\\"c881d18a9a7f21a43c7c9655c13dffd1\\"", "size": 4830, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:38:13.000Z", "contentLength": 4830, "httpStatusCode": 200}	4ec7edfd-4b41-49c7-9337-f954999f3ea4	\N
f937b773-7829-479b-bcde-0fac51cd58af	tech-trove-data	product-images/gigabyte-rtx-3080-ti-aorus-master.webp	\N	2024-04-27 18:10:34.358072-05	2024-04-27 22:19:38.053181-05	2024-04-27 18:10:34.358072-05	{"eTag": "\\"fcb334a47c108d073eff3423afec0b97\\"", "size": 15044, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:19:38.000Z", "contentLength": 15044, "httpStatusCode": 200}	618d953a-bfff-4c15-ae77-c7bf673fc362	\N
8cffd9ce-7281-4849-bd7c-50e3cb7c73ad	tech-trove-data	product-images/ntel-core-i5-10400f.webp	\N	2024-04-27 18:10:35.220753-05	2024-04-27 22:20:08.41535-05	2024-04-27 18:10:35.220753-05	{"eTag": "\\"726dcbc73d97a9d330dc651c355cbbad\\"", "size": 7226, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:20:09.000Z", "contentLength": 7226, "httpStatusCode": 200}	0f9bc6a0-e601-40c5-bd32-1e9e5629b7bf	\N
de7fefa7-7bb9-4b7c-92b2-65e3a84462d5	tech-trove-data	product-images/g-skill-trident-z-neo.webp	\N	2024-04-27 18:10:33.490642-05	2024-04-27 22:16:54.249325-05	2024-04-27 18:10:33.490642-05	{"eTag": "\\"6a6f366df84bf97fe4e7e31e6bf6a969\\"", "size": 7806, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:16:55.000Z", "contentLength": 7806, "httpStatusCode": 200}	740bb19a-8bd7-4aff-91c2-c3d2324e4380	\N
445852b2-5d79-4fb2-b37d-daff471ca3fc	tech-trove-data	product-images/gigabyte-aorus-17g.webp	\N	2024-04-27 18:10:34.349677-05	2024-04-27 18:10:34.349677-05	2024-04-27 18:10:34.349677-05	{"eTag": "\\"b9bb05249e4cd6ef572af52810944704\\"", "size": 7750, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:35.000Z", "contentLength": 7750, "httpStatusCode": 200}	a2816753-efd5-4d6c-b189-9038728869f8	\N
794b1b32-cba9-4ea9-9525-2fd5139ca553	tech-trove-data	product-images/hp-omen-15.webp	\N	2024-04-27 18:10:35.258162-05	2024-04-27 18:10:35.258162-05	2024-04-27 18:10:35.258162-05	{"eTag": "\\"d5859552dff533ca2db0c020624e9734\\"", "size": 7814, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:36.000Z", "contentLength": 7814, "httpStatusCode": 200}	b6f397f4-5a08-4bbc-ae12-f8f95fbe27f9	\N
b1873377-73b6-4661-a013-a2a1b74933bd	tech-trove-data	product-images/gigabyte-aorus-rtx-4080-master.jpg	\N	2024-04-27 18:10:34.511307-05	2024-04-27 22:19:24.196498-05	2024-04-27 18:10:34.511307-05	{"eTag": "\\"1eb464594b3ba0f8e0221ce0f503b016\\"", "size": 32865, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:19:25.000Z", "contentLength": 32865, "httpStatusCode": 200}	7f227657-1eae-4677-b9ae-a85eedb4fc5f	\N
449dcde8-6a4e-437a-a13a-9bbd36402db7	tech-trove-data	product-images/teamgroup-t-force-xtreem-argb.webp	\N	2024-04-27 18:10:37.313596-05	2024-04-27 22:23:57.159399-05	2024-04-27 18:10:37.313596-05	{"eTag": "\\"4b6a3c2cacae2034003966144f887d8e\\"", "size": 8136, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:23:58.000Z", "contentLength": 8136, "httpStatusCode": 200}	11a393da-7003-4ac2-bcf5-5b4e0ded9675	\N
534ca836-be3a-4cc7-adf7-382aa1898768	avatars	0.11768257317868658.png	febd26f0-a0f3-45e1-ae65-dbdad2947429	2024-05-15 16:34:39.524824-05	2024-05-15 16:34:39.524824-05	2024-05-15 16:34:39.524824-05	{"eTag": "\\"e16231c72dc45dbdb5f2085298285824\\"", "size": 317089, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-05-15T21:34:40.000Z", "contentLength": 317089, "httpStatusCode": 200}	f083a1b1-740a-4ea2-afe1-4f6fbc89d7cd	febd26f0-a0f3-45e1-ae65-dbdad2947429
b23ec154-aa19-4938-a4de-336eede98035	tech-trove-data	product-images/ek-quantum-vector-xc3-rtx-3070-d-rgb-nickelplexi-front.webp	\N	2024-04-27 18:10:32.160253-05	2024-04-27 22:15:22.586877-05	2024-04-27 18:10:32.160253-05	{"eTag": "\\"a77854ee88046a42a76547b24d1439ac\\"", "size": 20602, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:15:23.000Z", "contentLength": 20602, "httpStatusCode": 200}	e8f8d249-fe43-48b9-9963-237be1300a5d	\N
a89a3ee8-c67c-4611-94f2-9568cdff2c00	tech-trove-data	product-images/ek-fluid-gaming-titan-hero.png	\N	2024-04-27 18:10:32.638653-05	2024-04-27 23:10:30.155468-05	2024-04-27 18:10:32.638653-05	{"eTag": "\\"bdb6380b0d2267cf594d7e358b92ad26\\"", "size": 657356, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T04:10:31.000Z", "contentLength": 657356, "httpStatusCode": 200}	aa7b172a-5ad1-49ba-b9c5-242e7069b57f	\N
e3597015-4bda-4d73-a44f-f4fb73fd4b5d	tech-trove-data	product-images/crucial-mx500.webp	\N	2024-04-27 18:10:30.07481-05	2024-04-27 18:10:30.07481-05	2024-04-27 18:10:30.07481-05	{"eTag": "\\"abfd9bfce9c6ee91bdd2a61d370518be\\"", "size": 15734, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:31.000Z", "contentLength": 15734, "httpStatusCode": 200}	879e28f2-dd33-4514-ac36-5651d1a0d3a3	\N
a1afca1f-8c52-41c3-9d7e-48590d684a70	tech-trove-data	product-images/g-skill-trident-z-royal-series.jpg	\N	2024-04-27 18:10:33.404452-05	2024-04-27 22:17:41.088814-05	2024-04-27 18:10:33.404452-05	{"eTag": "\\"58b68b86623efa3d65c4b424823fe430\\"", "size": 9851, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:17:41.000Z", "contentLength": 9851, "httpStatusCode": 200}	3beb14d3-7adc-4998-8b8e-597a3fed9730	\N
a985bd60-b082-4295-a153-dd419d5cd8e8	avatars	0.05632919269038705.gif	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-09 10:26:36.528073-05	2024-05-09 10:26:36.528073-05	2024-05-09 10:26:36.528073-05	{"eTag": "\\"1155e377899b0d0a5b9ad4dadb56921e\\"", "size": 971817, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2024-05-09T15:26:37.000Z", "contentLength": 971817, "httpStatusCode": 200}	63eef28b-4f07-4cdf-a439-7b26b568ac89	2fa8db11-64cd-4b26-b8bf-94b2191bb88b
ed1b76e1-2273-4132-94e2-17936dae1189	tech-trove-data	product-images/evga-3090ti-ftw.jpg	\N	2024-04-27 18:10:33.52304-05	2024-04-27 18:10:33.52304-05	2024-04-27 18:10:33.52304-05	{"eTag": "\\"bb53295b577ece161e0ed4f723bb7436\\"", "size": 36942, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:34.000Z", "contentLength": 36942, "httpStatusCode": 200}	e10704c8-929c-42fd-bc7e-b8272e30145e	\N
4d5b3e7c-dd29-4ad1-8366-0a9fb68705c1	tech-trove-data	product-images/asus-rog-thor-850.webp	\N	2024-04-27 18:10:27.250238-05	2024-04-27 21:36:21.54983-05	2024-04-27 18:10:27.250238-05	{"eTag": "\\"4fecc7ad5b77fe4edc9f19366482cb8e\\"", "size": 16942, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:36:22.000Z", "contentLength": 16942, "httpStatusCode": 200}	c3197952-6889-4c47-a6cc-9d7b5edd379e	\N
68d8268b-a0ef-48e9-a3d3-957a987aa6f2	tech-trove-data	product-images/heart-fill-svgrepo-com (1).svg	\N	2024-04-27 18:10:34.263267-05	2024-04-27 18:10:34.263267-05	2024-04-27 18:10:34.263267-05	{"eTag": "\\"b2445225ab056de2e4a204afec0dd054\\"", "size": 831, "mimetype": "image/svg+xml", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:35.000Z", "contentLength": 831, "httpStatusCode": 200}	7718499f-4b8c-4a08-ae13-e335fddb99e4	\N
3f5820a8-126a-4419-80e0-5abe3c637788	tech-trove-data	product-images/intel-core-i7-12700k.webp	\N	2024-04-27 18:10:35.332394-05	2024-04-27 22:20:45.163005-05	2024-04-27 18:10:35.332394-05	{"eTag": "\\"006b00310df47eb08297ebf539e34bd7\\"", "size": 5826, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:20:46.000Z", "contentLength": 5826, "httpStatusCode": 200}	69fdd553-f664-4dbe-9c43-c45811fb5cf9	\N
e7566ddb-e146-44e4-9007-40075ed6481f	avatars	0.21226012142298467.gif	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-09 10:28:52.601198-05	2024-05-09 10:28:52.601198-05	2024-05-09 10:28:52.601198-05	{"eTag": "\\"1155e377899b0d0a5b9ad4dadb56921e\\"", "size": 971817, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2024-05-09T15:28:53.000Z", "contentLength": 971817, "httpStatusCode": 200}	c23ef37d-37b0-41de-8657-8b47dc9e4d40	2fa8db11-64cd-4b26-b8bf-94b2191bb88b
ab3e3f74-7463-43dc-b1c2-7b72f47eeb13	tech-trove-data	product-images/mac-book.jpg	\N	2024-04-27 18:10:36.346286-05	2024-04-27 18:10:36.346286-05	2024-04-27 18:10:36.346286-05	{"eTag": "\\"60a58c48eabc00e87e36c9b53297820f\\"", "size": 12713, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:37.000Z", "contentLength": 12713, "httpStatusCode": 200}	7f7dd9cc-f7c6-4bec-8d52-76a9fe491758	\N
9af21616-2af6-4c46-a04a-7e27520cc08c	tech-trove-data	product-images/rtx-3070-rog.jpg	\N	2024-04-27 18:10:37.433215-05	2024-04-27 22:21:55.836509-05	2024-04-27 18:10:37.433215-05	{"eTag": "\\"8ebba546d042605be5c3dd47d31a67ac\\"", "size": 41589, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:21:56.000Z", "contentLength": 41589, "httpStatusCode": 200}	9272c383-83e2-452c-9af8-5704c5e0d590	\N
b4b77223-16f5-4ac4-9f20-1f7b84134755	avatars	0.8286857512313839.gif	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-09 10:29:43.819058-05	2024-05-09 10:29:43.819058-05	2024-05-09 10:29:43.819058-05	{"eTag": "\\"1155e377899b0d0a5b9ad4dadb56921e\\"", "size": 971817, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2024-05-09T15:29:44.000Z", "contentLength": 971817, "httpStatusCode": 200}	03c3f68b-15b6-48cf-9193-ff1b6a46da4b	2fa8db11-64cd-4b26-b8bf-94b2191bb88b
4d3d35fc-834a-4d0a-b26d-fec7199c3a92	tech-trove-data	product-images/rtx-3080.webp	\N	2024-04-27 18:10:37.313523-05	2024-04-27 22:22:54.843003-05	2024-04-27 18:10:37.313523-05	{"eTag": "\\"07eb87c0aa1b3f1183c56c799b5b50f1\\"", "size": 5022, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:22:55.000Z", "contentLength": 5022, "httpStatusCode": 200}	f5e90456-3b28-4ba7-ac00-98cd8659491d	\N
cace3225-2d79-4c16-973b-5ca835b9be2e	avatars	0.36570949157919785.gif	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-09 10:30:41.838937-05	2024-05-09 10:30:41.838937-05	2024-05-09 10:30:41.838937-05	{"eTag": "\\"1155e377899b0d0a5b9ad4dadb56921e\\"", "size": 971817, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2024-05-09T15:30:42.000Z", "contentLength": 971817, "httpStatusCode": 200}	d381887e-2221-4f92-9df5-58b69ea046df	2fa8db11-64cd-4b26-b8bf-94b2191bb88b
73f2eaa2-964a-4d14-ada7-cb6438a810d6	tech-trove-data	product-images/asus-rog-strix-4080-super.png	\N	2024-04-27 18:10:27.249011-05	2024-04-27 18:10:27.249011-05	2024-04-27 18:10:27.249011-05	{"eTag": "\\"470e65e0866f0462917cd432330b3062\\"", "size": 205545, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:28.000Z", "contentLength": 205545, "httpStatusCode": 200}	4cbc0952-c8f1-4de1-a4d1-7475fe414de1	\N
ac76d7c8-4194-4aba-b3d4-5d66b74c5c02	tech-trove-data	product-images/ek-fluid_gaming_product-listing-dragon-blood-2.png	\N	2024-04-27 18:10:31.101139-05	2024-04-27 23:09:54.134234-05	2024-04-27 18:10:31.101139-05	{"eTag": "\\"859d04e6960de22591d0ca9700a8ebd0\\"", "size": 1433467, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T04:09:55.000Z", "contentLength": 1433467, "httpStatusCode": 200}	057389a5-bbf3-492b-a793-2788d3f30ecd	\N
4240cc4e-247c-4716-b905-24bb5a8e307c	tech-trove-data	product-images/asus-tuf-gaming-laptop.webp	\N	2024-04-27 18:10:28.068205-05	2024-04-27 18:10:28.068205-05	2024-04-27 18:10:28.068205-05	{"eTag": "\\"600dcff92762c7c926cd3174cb424dcb\\"", "size": 5912, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:29.000Z", "contentLength": 5912, "httpStatusCode": 200}	76bdb9b8-c8b9-446c-ba01-c347ccf34468	\N
216500f5-33af-4933-baaa-3c4b28ca50fb	tech-trove-data	product-images/asus-rog-strix-4080-super-white.png	\N	2024-04-27 18:10:28.294402-05	2024-04-27 18:10:28.294402-05	2024-04-27 18:10:28.294402-05	{"eTag": "\\"a4765aea9fd01bc6e1f4c427e750d604\\"", "size": 176911, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:29.000Z", "contentLength": 176911, "httpStatusCode": 200}	b0142bbb-251b-4e54-b2c3-78d4c155a835	\N
2f77ece3-7f82-4c8f-b7ed-28c364d0848d	tech-trove-data	product-images/asus-rog-strix-4090-btf.png	\N	2024-04-27 18:10:28.415683-05	2024-04-27 18:10:28.415683-05	2024-04-27 18:10:28.415683-05	{"eTag": "\\"a9121cad2ecc255ab8f6757967fc549e\\"", "size": 224270, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:29.000Z", "contentLength": 224270, "httpStatusCode": 200}	f11b0d55-f648-4bfe-9296-ba00f90ad22e	\N
a4239ff9-4178-403c-8d9f-c1a163e69415	tech-trove-data	product-images/ek-quantum-vector2-fe4090-bestseller-hp.webp	\N	2024-04-27 18:10:33.50492-05	2024-04-27 21:39:16.231402-05	2024-04-27 18:10:33.50492-05	{"eTag": "\\"230e00f083e61c1a96d011dee2860e5c\\"", "size": 51860, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:39:17.000Z", "contentLength": 51860, "httpStatusCode": 200}	a03502db-5224-44e6-8261-05576c78e5e2	\N
58405cfb-4c38-484b-96d1-6a015e5abd13	tech-trove-data	product-images/colorsplash.png	\N	2024-04-27 18:10:29.165873-05	2024-04-27 18:10:29.165873-05	2024-04-27 18:10:29.165873-05	{"eTag": "\\"948082535723a66f0cd8b5ba9d005ef0\\"", "size": 2166708, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:29.000Z", "contentLength": 2166708, "httpStatusCode": 200}	f0abf39a-7b21-40f8-936a-8342780b6eb9	\N
90c70e43-789a-4b64-9199-9b95d9047384	tech-trove-data	product-images/tech-entry-5.png	\N	2024-04-27 18:10:38.362449-05	2024-04-27 18:10:38.362449-05	2024-04-27 18:10:38.362449-05	{"eTag": "\\"746ed16782fea6b9b6e87c57b97fb765\\"", "size": 130596, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:39.000Z", "contentLength": 130596, "httpStatusCode": 200}	499accfb-e33b-4759-9b82-9fbbc8f9f7bd	\N
b69f10b8-78cf-4a6d-bafc-009660e8f9a4	tech-trove-data	product-images/dell-xps-15.jpg	\N	2024-04-27 18:10:30.218524-05	2024-04-27 18:10:30.218524-05	2024-04-27 18:10:30.218524-05	{"eTag": "\\"2e1206f42272dcf1d1bafdcbde26a10b\\"", "size": 67414, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:31.000Z", "contentLength": 67414, "httpStatusCode": 200}	e575e76d-bd15-427c-9980-09ca6592efb9	\N
540940a7-4fd5-4c99-80f8-c413d77b4da0	tech-trove-data	product-images/ek-rog-maximus-xiv-extreme-glacial-landing-page-product-2x-999x1030.png	\N	2024-04-27 18:10:30.752966-05	2024-04-27 22:15:44.602065-05	2024-04-27 18:10:30.752966-05	{"eTag": "\\"5038cb494c52a4d94d42147af6107430\\"", "size": 862735, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:15:45.000Z", "contentLength": 862735, "httpStatusCode": 200}	7b7e3ae9-0478-4ca2-84fc-3f311bc5394e	\N
a3d63539-f929-40a4-b1c6-518e1d594c87	tech-trove-data	product-images/crucial-ballistix-max-4400.jpg	\N	2024-04-27 18:10:29.9774-05	2024-04-27 21:37:57.019053-05	2024-04-27 18:10:29.9774-05	{"eTag": "\\"092e6347834c99fe424fc6f51fbcf9e4\\"", "size": 10518, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:37:57.000Z", "contentLength": 10518, "httpStatusCode": 200}	d317928e-9607-48d9-a621-3aae20604a4e	\N
e95a166f-9b39-49df-b1d3-ba09c5137baa	tech-trove-data	product-images/sk-hynix-gold-p31.webp	\N	2024-04-27 18:10:37.310771-05	2024-04-27 22:23:13.342651-05	2024-04-27 18:10:37.310771-05	{"eTag": "\\"1f0774bece1b639a291ef06e23b71098\\"", "size": 10540, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:23:14.000Z", "contentLength": 10540, "httpStatusCode": 200}	7209f873-3e31-45bf-8930-e4e0f71b9bc7	\N
41557550-0f73-4f55-b05e-2c7e0a716ad9	tech-trove-data	product-images/razer-blade-pro-17.jpg	\N	2024-04-27 18:10:36.208038-05	2024-04-27 18:10:36.208038-05	2024-04-27 18:10:36.208038-05	{"eTag": "\\"55c6a5e41b084b5b068a9684e65b6243\\"", "size": 26535, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:37.000Z", "contentLength": 26535, "httpStatusCode": 200}	ae063893-e1cf-41a3-b1ce-7dfcc04435a3	\N
6af8b6f1-6c14-4b3f-8b36-87681d00b8d9	tech-trove-data	product-images/thermaltake-toughpower-grand-rgb-1050w.webp	\N	2024-04-27 18:10:39.326518-05	2024-04-27 22:24:26.364599-05	2024-04-27 18:10:39.326518-05	{"eTag": "\\"d7ad2d599a1d955a7acebddf3ddd01a5\\"", "size": 15696, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:24:27.000Z", "contentLength": 15696, "httpStatusCode": 200}	ea921202-54d7-4085-ab5d-d848ca89acdf	\N
853f682b-12be-4097-964f-960612b5af99	tech-trove-data	product-images/asus-rog-matrix-cooling.jpg	\N	2024-04-27 18:10:27.024037-05	2024-04-27 18:10:27.024037-05	2024-04-27 18:10:27.024037-05	{"eTag": "\\"072e17e119da6a550f5c6fc732471428\\"", "size": 49391, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:27.000Z", "contentLength": 49391, "httpStatusCode": 200}	910dec6b-098a-4134-88c6-3fd1d007eb0b	\N
821236d7-d04d-45ca-8171-a555611a4f84	tech-trove-data	product-images/evga-z390-dark.webp	\N	2024-04-27 18:10:33.474212-05	2024-04-27 22:16:34.802977-05	2024-04-27 18:10:33.474212-05	{"eTag": "\\"6b4dece812d126666457340ff404901d\\"", "size": 12462, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:16:35.000Z", "contentLength": 12462, "httpStatusCode": 200}	16dce6d6-3727-463b-a05b-1e59073e8c63	\N
82340daf-d39d-4dd7-869e-ff5e752f3568	tech-trove-data	product-images/ek-fluid-gaming-digital-reef-art-1.webp	\N	2024-04-27 18:10:32.087476-05	2024-04-27 18:10:32.087476-05	2024-04-27 18:10:32.087476-05	{"eTag": "\\"18af2cd24437597f674ace4a4ae1e385\\"", "size": 127086, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:32.000Z", "contentLength": 127086, "httpStatusCode": 200}	82482983-442f-4f8e-86d9-29f6c6a0cb08	\N
0cbf809c-34e6-4833-ae22-b24217db437c	avatars	0.14205094570838184.gif	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-09 10:31:08.368383-05	2024-05-09 10:31:08.368383-05	2024-05-09 10:31:08.368383-05	{"eTag": "\\"1155e377899b0d0a5b9ad4dadb56921e\\"", "size": 971817, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2024-05-09T15:31:09.000Z", "contentLength": 971817, "httpStatusCode": 200}	e00e0329-c5f7-4a74-950c-0173623bc296	2fa8db11-64cd-4b26-b8bf-94b2191bb88b
4c82b549-199d-4ba0-99a4-ff46adf7ba3f	tech-trove-data	product-images/corsair-dominator-platinum-rgb.jpg	\N	2024-04-27 18:10:28.194929-05	2024-04-27 21:37:21.314174-05	2024-04-27 18:10:28.194929-05	{"eTag": "\\"5c2eda87bd1bb35fe474697f03066051\\"", "size": 18463, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:37:22.000Z", "contentLength": 18463, "httpStatusCode": 200}	9e6e1aa2-6644-44dd-badf-e32fce8246d9	\N
05b1e82d-0f8a-4c18-886b-17b98abf0748	avatars	0.9051609777285248.gif	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-09 10:32:26.909836-05	2024-05-09 10:32:26.909836-05	2024-05-09 10:32:26.909836-05	{"eTag": "\\"1155e377899b0d0a5b9ad4dadb56921e\\"", "size": 971817, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2024-05-09T15:32:27.000Z", "contentLength": 971817, "httpStatusCode": 200}	757e0f96-f37d-4705-b989-5650f598bb42	2fa8db11-64cd-4b26-b8bf-94b2191bb88b
b496bbb5-d2a7-4519-8f4a-8e8930c00f60	tech-trove-data	product-images/gigabyte-aorus-rtx-3090-xtreme.jpg	\N	2024-04-27 18:10:34.261135-05	2024-04-27 22:19:13.485235-05	2024-04-27 18:10:34.261135-05	{"eTag": "\\"9fae18bf42f1aaa6e0634370d1579a59\\"", "size": 18995, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:19:14.000Z", "contentLength": 18995, "httpStatusCode": 200}	cd0cc429-f1d3-49c3-ae41-20801bf52bca	\N
25931adf-cd78-4015-bf48-054f2c583eae	tech-trove-data	product-images/corsair-force-mp600.webp	\N	2024-04-27 18:10:29.940348-05	2024-04-27 21:37:37.181298-05	2024-04-27 18:10:29.940348-05	{"eTag": "\\"b27d12ab7f961e1101f0d8157a0201fe\\"", "size": 7284, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T02:37:38.000Z", "contentLength": 7284, "httpStatusCode": 200}	9c4a0344-abf8-4624-b84a-d0b05d22d3d9	\N
e235986e-2ce3-48b1-a5c7-f8435b5ce691	avatars	0.6945566470599647.gif	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-09 10:32:54.94983-05	2024-05-09 10:32:54.94983-05	2024-05-09 10:32:54.94983-05	{"eTag": "\\"1155e377899b0d0a5b9ad4dadb56921e\\"", "size": 971817, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2024-05-09T15:32:55.000Z", "contentLength": 971817, "httpStatusCode": 200}	1384a520-90df-49da-aefe-dbef05c3d368	2fa8db11-64cd-4b26-b8bf-94b2191bb88b
444163fe-7889-4edf-b643-25d0a5b3fd67	tech-trove-data	product-images/intel-core-i5-12600k.jpg	\N	2024-04-27 18:10:35.533855-05	2024-04-27 22:20:22.853419-05	2024-04-27 18:10:35.533855-05	{"eTag": "\\"2a6096ac9140ff3e99ae798ac41124f3\\"", "size": 13471, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:20:23.000Z", "contentLength": 13471, "httpStatusCode": 200}	80b8ce52-3a2b-4cda-ad66-b0c1f1d10570	\N
8961c877-b79e-4ef2-ae08-8c6587178ee1	tech-trove-data	product-images/nzxt-c650.webp	\N	2024-04-27 18:10:36.30804-05	2024-04-27 22:21:24.670405-05	2024-04-27 18:10:36.30804-05	{"eTag": "\\"4aa25c7241d5cab846a212a7e21ea9c8\\"", "size": 9120, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:21:25.000Z", "contentLength": 9120, "httpStatusCode": 200}	22830761-08c5-458f-b366-fffd5f85f1cb	\N
8ecefaea-a162-47cb-9416-fa16935e1941	avatars	0.8463750550780973.gif	2fa8db11-64cd-4b26-b8bf-94b2191bb88b	2024-05-09 10:33:30.54808-05	2024-05-09 10:33:30.54808-05	2024-05-09 10:33:30.54808-05	{"eTag": "\\"1155e377899b0d0a5b9ad4dadb56921e\\"", "size": 971817, "mimetype": "image/gif", "cacheControl": "max-age=3600", "lastModified": "2024-05-09T15:33:31.000Z", "contentLength": 971817, "httpStatusCode": 200}	2a98549d-5bf8-4977-9b90-485d149fc971	2fa8db11-64cd-4b26-b8bf-94b2191bb88b
7b6538cc-3c89-41f5-b1f6-7d79c027b3e1	tech-trove-data	product-images/rx-6800-xt.jpg	\N	2024-04-27 18:10:37.331751-05	2024-04-27 22:23:06.364272-05	2024-04-27 18:10:37.331751-05	{"eTag": "\\"9679e85b8de08336e53028560b4827a9\\"", "size": 40007, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:23:07.000Z", "contentLength": 40007, "httpStatusCode": 200}	c579a4c2-cbe6-41e2-a36c-968b0e1d7338	\N
662356de-7fdb-4b22-855f-1c1da2594c36	tech-trove-data	product-images/teamgroup-vulcan-z.webp	\N	2024-04-27 18:10:38.167273-05	2024-04-27 22:24:05.754477-05	2024-04-27 18:10:38.167273-05	{"eTag": "\\"8bafb96682a008abbf95743a8fbcda70\\"", "size": 7764, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:24:06.000Z", "contentLength": 7764, "httpStatusCode": 200}	c55e25df-8b2b-4802-93c6-04c8e294f09f	\N
959e207b-ba08-4d6d-8b48-7f0713dcd2e6	tech-trove-data	product-images/evga-supernova-850-g3.jpg	\N	2024-04-27 18:10:33.46392-05	2024-04-27 22:15:55.725448-05	2024-04-27 18:10:33.46392-05	{"eTag": "\\"6fa93d9158334b466e2266520c59275f\\"", "size": 22830, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:15:56.000Z", "contentLength": 22830, "httpStatusCode": 200}	96934a24-9f74-4469-828d-e0893911fc7b	\N
af2a42b4-b870-43dc-ada8-89d2ad145464	tech-trove-data	product-images/hp-victus-gmaing-15.webp	\N	2024-04-27 18:10:35.394654-05	2024-04-27 18:10:35.394654-05	2024-04-27 18:10:35.394654-05	{"eTag": "\\"08157da2bf79f888197debd376afba41\\"", "size": 20308, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-27T23:10:36.000Z", "contentLength": 20308, "httpStatusCode": 200}	7410449e-b7ae-4ffd-bc54-f8e254d0f804	\N
1de6cca3-7996-492a-a4ac-c9e31a20873e	tech-trove-data	product-images/gigabyte-z690-aorus-master.webp	\N	2024-04-27 18:10:34.389585-05	2024-04-27 22:19:48.199666-05	2024-04-27 18:10:34.389585-05	{"eTag": "\\"7ac42e768889984a199d796afbba8aed\\"", "size": 15926, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:19:49.000Z", "contentLength": 15926, "httpStatusCode": 200}	72140f49-d977-437d-9ce0-d35ed8997cc7	\N
25dae766-59a0-4c5a-b74b-4285cd94806c	tech-trove-data	product-images/intel-core-i9-12900k.webp	\N	2024-04-27 18:10:35.199673-05	2024-04-27 22:21:00.181072-05	2024-04-27 18:10:35.199673-05	{"eTag": "\\"4a70a3edf0da500de240929fd6e48b55\\"", "size": 6008, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:21:01.000Z", "contentLength": 6008, "httpStatusCode": 200}	7f151161-d838-4274-8b04-dd51eeff0db2	\N
bb55422f-5a8a-4f79-b915-c59ccd737222	avatars	0.567356849279913.png	febd26f0-a0f3-45e1-ae65-dbdad2947429	2024-05-15 16:18:01.275965-05	2024-05-15 16:18:01.275965-05	2024-05-15 16:18:01.275965-05	{"eTag": "\\"e16231c72dc45dbdb5f2085298285824\\"", "size": 317089, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-05-15T21:18:02.000Z", "contentLength": 317089, "httpStatusCode": 200}	7767995b-f460-4ca1-b4ba-0cffbeb9b6f8	febd26f0-a0f3-45e1-ae65-dbdad2947429
16c68685-0945-40d6-b641-850368254583	tech-trove-data	product-images/msi-mpg-b550-gaming-edge-wifi.webp	\N	2024-04-27 18:10:36.372503-05	2024-04-27 22:21:16.736018-05	2024-04-27 18:10:36.372503-05	{"eTag": "\\"cb8b8867123f56b15ce6561abc54d33a\\"", "size": 15852, "mimetype": "image/webp", "cacheControl": "max-age=3600", "lastModified": "2024-04-28T03:21:17.000Z", "contentLength": 15852, "httpStatusCode": 200}	690fe74c-816a-444e-adbe-825c6f5b704b	\N
35a62186-817b-4463-9c34-1dc349fc798e	avatars	0.9645924865910291.png	febd26f0-a0f3-45e1-ae65-dbdad2947429	2024-05-15 16:20:16.755288-05	2024-05-15 16:20:16.755288-05	2024-05-15 16:20:16.755288-05	{"eTag": "\\"e16231c72dc45dbdb5f2085298285824\\"", "size": 317089, "mimetype": "image/png", "cacheControl": "max-age=3600", "lastModified": "2024-05-15T21:20:17.000Z", "contentLength": 317089, "httpStatusCode": 200}	dbd3dff4-b247-466a-94fc-403a294d9455	febd26f0-a0f3-45e1-ae65-dbdad2947429
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 137, true);


--
-- Name: badges_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.badges_id_seq', 1, true);


--
-- Name: blog_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.blog_posts_id_seq', 1, false);


--
-- Name: carts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.carts_id_seq', 433, true);


--
-- Name: levels_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.levels_id_seq', 2, true);


--
-- Name: message_board_posts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.message_board_posts_id_seq', 1, false);


--
-- Name: order_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.order_items_id_seq', 1, false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_id_seq', 240, true);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reviews_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, false);


--
-- Name: wishlists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.wishlists_id_seq', 61, true);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.messages_id_seq', 1, false);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: badges badges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.badges
    ADD CONSTRAINT badges_pkey PRIMARY KEY (id);


--
-- Name: blog_posts blog_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_posts
    ADD CONSTRAINT blog_posts_pkey PRIMARY KEY (id);


--
-- Name: carts carts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_pkey PRIMARY KEY (id);


--
-- Name: levels levels_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levels
    ADD CONSTRAINT levels_pkey PRIMARY KEY (id);


--
-- Name: message_board_posts message_board_posts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.message_board_posts
    ADD CONSTRAINT message_board_posts_pkey PRIMARY KEY (id);


--
-- Name: order_items order_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_pkey PRIMARY KEY (id);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: wishlists wishlists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING hash (entity);


--
-- Name: messages_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_topic_index ON realtime.messages USING btree (topic);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: -
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: carts carts_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: carts carts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.carts
    ADD CONSTRAINT carts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id);


--
-- Name: levels levels_badge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.levels
    ADD CONSTRAINT levels_badge_id_fkey FOREIGN KEY (badge_id) REFERENCES public.badges(id);


--
-- Name: order_items order_items_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id);


--
-- Name: order_items order_items_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.order_items
    ADD CONSTRAINT order_items_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id);


--
-- Name: reviews reviews_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: users users_level_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_level_id_fkey FOREIGN KEY (level_id) REFERENCES public.levels(id);


--
-- Name: users users_profile_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES auth.users(id);


--
-- Name: wishlists wishlists_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id);


--
-- Name: wishlists wishlists_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.wishlists
    ADD CONSTRAINT wishlists_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: carts Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete for users based on user_id" ON public.carts FOR DELETE USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: wishlists Enable delete for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable delete for users based on user_id" ON public.wishlists FOR DELETE USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: carts Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.carts FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: wishlists Enable insert for authenticated users only; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for authenticated users only" ON public.wishlists FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: carts Enable insert for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable insert for users based on user_id" ON public.carts FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: carts Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON public.carts FOR SELECT USING (true);


--
-- Name: products Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON public.products FOR SELECT USING (true);


--
-- Name: wishlists Enable read access for all users; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable read access for all users" ON public.wishlists FOR SELECT USING (true);


--
-- Name: users Enable update for users based on email; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update for users based on email" ON public.users FOR UPDATE USING (((( SELECT auth.jwt() AS jwt) ->> 'email'::text) = email)) WITH CHECK (((( SELECT auth.jwt() AS jwt) ->> 'email'::text) = email));


--
-- Name: carts Enable update for users based on user_id; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Enable update for users based on user_id" ON public.carts FOR UPDATE USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: profiles Public profiles are viewable by everyone.; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Public profiles are viewable by everyone." ON public.profiles FOR SELECT USING (true);


--
-- Name: profiles Users can insert their own profile.; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert their own profile." ON public.profiles FOR INSERT WITH CHECK ((( SELECT auth.uid() AS uid) = id));


--
-- Name: profiles Users can update own profile.; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update own profile." ON public.profiles FOR UPDATE USING ((( SELECT auth.uid() AS uid) = id));


--
-- Name: badges; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.badges ENABLE ROW LEVEL SECURITY;

--
-- Name: blog_posts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.blog_posts ENABLE ROW LEVEL SECURITY;

--
-- Name: carts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.carts ENABLE ROW LEVEL SECURITY;

--
-- Name: levels; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.levels ENABLE ROW LEVEL SECURITY;

--
-- Name: message_board_posts; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.message_board_posts ENABLE ROW LEVEL SECURITY;

--
-- Name: products; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.products ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: wishlists update wishlist; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "update wishlist" ON public.wishlists FOR UPDATE USING ((( SELECT auth.uid() AS uid) = user_id));


--
-- Name: wishlists; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.wishlists ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Anyone can update their own avatar.; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Anyone can update their own avatar." ON storage.objects FOR UPDATE USING ((( SELECT auth.uid() AS uid) = owner)) WITH CHECK ((bucket_id = 'avatars'::text));


--
-- Name: objects Anyone can upload an avatar.; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Anyone can upload an avatar." ON storage.objects FOR INSERT WITH CHECK ((bucket_id = 'avatars'::text));


--
-- Name: objects Avatar images are publicly accessible.; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Avatar images are publicly accessible." ON storage.objects FOR SELECT USING ((bucket_id = 'avatars'::text));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: supabase_realtime carts; Type: PUBLICATION TABLE; Schema: public; Owner: -
--

ALTER PUBLICATION supabase_realtime ADD TABLE ONLY public.carts;


--
-- PostgreSQL database dump complete
--

