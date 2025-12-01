% Módulo para a inicialização e base de fatos.

% Carregamento do arquivo de regras:
:- consult('equipamentos.pl').
:- consult('diagnostico.pl').
:- consult('sintomas.pl'). % Renomeado para incluir a nova lógica
:- consult('acoes.pl').

% Base de Fatos:
% Hierarquia de componentes: componente(Pai, Filho):
componente(maquina_a, motor_principal).
componente(maquina_a, sistema_eletrico).
componente(sistema_eletrico, sensor_temperatura).
componente(sistema_eletrico, circuito_controle).
componente(motor_principal, bomba_oleo).
componente(motor_principal, eixo_rotacao).
componente(bomba_oleo, valvula_retencao).
componente(motor_principal, correia_transmissao).

% Falhas possíveis: falha(Falha, Tipo, Severidade)
falha(superaquecimento, mecanica, alta).
falha(baixa_pressao_oleo, mecanica, media).
falha(curto_circuito, eletrica, alta).
falha(sensor_inoperante, eletrica, baixa).
falha(vibracao_excessiva, mecanica, media).
falha(parada_inesperada, geral, alta).
falha(eixo_desalinhado, mecanica, media).
falha(valvula_travada, mecanica, media).
falha(correia_frouxa, mecanica, baixa).
falha(mau_contato, eletrica, baixa).

% Sintomas observados(fato real): sintoma_observado(Componente, Sintoma)
sintoma_observado(sensor_temperatura, leitura_inconstante).
sintoma_observado(eixo_rotacao, ruido).
sintoma_observado(bomba_oleo, fluxo_reduzido).
sintoma_observado(valvula_retencao, vazamento).
sintoma_observado(circuito_controle, led_vermelho_aceso).

% Relações de causa e efeito: causa(FalhaCausa, FalhaConsequencia, Confianca)
causa(baixa_pressao_oleo, superaquecimento, 0.7).
causa(curto_circuito, parada_inesperada, 0.9).
causa(vibracao_excessiva, eixo_desalinhado, 0.6).
causa(valvula_travada, baixa_pressao_oleo, 0.85).

% Associação de sintomas a falhas: relacao_sintoma_falha(Sintoma, Falha, Confianca)
relacao_sintoma_falha(leitura_inconstante, sensor_inoperante, 0.8).
relacao_sintoma_falha(ruido, vibracao_excessiva, 0.7).
relacao_sintoma_falha(fluxo_reduzido, baixa_pressao_oleo, 0.9).
relacao_sintoma_falha(vazamento, valvula_travada, 0.95).
relacao_sintoma_falha(led_vermelho_aceso, curto_circuito, 0.75).