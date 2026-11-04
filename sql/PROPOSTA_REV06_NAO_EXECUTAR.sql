-- RASCUNHO DE ESQUEMA - NÃO EXECUTAR NO BANCO DE PRODUÇÃO.
-- Precisa ser revisado em homologação e acompanhado de RLS, grants, índices,
-- migração/reconciliação dos saldos atuais e transações seguras de transferência.

-- Cadastro de caminhões (modelo sugerido)
create table if not exists public.frota_veiculos (
 id uuid primary key default gen_random_uuid(),
 placa text not null unique,
 marca text, modelo text, ano integer,
 patrimonio text, motorista_padrao text,
 obra_id uuid references public.obras(id),
 km_atual numeric check(km_atual is null or km_atual >= 0),
 status text not null default 'operacional',
 created_at timestamptz not null default now()
);
alter table public.frota_veiculos enable row level security;

create table if not exists public.frota_abastecimentos (
 id uuid primary key default gen_random_uuid(),
 veiculo_id uuid not null references public.frota_veiculos(id),
 data_abastecimento timestamptz not null default now(),
 posto text, combustivel text, litros numeric not null check(litros>0),
 valor_total numeric check(valor_total is null or valor_total>=0),
 km_odometro numeric check(km_odometro is null or km_odometro>=0),
 observacoes text, created_by uuid references public.profiles(id)
);
alter table public.frota_abastecimentos enable row level security;

create table if not exists public.frota_limpezas (
 id uuid primary key default gen_random_uuid(),
 veiculo_id uuid not null references public.frota_veiculos(id),
 data_limpeza timestamptz not null default now(),
 tipo text, responsavel text, local text,
 custo numeric check(custo is null or custo>=0),
 observacoes text, created_by uuid references public.profiles(id)
);
alter table public.frota_limpezas enable row level security;

create table if not exists public.almoxarifados (
 id uuid primary key default gen_random_uuid(),
 nome text not null, obra_id uuid references public.obras(id),
 ativo boolean not null default true,
 created_at timestamptz not null default now()
);
alter table public.almoxarifados enable row level security;

create table if not exists public.almoxarifado_usuarios (
 almoxarifado_id uuid not null references public.almoxarifados(id),
 usuario_id uuid not null references public.profiles(id),
 pode_movimentar boolean not null default false,
 primary key(almoxarifado_id,usuario_id)
);
alter table public.almoxarifado_usuarios enable row level security;

create table if not exists public.almoxarifado_saldos (
 almoxarifado_id uuid not null references public.almoxarifados(id),
 material_id uuid not null references public.materiais(id),
 saldo numeric not null default 0 check(saldo>=0),
 primary key(almoxarifado_id,material_id)
);
alter table public.almoxarifado_saldos enable row level security;

-- IMPORTANTE: tabelas sem policies/grants não estarão utilizáveis pelo frontend.
-- Não habilitar policies amplas para todos os usuários. Criar políticas específicas
-- e função de transferência transacional após definição do modelo de autorização.
