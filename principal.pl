:- initialization(main).

:- use_module(equipamentos).
:- use_module(sintomas).
:- use_module(diagnostico).
:- use_module(acoes).

main :-
    carregar_base,
    executar_diagnostico,
    halt.

carregar_base :-
    writeln('Carregando base...'),
    consult('entrada.txt').

executar_diagnostico :-
    Maquina = maquina_a,
    
    arvore_diagnostico(Maquina, Arvore),
    open('saida.txt', write, S),
    write(S, '=== DIAGNÓSTICO DA MÁQUINA ===\n'),
    write(S, Arvore), nl(S),

    forall(
        recomendar_acao(Maquina, Falha, Pri, Acao),
        (
            format(S, '\nFalha: ~w\nPrioridade: ~w\nAção: ~w\n',
                   [Falha, Pri, Acao])
        )
    ),

    close(S).
