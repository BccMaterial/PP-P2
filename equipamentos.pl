% Predicado de Atalho:
sintoma(Componente, Sintoma) :-
    sintoma_observado(Componente, Sintoma).

% subcomponente(X, Y): Verifica se Y está dentro de X(direto ou indireto).
subcomponente(X, Y) :-
    componente(X, Y). % Caso Base: Relação direta

subcomponente(X, Y) :-
    componente(X, Z),
    subcomponente(Z, Y). % Caso Recursivo: Relação indireta