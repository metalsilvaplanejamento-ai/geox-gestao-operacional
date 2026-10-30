-- REV06: estrutura de almoxarifados por obra. Executar após revisar permissões existentes.
create table if not exists public.almoxarifados (
 id uuid primary key default gen_random_uuid(),
 nome text not null,
 obra_id uuid references public.obras(id),
 ativo boolean not null default true,
 created_at timestamptz not null default now()
);
create unique index if not exists almoxarifado_unico_por_obra on public.almoxarifados(obra_id) where obra_id is not null;
create table if not exists public.acessos_almoxarifado (
 user_id uuid not null references public.profiles(id) on delete cascade,
 almoxarifado_id uuid not null references public.almoxarifados(id) on delete cascade,
 pode_movimentar boolean not null default false,
 primary key(user_id,almoxarifado_id)
);
create table if not exists public.estoque_almoxarifado (
 almoxarifado_id uuid not null references public.almoxarifados(id),
 material_id uuid not null references public.materiais(id),
 saldo numeric not null default 0 check(saldo>=0),
 estoque_minimo numeric not null default 0,
 primary key(almoxarifado_id,material_id)
);
create table if not exists public.movimentacoes_almoxarifado (
 id uuid primary key default gen_random_uuid(),
 material_id uuid not null references public.materiais(id),
 origem_id uuid references public.almoxarifados(id),
 destino_id uuid references public.almoxarifados(id),
 tipo text not null check(tipo in ('entrada','saida','transferencia')),
 quantidade numeric not null check(quantidade>0),
 observacoes text,
 created_by uuid not null default auth.uid() references public.profiles(id),
 created_at timestamptz not null default now(),
 check ((tipo='entrada' and destino_id is not null) or (tipo='saida' and origem_id is not null) or (tipo='transferencia' and origem_id is not null and destino_id is not null and origem_id<>destino_id))
);
insert into public.almoxarifados(nome,obra_id)
select 'Almoxarifado - '||o.nome,o.id from public.obras o
where not exists(select 1 from public.almoxarifados a where a.obra_id=o.id);
insert into public.almoxarifados(nome)
select 'Galpão Central GEOX' where not exists(select 1 from public.almoxarifados where obra_id is null);
alter table public.almoxarifados enable row level security;
alter table public.acessos_almoxarifado enable row level security;
alter table public.estoque_almoxarifado enable row level security;
alter table public.movimentacoes_almoxarifado enable row level security;
-- Políticas de leitura restritas. A movimentação transacional requer função RPC
-- auditada e políticas apropriadas; não liberar INSERT/UPDATE direto no cliente.
create policy "acesso almoxarifados" on public.almoxarifados for select to authenticated
using (exists(select 1 from public.acessos_almoxarifado a where a.almoxarifado_id=id and a.user_id=(select auth.uid())));
create policy "meus acessos" on public.acessos_almoxarifado for select to authenticated
using (user_id=(select auth.uid()));
create policy "saldo almoxarifado autorizado" on public.estoque_almoxarifado for select to authenticated
using (exists(select 1 from public.acessos_almoxarifado a where a.almoxarifado_id=estoque_almoxarifado.almoxarifado_id and a.user_id=(select auth.uid())));
create policy "historico almoxarifado autorizado" on public.movimentacoes_almoxarifado for select to authenticated
using (exists(select 1 from public.acessos_almoxarifado a where a.user_id=(select auth.uid()) and a.almoxarifado_id in (origem_id,destino_id)));
