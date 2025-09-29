-- WARNING: This schema is for context only and is not meant to be run.
-- Table order and constraints may not be valid for execution.

CREATE TABLE public.daily_game_aggregates (
    id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    game_id uuid,
    day timestamp with time zone NOT NULL,
    plays_count bigint NOT NULL DEFAULT 0,
    jackpots_count bigint NOT NULL DEFAULT 0,
    bonuses_count bigint NOT NULL DEFAULT 0,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT daily_game_aggregates_pkey PRIMARY KEY (id)
);

CREATE TABLE public.game_asset_audit (
    id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    game_id bigint NOT NULL,
    action text NOT NULL,
    path text NOT NULL,
    bytes integer,
    content_type text,
    admin_user_id uuid,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT game_asset_audit_pkey PRIMARY KEY (id),
    CONSTRAINT game_asset_audit_game_id_fkey FOREIGN KEY (game_id) REFERENCES public.games(id)
);

CREATE TABLE public.game_events (
    id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    user_id uuid NOT NULL,
    game_id uuid,
    event_type text NOT NULL CHECK (event_type = ANY (ARRAY['play_start'::text, 'play_end'::text, 'jackpot'::text, 'bonus_trigger'::text])),
    metadata jsonb,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT game_events_pkey PRIMARY KEY (id),
    CONSTRAINT game_events_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.games (
    id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    slug text NOT NULL UNIQUE,
    name text NOT NULL,
    provider text NOT NULL,
    rtp numeric NOT NULL DEFAULT 0.96 CHECK (rtp IS NULL OR rtp >= 0::numeric AND rtp <= 100::numeric),
    thumbnail text,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    updated_at timestamp with time zone NOT NULL DEFAULT now(),
    volatility text CHECK (volatility = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'extreme'::text])),
    features ARRAY,
    provider_id uuid,
    user_id uuid,
    thumbnail_1x1 text,
    thumbnail_9x16 text,
    image_url text NOT NULL,
    description text,
    CONSTRAINT games_pkey PRIMARY KEY (id),
    CONSTRAINT games_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    username text UNIQUE,
    display_name text,
    avatar_url text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT profiles_pkey PRIMARY KEY (id),
    CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id)
);

CREATE TABLE public.scores (
    id bigint GENERATED ALWAYS AS IDENTITY NOT NULL,
    game_id bigint NOT NULL,
    user_id uuid NOT NULL,
    score bigint NOT NULL CHECK (score >= 0),
    achieved_at timestamp with time zone NOT NULL DEFAULT now(),
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    is_public boolean NOT NULL DEFAULT false,
    tenant_id uuid NOT NULL,
    CONSTRAINT scores_pkey PRIMARY KEY (id),
    CONSTRAINT scores_tenant_fk FOREIGN KEY (tenant_id) REFERENCES public.tenants(id)
);

CREATE TABLE public.tenants (
    id uuid NOT NULL DEFAULT extensions.gen_random_uuid(),
    name text NOT NULL UNIQUE,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT tenants_pkey PRIMARY KEY (id)
);

CREATE TABLE public.transactions (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    wallet_id uuid NOT NULL,
    amount numeric NOT NULL,
    type text NOT NULL CHECK (type = ANY (ARRAY['deposit'::text, 'withdrawal'::text, 'wager'::text, 'win'::text])),
    status text NOT NULL DEFAULT 'pending'::text CHECK (status = ANY (ARRAY['pending'::text, 'completed'::text, 'failed'::text])),
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT transactions_pkey PRIMARY KEY (id),
    CONSTRAINT transactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id),
    CONSTRAINT transactions_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.wallets(id)
);

CREATE TABLE public.user_tenants (
    user_id uuid NOT NULL,
    tenant_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL DEFAULT now(),
    CONSTRAINT user_tenants_pkey PRIMARY KEY (user_id),
    CONSTRAINT user_tenants_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
    CONSTRAINT user_tenants_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id)
);

CREATE TABLE public.wallets (
    id uuid NOT NULL DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL,
    balance numeric NOT NULL DEFAULT 0.00 CHECK (balance >= 0::numeric),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT wallets_pkey PRIMARY KEY (id),
    CONSTRAINT wallets_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles(id)
);