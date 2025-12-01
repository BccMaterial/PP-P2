%falha_possivel(Componente, Falha): Encontra a falha base(sintoma ou hierarquia).

% Caso 1: Falha baseada em sintoma
falha_possivel(Componente, Falha) :-
    sintoma_observado(Componente, Sintoma),
    relacao_sintoma_falha(Sintoma, Falha, _).

% Caso 2: Falha propagada hierarquicamente
falha_possivel(Pai, Falha) :-
    componente(Pai, Filho),
    falha_possivel(Filho, Falha).


% Auxiliar: falha_causada(FalhaBase, FalhaFinal)
falha_causada(FalhaBase, Falha) :-
    Falha = FalhaBase.

falha_causada(FalhaBase, Falha) :-
    causa_indireta(FalhaBase, Falha).


% Princiapl predicado de consulta: combina hierarquia e causalidade
falha_inferida(Componente, FalhaFinal) :-
    falha_possivel(Componente, FalhaBase),
    falha_causada(FalhaBase, FalhaFinal).


% causa_indireta(F1, F2): Rastreia a cadeia de causas(fecho transitivo).
causa_indireta(F1, F2) :-
    causa(F1, F2, _). % Causa direta

causa_indireta(F1, F3) :-
    causa(F1, F2, _),
    causa_indireta(F2, F3). % Causa indireta


% Encontra a FalhaRaiz(falha que não é causada por outra).
causa_raiz(Maquina, FalhaRaiz) :-
    falha_inferida(Maquina, FalhaRaiz),
    \+ causa_indireta(_, FalhaRaiz).