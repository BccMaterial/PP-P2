% Base de fatos
acao_corretiva(superaquecimento, 'Verificar sistema de refrigeração e nível de óleo.').
acao_corretiva(baixa_pressao_oleo, 'Verificar bomba de óleo e nível do reservatório.').
acao_corretiva(curto_circuito, 'Isolar o circuito de controle e inspecionar fiação.').
acao_corretiva(sensor_inoperante, 'Calibrar ou substituir sensor.').
acao_corretiva(vibracao_excessiva, 'Verificar balanceamento e fixação de componentes.').
acao_corretiva(parada_inesperada, 'Revisão geral do sistema elétrico e mecânico - URGENTE.').
acao_corretiva(eixo_desalinhado, 'Realinhar eixo de rotação.').

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