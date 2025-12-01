% Fator de redução de confiança
taxa_propagacao_confianca(0.8).

% Diagnóstico com o nível de Confianca. (Probabilidade Agregada)
diagnostico(Componente, Falha, Confianca) :-
    sintoma_observado(Componente, Sintoma),
    relacao_sintoma_falha(Sintoma, Falha, Confianca).

diagnostico(Pai, Falha, NovaConfianca) :-
    componente(Pai, Filho),
    diagnostico(Filho, Falha, ConfiancaBase),
    taxa_propagacao_confianca(Taxa),
    NovaConfianca is ConfiancaBase * Taxa.


% Coleta todos os sintomas observados na maquina:
coletar_sintomas(Maquina, Sintomas) :-
    findall(
        S,
        ( subcomponente(Maquina, C), sintoma_observado(C, S) ),
        ListaSintomas
    ),
    sort(ListaSintomas, Sintomas). % Remove repetidos


% Explicação Simples:
explicacao(Maquina, Falha, Justificativa) :-
    falha_inferida(Maquina, Falha),
    coletar_sintomas(Maquina, Sintomas),
    format(atom(Justificativa),
           'Falha (~w) deduzida por sintomas: ~w.',
           [Falha, Sintomas]).


% Explicação Detalhada. 
por_que(Maquina, Falha, Justificativa) :-
    falha_inferida(Maquina, Falha),
    coletar_sintomas(Maquina, Sintomas),
   
    findall(
        (Sintoma, FalhaRel, Confianca),
        ( member(Sintoma, Sintomas), relacao_sintoma_falha(Sintoma, FalhaRel, Confianca) ),
        RelacoesDiretas
    ),

    findall(
        Causa,
        causa(Causa, Falha, _),
        CausasConhecidas
    ),

    format(atom(J1), 'Falha (~w) inferida. Sintomas observados: ~w. ', [Falha, Sintomas]),
    format(atom(J2), 'Relações conhecidas (sintoma -> falha): ~w. ', [RelacoesDiretas]),
    format(atom(J3), 'Causas que podem levar a esta falha: ~w.', [CausasConhecidas]),

    atom_concat(J1, J2, Temp),
    atom_concat(Temp, J3, Justificativa).


% Extensão: Árvore de Diagnóstico
% Auxiliar para formatar cada diagnóstico:
formata_diagnostico(Componente, Falha, Confianca, Linha) :-
    ConfiancaFormatada is round(Confianca * 100), % Converte para %
    format(atom(Linha), '~N- Componente: ~w -> Falha: ~w (~w%)', [Componente, Falha, ConfiancaFormatada]).

% arvore_diagnostico(Maquina, Arvore)
arvore_diagnostico(Maquina, Arvore) :-
    % 1. Coleta todos os componentes (o próprio Maquina e seus subcomponentes)
    findall(
        C,
        ( Maquina = C ; subcomponente(Maquina, C) ),
        Componentes
    ),
   
    % Coleta todos os diagnósticos com confiança para cada componente
    findall(
        LinhaFormatada,
        ( member(Comp, Componentes),
          diagnostico(Comp, Falha, Confianca),
          formata_diagnostico(Comp, Falha, Confianca, LinhaFormatada)
        ),
        LinhasDiagnostico
    ),
   
    % Combina as linhas em um único átomo de saída.
    atomic_list_concat([Maquina, '\n', '    DETALHES    ' | LinhasDiagnostico], '\n', Arvore).
