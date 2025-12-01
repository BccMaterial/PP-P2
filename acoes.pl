:- module(acoes, [
    recomendar_acao/4
]).

% Mapeamento da severidade para a prioridade
mapear_severidade_para_prioridade(alta, urgente).
mapear_severidade_para_prioridade(media, moderada).
mapear_severidade_para_prioridade(baixa, baixa).

% Sugere a acao e define a prioridade(Classificação por Severidade)
recomendar_acao(Maquina, Falha, Prioridade, Acao) :-
    falha_inferida(Maquina, Falha),
    falha(Falha, _, Severidade),
    acao_corretiva(Falha, Acao),
    mapear_severidade_para_prioridade(Severidade, Prioridade).
