# Escopo GEOX REV06

## Menu principal
- Dashboard geral (consolidação dos setores)
- Manutenção (expansível): dashboard, gestão de manutenção, equipamentos, OS, preventivas, corretivas, checklist, histórico
- Logística (expansível): dashboard, gestão de caminhões, roteiros, limpeza, abastecimento, remessas, bota-fora
- Almoxarifado (expansível): dashboard, central, por obra, inventário, entradas, saídas, transferências e relatórios
- Configurações e usuários em área administrativa, sem quarto setor operacional

## Gestão de caminhões
Cadastro por placa, marca/modelo, ano, patrimônio, motorista, status, obra e KM atual.
Histórico unificado por caminhão: manutenção, roteiro, limpeza e abastecimento.
Indicadores: KM rodado, consumo km/L (apenas com dados suficientes), gastos, paradas, roteiros e frequência de limpeza.

## Almoxarifados
Saldos separados por local; transferência atômica e sem saldo negativo; vínculo de usuários com almoxarifados; RLS no banco.

## Impressão
Todos os registros com impressão A4, logo existente da GEOX, dados cadastrais oficiais (confirmar CNPJ/endereço/contatos), obra, número, data e assinaturas.

## Observação
O banco REV05 possui materiais.saldo global. A migração exige reconciliação desse saldo com os almoxarifados, sem duplicar estoque.
