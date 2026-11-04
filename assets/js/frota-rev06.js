// Utilitários de frota para futura integração com Supabase; sem escrita em produção.
export function distanciaKm(kmInicial,kmFinal){const a=Number(kmInicial),b=Number(kmFinal);return kmInicial==null||kmFinal==null||!Number.isFinite(a)||!Number.isFinite(b)||b<a?null:b-a;}
export function duracaoHoras(saida,retorno){if(!saida||!retorno)return null;const h=(new Date(retorno)-new Date(saida))/36e5;return Number.isFinite(h)&&h>=0?h:null;}
export function consumoKmPorLitro(km,litros){return km!=null&&Number(litros)>0?Number(km)/Number(litros):null;}
export const tiposHistorico=['manutencao','roteiro','limpeza','abastecimento'];
