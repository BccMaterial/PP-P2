:- module(sintomas, [
    sintoma/2,
    coletar_sintomas/2
]).

:- use_module(equipamentos).  % usa subcomponente/2

sintoma(Componente, Sintoma) :-
    sintoma_observado(Componente, Sintoma).

coletar_sintomas(Maquina, Sintomas) :-
    findall(
        S,
        ( subcomponente(Maquina, C),
          sintoma_observado(C, S)
        ),
        Lista
    ),
    sort(Lista, Sintomas).
