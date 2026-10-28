-- Execute no SQL Editor do projeto Supabase APÓS cadastrar a primeira conta pelo site.
-- SUBSTITUA o e-mail abaixo pelo e-mail exato do responsável autorizado.
-- Confirme o endereço antes de executar. NÃO rode com o exemplo intacto.
update public.profiles
set role = 'admin', active = true
where id = (select id from auth.users where email = 'SUBSTITUIR_PELO_EMAIL@EMPRESA.COM');
-- Confirme o resultado:
select p.id, u.email, p.full_name, p.role, p.active
from public.profiles p join auth.users u on u.id=p.id
where u.email='SUBSTITUIR_PELO_EMAIL@EMPRESA.COM';
