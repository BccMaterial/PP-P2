# PP-P2

Prova 2 de paradigmas em prolog

## Documentação do Sistema:

Módulos:
- Equipamentos
- Sintomas
- Diagnostico
- Acoes
- Principal

### Equipamentos

Possui a definição dos casos de **componentes** e **subcomponentes**, onde:
1. **Caso:** É o caso base, onde temos a relação direta entre componente e
subcomponente;
2. **Caso:** É o caso de relação indireta, onde temos uma recursão

**Definições:**
- subcomponente(X,Y)
- subcomponente(X,Y)

### Sintomas

Possui a definição dos sintomas, dado um componente.

**Definições:**
- sintoma(Componente, Sintoma)
- coletar_sintomas(Maquina, Sintomas)

### Diagnostico

Definição e lógicas de diagnóstico, onde, dado a máquina, e a falha, definimos o caso
e retornamos o diagnóstico com uma porcentagem de confiabilidade.

**Definições**:
- taxa_propagacao_confianca(0.8).
- falha_possivel(Comp, Falha)
- falha_possivel(Pai, Falha)
- causa_indireta(F1, F2)
- causa_indireta(F1, F3)
- falha_causada(F, F)
- falha_causada(Base, Final)
- falha_inferida(Comp, FalhaFinal)
- diagnostico(Comp, Falha Conf)
- diagnostico(Pai, Falha, NovaConf)
- explicacao(Maquina, Falha, Txt)
- por_que(Maquina, Falha, Just)
- causa_raiz(Maquina, FalhaRaiz)
- formata(Comp, Falha, Conf, Linha)
- arvore_diagnostico(Maq, Saida)

### Acoes

São as definições do que deve ser feito caso haja a falha, retornando:
- Prioridade
- Ação
Com isso, conseguimos enviar o que deve ser feito a partir de um problema dado.

**Definições:**
- mapear_severidade_para_prioridade(alta, urgente)
- mapear_severidade_para_prioridade(media, moderada)
- mapear_severidade_para_prioridade(baixa, baixa)
- recomendar_acao(Maquina, Falha, Prioridade, Acao)

## Como executar o sistema

Para executar o sistema, você deve possuir o pacote swi-prolog em seu sistema,
onde é possível executar `swipl`.

Para executar o código que gerará o `saída.txt`:
```bash
swipl -s principal.pl -t entrada.txt
```

### Principal

É a nossa main, onde importamos os módulos, carregamos o arquivo `entrada.txt`,
escrevemos o relatório no `saída.txt`.

**Definições:**
- main
- carregar_base
- executar_diagnostico

## Exemplos de consultas e exemplos de resultados esperados

% 1) Falhas possíveis em cada componente
?- falha_possivel(bomba_oleo, F).
F = baixa_pressao_oleo.

?- falha_possivel(sensor_temperatura, F).
F = sensor_inoperante.

% 2) Falhas possíveis na máquina (propagação hierárquica)
?- falha_possivel(maquina_a, F).
F = baixa_pressao_oleo ;
F = superaquecimento ;
F = sensor_inoperante ;
F = vibracao_excessiva.

% 3) Falhas causais encadeadas
?- causa_indireta(baixa_pressao_oleo, X).
X = superaquecimento.

?- causa_indireta(curto_circuito, X).
X = parada_inesperada.

% 4) Falhas raiz da máquina
?- causa_raiz(maquina_a, F).
F = baixa_pressao_oleo ;
F = sensor_inoperante ;
F = vibracao_excessiva.

% 5) Diagnóstico com confiança
?- diagnostico(bomba_oleo, F, C).
F = baixa_pressao_oleo,
C = 0.9.

?- diagnostico(sensor_temperatura, F, C).
F = sensor_inoperante,
C = 0.8.

% 6) Diagnóstico propagado (confiança reduzida)
?- diagnostico(motor_principal, baixa_pressao_oleo, C).
C = 0.72.  % 0.9 * 0.8 = 0.72

% 7) Explicação da inferência
?- explicacao(maquina_a, superaquecimento, J).
J = 'Falha (superaquecimento) deduzida por sintomas: [leitura_inconstante, fluxo_reduzido, ruido]'.

% 8) Explicação detalhada
?- por_que(maquina_a, baixa_pressao_oleo, J).
J = 'Falha (baixa_pressao_oleo) inferida por sintomas: [leitura_inconstante, fluxo_reduzido, ruido] e relações conhecidas: [(fluxo_reduzido, baixa_pressao_oleo, 0.9), ...]'.

% 9) Ações corretivas
?- acao_corretiva(superaquecimento, A).
A = 'Verificar sistema de refrigeração e nível de óleo'.

?- acao_corretiva(baixa_pressao_oleo, A).
A = 'Verificar bomba de óleo e nível do reservatório'.

% 10) Recomendações com prioridade
?- recomendar_acao(maquina_a, superaquecimento, P, A).
P = urgente,
A = 'Verificar sistema de refrigeração e nível de óleo'.

?- recomendar_acao(maquina_a, sensor_inoperante, P, A).
P = baixa,
A = 'Calibrar ou substituir sensor'.

% 11) Listar todos os subcomponentes de uma máquina
?- subcomponente(maquina_a, S).
S = motor_principal ;
S = sistema_eletrico ;
S = bomba_oleo ;
S = eixo_rotacao ;
S = sensor_temperatura ;
S = circuito_controle.

% 12) Verificar hierarquia transitiva
?- subcomponente(maquina_a, bomba_oleo).
true.

?- subcomponente(maquina_a, sensor_temperatura).
true.

% 13) Listar todas as falhas de alta severidade
?- falha(F, _, alta).
F = superaquecimento ;
F = curto_circuito ;
F = parada_inesperada.

% 14) Listar todas as falhas mecânicas
?- falha(F, mecanica, _).
F = superaquecimento ;
F = baixa_pressao_oleo ;
F = vibracao_excessiva ;
F = eixo_desalinhado.

% 15) Verificar cadeia causal completa
?- causa_indireta(baixa_pressao_oleo, F).
F = superaquecimento.

% 16) Listar todos os sintomas observados
?- sintoma(C, S).
C = sensor_temperatura, S = leitura_inconstante ;
C = eixo_rotacao, S = ruido ;
C = bomba_oleo, S = fluxo_reduzido.

%?- arvore_diagnostico(maquina_a, A).
% A = 'maquina_a
%      ├── motor_principal
%      │    └── bomba_oleo → baixa_pressao_oleo (90%)
%      │         └── superaquecimento (70%)
%      └── sistema_eletrico
%           └── sensor_temperatura → sensor_inoperante (80%)'

