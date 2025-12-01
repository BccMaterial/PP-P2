:- module(diagnostico, [
    falha_inferida/2,
    diagnostico/3,
    causa_raiz/2,
    explicacao/3,
    por_que/3,
    arvore_diagnostico/2
]).

:- use_module(equipamentos).
:- use_module(sintomas).

taxa_propagacao_confianca(0.8).

%falhas possiveis
falha_possivel(Comp, Falha) :-
    sintoma_observado(Comp, Sintoma),
    relacao_sintoma_falha(Sintoma, Falha, _).
falha_possivel(Pai, Falha) :-
    componente(Pai, Filho),
    falha_possivel(Filho, Falha).
causa_indireta(F1, F2) :-
    causa(F1, F2, _).
causa_indireta(F1, F3) :-
    causa(F1, F2, _),
    causa_indireta(F2, F3).
falha_causada(F, F).
falha_causada(Base, Final) :-
    causa_indireta(Base, Final).

falha_inferida(Comp, FalhaFinal) :-
    falha_possivel(Comp, FalhaBase),
    falha_causada(FalhaBase, FalhaFinal).

%diagnostico

diagnostico(Comp, Falha, Conf) :-
    sintoma_observado(Comp, S),
    relacao_sintoma_falha(S, Falha, Conf).

diagnostico(Pai, Falha, NovaConf) :-
    componente(Pai, Filho),
    diagnostico(Filho, Falha, CBase),
    taxa_propagacao_confianca(T),
    NovaConf is CBase * T.
    
%explicações
explicacao(Maquina, Falha, Txt) :-
    falha_inferida(Maquina, Falha),
    coletar_sintomas(Maquina, S),
    format(atom(Txt),
           'Falha (~w) deduzida por sintomas: ~w.',
           [Falha, S]).

por_que(Maquina, Falha, Just) :-
    falha_inferida(Maquina, Falha),
    coletar_sintomas(Maquina, Sintomas),

    findall((S, F, C),
        (member(S, Sintomas), relacao_sintoma_falha(S, F, C)),
        Relacoes),

    findall(C, causa(C, Falha, _), Causas),

    format(atom(J1), 'Sintomas: ~w. ', [Sintomas]),
    format(atom(J2), 'Relações: ~w. ', [Relacoes]),
    format(atom(J3), 'Causas possíveis: ~w.', [Causas]),
    atom_concat(J1, J2, T),
    atom_concat(T, J3, Just).

%arvore de diagnostico
formata(Comp, Falha, Conf, Linha) :-
    P is round(Conf*100),
    format(atom(Linha), '- ~w: ~w (~w%)', [Comp, Falha, P]).

arvore_diagnostico(Maq, Saida) :-

    findall(C, (Maq=C ; subcomponente(Maq,C)), Lista),

    findall(
        L,
        ( member(Comp, Lista),
          diagnostico(Comp, F, Conf),
          formata(Comp, F, Conf, L)
        ),
        Linhas
    ),

    atomic_list_concat([Maq,'\n--- DIAGNÓSTICOS ---'|Linhas], '\n', Saida).
