# GEOX — Gestão Operacional

Aplicação web estática conectada ao Supabase existente. Inclui autenticação, painel, cadastros operacionais, consultas, edição, exclusão autorizada, impressão A4 e gestão de perfis pelo administrador.

## Implantação no GitHub Pages

1. Extraia o ZIP. Envie **os arquivos e pastas de dentro** de `geox-gestao-operacional` para a raiz do repositório `metalsilvaplanejamento-ai/geox-gestao-operacional` (não envie somente o ZIP).
2. No GitHub, acesse **Settings > Pages > Build and deployment**, selecione **Deploy from a branch**, branch `main`, pasta `/(root)` e salve.
3. O endereço esperado, depois de publicado pelo GitHub, é `https://metalsilvaplanejamento-ai.github.io/geox-gestao-operacional/`. A publicação precisa ser conferida no GitHub.
4. No Supabase, projeto `upwapfyuktbwgmdvdmau`, vá a **Authentication > URL Configuration** e configure o Site URL para o endereço publicado; inclua o mesmo endereço em Redirect URLs, se necessário.
5. Crie a primeira conta pelo formulário **Solicitar cadastro**. Caso o Supabase solicite, confirme o e-mail.
6. No **SQL Editor** do Supabase, abra `sql/01_primeiro_administrador.sql`, substitua o e-mail de exemplo pelo e-mail dessa conta e execute. Isso concede o primeiro acesso administrativo.
7. Entre novamente. Na aba **Usuários e permissões**, o administrador poderá ativar novos usuários e escolher seus perfis.

## Supabase

- URL do projeto: `https://upwapfyuktbwgmdvdmau.supabase.co`
- Dashboard: `https://supabase.com/dashboard/project/upwapfyuktbwgmdvdmau`
- Usa somente a chave **publishable** no navegador. **Nunca** inclua a service role key no GitHub.
- As 11 tabelas e políticas RLS foram criadas no projeto Supabase antes da geração deste pacote.
- A geração automática de perfis para novos usuários também foi instalada.

## Funcionalidades incluídas

- Login, solicitação de cadastro e autorização administrativa.
- Dashboard com totais, gráfico de volumes e alertas básicos de OS/estoque.
- CRUD de obras, equipamentos, ordens de serviço, manutenções, remessas, itens de remessa, materiais, movimentações de estoque e caminhões/bota-fora.
- Campos de relacionamento com listas de obras, equipamentos, materiais, remessas e responsáveis.
- Numeração automática no banco para OS, REM e CAM (apresentação `OS-0001`, `REM-001`, `CAM-0001`).
- Impressão A4 por registro com campos para assinaturas.
- Perfis: admin, encarregado, operador, consulta. Acesso aos dados é bloqueado para contas inativas.

## Limitações e cuidados antes do uso real

- **O estoque ainda não é recalculado automaticamente** por lançamentos de movimentação. O saldo exibido é o campo `saldo` do cadastro de materiais. Não use esse saldo para decisões de compra até implementar a lógica transacional e conciliação.
- Os números automáticos podem ter lacunas após operações canceladas, comportamento normal de sequências de banco.
- O aplicativo carrega até 1.000 registros por tabela; para bases maiores será necessário paginação e filtros no servidor.
- Não foram implementados upload de anexos, assinatura eletrônica, checklist automático por equipamento, OS automática por mudança de status, relatório fotográfico ou trilha de auditoria.
- A exclusão de registros é permitida a admin e encarregado conforme políticas RLS; avalie a necessidade de exclusão lógica/auditoria antes de operação empresarial.
- A tela de perfis é destinada ao administrador; a segurança real é aplicada no Supabase, não apenas na interface.
- O cadastro aberto é condicionado à ativação do administrador. Para maior controle, considere desativar inscrições públicas no Supabase e convidar funcionários individualmente.
- As impressões são formulários A4 simples e não equivalem a assinatura digital certificada.
- A aplicação requer internet e não funciona como sistema compartilhado se aberta diretamente como `file://` em navegadores com bloqueio de módulos; use GitHub Pages ou servidor HTTP local.
- Não foi realizado teste de ponta a ponta com um usuário administrador real, nem publicação em GitHub Pages; são passos de implantação pendentes.

## Estrutura

- `index.html` — interface
- `assets/style.css` — identidade visual
- `assets/app.js` — autenticação, consultas e operações Supabase
- `assets/logo.png` — logo GEOX
- `sql/01_primeiro_administrador.sql` — ativação inicial do administrador

## Segurança do projeto

As políticas de autorização usam uma função interna `geox_private.current_role()` que verifica o perfil ativo do usuário autenticado. A função de provisionamento de novos usuários foi instalada no Supabase e não precisa ser publicada no frontend.
