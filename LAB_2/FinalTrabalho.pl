% Declaração do predicado dinâmico
:- dynamic quinta/3.
:- dynamic sensor/3.
:- dynamic produtor/3.
:- dynamic distribuidor/3.
:- dynamic transportadora/5.
:- dynamic ligacao/3.
:- dynamic dono/2.
:- dynamic leitura/4.
:- dynamic consumo/3.
:- dynamic caminho/5.

:- dynamic caminho_impacto/6.

:-dynamic impacto/2.


:- dynamic historico_alteracao/4.   % RF16


% ---------------------------------- RF1 ------------------------
adicionar_quinta(Id, Nome, Local) :-
    \+ quinta(Id, _, _),
    assertz(quinta(Id, Nome, Local)).

% --- Remover uma quinta ---
remover_quinta(Id) :-
    retractall(quinta(Id, _, _)).

% --- Alterar quinta ---
alterar_quinta(Id, NovoNome, NovaLocal) :-
    retractall(quinta(Id, _, _)),
    assertz(quinta(Id, NovoNome, NovaLocal)).






% ----------------------------------- RF 2 ----------------------

% --- Adicionar um sensor ---
adicionar_sensor(IdSensor, Tipo, IdQuinta) :-
    \+ sensor(IdSensor, _, _),
    assertz(sensor(IdSensor, Tipo, IdQuinta)).

% --- Remover um sensor ---
remover_sensor(IdSensor) :-
    retractall(sensor(IdSensor, _, _)).

% --- Alterar um sensor ---
alterar_sensor(IdSensor, NovoTipo, NovaQuinta) :-
    retractall(sensor(IdSensor, _, _)),
    assertz(sensor(IdSensor, NovoTipo, NovaQuinta)).








% -------------------------------- RF 3 ---------------------------
% Produtor
adicionar_produtor(Id, Nome, Zona) :-
    \+ produtor(Id, _, _),
    assertz(produtor(Id, Nome, Zona)).

remover_produtor(Id) :-
    retractall(produtor(Id, _, _)).

alterar_produtor(Id, NovoNome, NovaZona) :-
    retractall(produtor(Id, _, _)),
    assertz(produtor(Id, NovoNome, NovaZona)).




% Distribuidores
adicionar_distribuidor(Id, Nome, Zona) :-
    \+ distribuidor(Id, _, _),
    assertz(distribuidor(Id, Nome, Zona)).

remover_distribuidor(Id) :-
    retractall(distribuidor(Id, _, _)).

alterar_distribuidor(Id, NovoNome, NovaZona) :-
    retractall(distribuidor(Id, _, _)),
    assertz(distribuidor(Id, NovoNome, NovaZona)).





% Trnsportadoras
adicionar_transportadora(Id, Nome, Capacidade, Combustivel, Area) :-
\+ transportadora(Id, _, _, _, _),
    assertz(transportadora(Id, Nome, Capacidade, Combustivel, Area)).

remover_transportadora(Id) :-
    retractall(transportadora(Id, _, _, _, _)).

alterar_transportadora(Id, NovoNome, NovaCap, NovoComb, NovaArea) :-
    retractall(transportadora(Id, _, _, _, _)),
    assertz(transportadora(Id, NovoNome, NovaCap, NovoComb, NovaArea)).





% -------------------------------- RF 4 ---------------------------

% Adicionar uma nova ligação com estrutura dados(...)
adicionar_ligacao(No1, No2, Distancia, Tempo, TipoVia, Custo) :-
    \+ ligacao(No1, No2, _),
    assertz(ligacao(No1, No2, dados(Distancia, Tempo, TipoVia, Custo))).

% Remover ligação entre dois nós
remover_ligacao(No1, No2) :-
    retractall(ligacao(No1, No2, _)).

% Alterar uma ligação existente com novos dados
alterar_ligacao(No1, No2, NovaDist, NovoTempo, NovoTipo, NovoCusto) :-
    retractall(ligacao(No1, No2, _)),
    assertz(ligacao(No1, No2, dados(NovaDist, NovoTempo, NovoTipo, NovoCusto))).







% -------------------------------- RF 5 --------------------------------

% adicionar_leitura(+IdSensor, +Timestamp, +Tipo, +Valor)
%
% Input:
%   IdSensor  – ID do sensor que fez a leitura
%   Timestamp – Momento da leitura (formato ISO: 'YYYY-MM-DDTHH:MM')
%   Tipo      – Tipo da leitura (ex: temperatura, humidade)
%   Valor     – Valor da leitura (ex: 34.5)
%
% Output: nenhum
%
% Funcionamento:
%   Adiciona uma nova leitura do sensor à base de conhecimento.
% ------------------------------------------------------------------
adicionar_leitura(IdSensor, Timestamp, Tipo, Valor) :-
    assertz(leitura(IdSensor, Timestamp, Tipo, Valor)).

% ------------------------------------------------------------------
% atualizar_leitura(+IdSensor, +Timestamp, +Tipo, +NovoValor)
%
% Input:
%   IdSensor    – ID do sensor
%   Timestamp   – Momento da leitura a ser atualizada
%   Tipo        – Tipo da leitura (temperatura, humidade, etc.)
%   NovoValor   – Novo valor da leitura
%
% Output: nenhum
%
% Funcionamento:
%   Remove qualquer leitura anterior do mesmo sensor no mesmo timestamp e tipo,
%   e insere o novo valor atualizado.
% ------------------------------------------------------------------
atualizar_leitura(IdSensor, Timestamp, Tipo, NovoValor) :-
    retractall(leitura(IdSensor, Timestamp, Tipo, _)),
    assertz(leitura(IdSensor, Timestamp, Tipo, NovoValor)).


% ------------------------------------------------------------------
% adicionar_consumo(+IdQuinta, +Cultura, +Litros)
%
% Input:
%   IdQuinta – ID da quinta associada ao consumo
%   Cultura  – Tipo de cultura (ex: milho, tomate)
%   Litros   – Quantidade de água consumida
%
% Output: nenhum
%
% Funcionamento:
%   Regista um novo consumo de água na base de conhecimento.
% ------------------------------------------------------------------
adicionar_consumo(IdQuinta, Cultura, Litros) :-
    assertz(consumo(IdQuinta, Cultura, Litros)).

% ------------------------------------------------------------------
% atualizar_consumo(+IdQuinta, +Cultura, +NovoLitros)
%
% Input:
%   IdQuinta    – ID da quinta
%   Cultura     – Cultura cujos dados de consumo vão ser atualizados
%   NovoLitros  – Novo valor de litros consumidos
%
% Output: nenhum
%
% Funcionamento:
%   Substitui o valor anterior de consumo dessa cultura na quinta
%   pelo novo valor fornecido.
% ------------------------------------------------------------------
atualizar_consumo(IdQuinta, Cultura, NovoLitros) :-
    retractall(consumo(IdQuinta, Cultura, _)),
    assertz(consumo(IdQuinta, Cultura, NovoLitros)).









% -------------------------------- RF 6 ---------------------------
% listar_sensores_quinta(+IdQuinta, -Lista)
%
% Input:
%   IdQuinta – ID da quinta a consultar
%
% Output:
%   Lista – Lista de tuplos (IdSensor, Tipo, NomeProdutor)
%
% Funcionamento:
%   1. Obtém o ID do produtor que é dono da quinta (relacionado via dono/2).
%   2. Obtém o nome do produtor através do predicado produtor/3.
%   3. Procura todos os sensores associados à quinta com sensor/3.
%   4. Para cada sensor, junta o ID do sensor, o seu tipo e o nome do produtor.
%   5. Devolve a lista com essa informação.
%
% Exemplo de saída:
%   Lista = [(s1, temperatura, 'João Silva'), (s2, humidade, 'João Silva')].
% ------------------------------------------------------------------

listar_sensores_quinta(IdQuinta, Lista) :-
    dono(IdProdutor, IdQuinta),
    produtor(IdProdutor, NomeProdutor, _),
    findall((IdSensor, Tipo, NomeProdutor),
            sensor(IdSensor, Tipo, IdQuinta),
            Lista).



% -------------------------------- RF 7 ---------------------------
% Receber o nome de uma zona (ex: lisboa)
% Devolver uma lista de transportadoras que cobrem essa zona

% Input:  Zona
% Output: Lista

% Procura (Id, Nome) que satisfazem a condição transportadora(...) e
% verifica se Zona(input) está na lista de Zonas
listar_transportadoras_zona(Zona, Lista) :-
    findall((Id, Nome),
            (transportadora(Id, Nome, _, _, Zonas), member(Zona, Zonas)),
            Lista).



% -------------------------------- RF 8 -------------------------------
% leitura_mais_recente(+IdSensor, -Tipo, -Valor, -TimestampMaisRecente)
%
% Input:
%   IdSensor – Identificador do sensor cujas leituras queremos consultar
%
% Output:
%   Tipo                 – Tipo da leitura mais recente (ex: temperatura, humidade)
%   Valor                – Valor dessa leitura
%   TimestampMaisRecente – Momento (timestamp) da leitura mais recente
%
% Funcionamento:
%   1. Recolhe todas as leituras associadas ao sensor usando findall/3.
%      Cada leitura tem a forma (Timestamp, Tipo, Valor).
%
%   2. Ordena com o sort() a lista de leituras por Timestamp em ordem
%   crescente com sort/2. (assume-se que o formato do timestamp permite
%   ordenação lexicográfica)
%
%   3. Inverte a lista com reverse/2 para colocar a leitura mais recente no início.
%
%   4. Extrai o primeiro elemento da lista invertida e unifica os seus componentes
%      com as variáveis de saída: Timestamp, Tipo e Valor.
% ------------------------------------------------------------------

leitura_mais_recente(IdSensor, Tipo, Valor, TimestampMaisRecente) :-
    findall((Timestamp, Tipo, Valor),
            leitura(IdSensor, Timestamp, Tipo, Valor),
            Leituras),
    sort(Leituras, LeiturasOrdenadas),
    reverse(LeiturasOrdenadas, [(TimestampMaisRecente, Tipo, Valor)|_]).% |_ é para ignorar o resto da lista







% -------------------------------- RF 9 -------------------------------
% consumos_por_quinta(+IdQuinta, -Lista)
%
% Input:  IdQuinta – ID da quinta
% Output: Lista    – Lista de (Cultura, Litros)
%
% Devolve todos os consumos registados para essa quinta.
consumos_por_quinta(IdQuinta, Lista) :-
    findall((Cultura, Litros),
            consumo(IdQuinta, Cultura, Litros),
            Lista).

% ------------------------------------------------------------------
% consumos_por_cultura(+Cultura, -Lista)
%
% Input:  Cultura – Nome da cultura (ex: milho, tomate)
% Output: Lista   – Lista de (IdQuinta, Litros)
%
% Devolve todas as quintas que cultivam essa cultura e respetivos consumos.
% ------------------------------------------------------------------
consumos_por_cultura(Cultura, Lista) :-
    findall((IdQuinta, Litros),
            consumo(IdQuinta, Cultura, Litros),
            Lista).











% -------------------------------- RF10 -------------------------------
% Limites críticos por tipo de sensor
limite(temperatura, 35).
limite(humidade, 30).

% Define as condições para considerar uma leitura fora do limite
valor_fora_do_limite(temperatura, Valor, Limite) :- Valor > Limite.
valor_fora_do_limite(humidade, Valor, Limite) :- Valor < Limite.

% ------------------------------------------------------------------
% recolha_sensores_fora_do_limite(-Lista)
%
% Input:
%   Nenhum. O predicado procura automaticamente em todas as leituras registadas.
%
% Output:
%   Lista – Lista de tuplos (IdSensor, Timestamp, Tipo, Valor),
%           onde cada elemento representa um sensor cuja leitura mais recente
%           ultrapassa o limite definido para o seu tipo.
%
% Funcionamento:
%   1. Recolhe todas as leituras existentes com leitura/4.
%   2. Ordena as leituras por timestamp (usando sort/2).
%   3. Inverte a lista para que a leitura mais recente venha primeiro.
%   4. Filtra a lista, verificando para cada leitura se ultrapassa o limite
%      (definido em limite/2) de acordo com o tipo de sensor.
%   5. Apenas a leitura mais recente de cada sensor/tipo é considerada.
%   6. Devolve a lista com os sensores fora dos valores aceitáveis.
% ------------------------------------------------------------------
recolha_sensores_fora_do_limite(Lista) :-
    findall((IdSensor, Timestamp, Tipo, Valor),
            leitura(IdSensor, Timestamp, Tipo, Valor),
            TodasLeituras),
    sort(TodasLeituras, LeiturasOrdenadas),% ordena e remove duplicados
    reverse(LeiturasOrdenadas, RecentesPrimeiro),
    filtrar_leituras_criticas(RecentesPrimeiro, [], Lista).
% ------------------------------------------------------------------
% filtrar_leituras_criticas(+Leituras, +Acc, -Resultado)
%
% Input:
%   Leituras – Lista de tuplos (IdSensor, Timestamp, Tipo, Valor),
%              já ordenada por timestamp (mais recente primeiro).
%   Acc      – Acumulador interno que começa como lista vazia ([]).
%
% Output:
%   Resultado – Lista final com sensores cuja leitura mais recente
%               ultrapassa o limite definido em limite/2.
%
% Funcionamento:
%   1. Percorre a lista de leituras.
%   2. Para cada leitura:
%      - Verifica se ultrapassa o limite (com valor_fora_do_limite/3).
%      - Garante que esse sensor/tipo ainda não foi adicionado.
%   3. Se estiver fora do limite e ainda não foi adicionado, guarda.
%   4. No final, devolve todas as leituras críticas (sem duplicados).
%
% ------------------------------------------------------------------
% 3 vezes o nome é como se tivesse if, else if, else if
% % caso 1: lista vazia
filtrar_leituras_criticas([], Acc, Acc).
% Caso 2: leitura fora do limite/não adicionada -> adiciona ao Acc
filtrar_leituras_criticas([(Id, Timestamp, Tipo, Value)|Resto], Acc, Resultado) :-
    limite(Tipo, Limite),
    valor_fora_do_limite(Tipo, Value, Limite),
    \+ member((Id, _, Tipo, _), Acc),    % pergunta se () nao esta no Acc
    filtrar_leituras_criticas(Resto, [(Id, Timestamp, Tipo, Value)|Acc], Resultado).
% Caso3: leitura dentro fora do limite/já foi adicionada.-> ignora
filtrar_leituras_criticas([_|Resto], Acc, Resultado) :-
    filtrar_leituras_criticas(Resto, Acc, Resultado).












% -------------------------------- RF11 -------------------------------
% rotas_mais_curtas_quinta_distri(+NoOrigem, +NoDestino, -CaminhosMinimos, -DistanciaMinima)
%
% Input:
%   NoOrigem         – Identificador do nó de origem (ex: q1)
%   NoDestino        – Identificador do nó de destino (ex: d1)
%
% Output:
%   CaminhosMinimos  – Lista de caminhos (listas de nós) com menor distância
%   DistanciaMinima  – Valor da menor distância (soma de distâncias das ligações)
%
% Funcionamento:
%   - Usa setof para obter todos os caminhos possíveis com suas distâncias
%   - Identifica a menor distância encontrada
%   - Filtra apenas os caminhos que têm essa distância mínima
% ------------------------------------------------------------------
rotas_mais_curtas_quinta_distri(NoOrigem, NoDestino, CaminhosMinimos, DistanciaMinima) :-
    setof((Distancia, Caminho),
          caminho(NoOrigem, NoDestino, [NoOrigem], Caminho, Distancia),
          CaminhosOrdenados),
    CaminhosOrdenados = [(DistanciaMinima, _)|_],
    findall(Caminho,
            member((DistanciaMinima, Caminho), CaminhosOrdenados),
            CaminhosMinimos).

% Caso base: já chegou ao destino
caminho(NoDestino, NoDestino, Visitados, CaminhoFinal, 0) :-
    reverse(Visitados, CaminhoFinal).

% Passo recursivo: continua a explorar o grafo
caminho(NoAtual, NoDestino, Visitados, CaminhoFinal, DistanciaTotal) :-
    ligacao(NoAtual, Proximo, dados(Dist, _, _, _)),
    \+ member(Proximo, Visitados),
    caminho(Proximo, NoDestino, [Proximo|Visitados], CaminhoFinal, DistanciaAcumulada),
    DistanciaTotal is Dist + DistanciaAcumulada.















% -------------------------------- RF12 -------------------------------
% rotas_com_menor_impacto_ambiental(+NoOrigem, +NoDestino, +TipoTransporte, -RotasMinimas, -ImpactoTotalMinimo)
%
% Input:
%   NoOrigem             – Identificador do nó de origem (ex: q1)
%   NoDestino            – Identificador do nó de destino (ex: d1)
%   TipoTransporte       – Tipo de transporte (fossil, eletrico, hibrido)
%
% Output:
%   RotasMinimas         – Lista de rotas com menor impacto (cada rota é uma lista de nós)
%   ImpactoTotalMinimo   – Valor do menor impacto ambiental encontrado
%
% Funcionamento:
%   1. Usa setof/3 para obter todas as rotas possíveis com seus impactos.
%   2. Determina o menor impacto total.
%   3. Filtra todas as rotas com esse impacto mínimo.
% ---------------------------------------------------------------------

rotas_com_menor_impacto_ambiental(NoOrigem, NoDestino, TipoTransporte, RotasMinimas, ImpactoTotalMinimo) :-
    impacto(TipoTransporte, ImpactoPorKm),
    setof((ImpactoTotal, Rota),
          calcular_rota_com_impacto(NoOrigem, NoDestino, [NoOrigem], Rota, ImpactoPorKm, ImpactoTotal),
          TodasRotasComImpacto),
    TodasRotasComImpacto = [(ImpactoTotalMinimo, _) | _],
    findall(Rota,
            member((ImpactoTotalMinimo, Rota), TodasRotasComImpacto),
            RotasMinimas).

% Caso base: destino atingido, impacto zero
calcular_rota_com_impacto(NoDestino, NoDestino, Visitados, RotaFinal, _, 0) :-
    reverse(Visitados, RotaFinal).

% Passo recursivo: continuar a explorar caminhos não visitados
calcular_rota_com_impacto(NoAtual, NoDestino, Visitados, RotaFinal, ImpactoPorKm, ImpactoTotal) :-
    ligacao(NoAtual, ProximoNo, dados(Distancia, _, _, _)),
    \+ member(ProximoNo, Visitados),
    calcular_rota_com_impacto(ProximoNo, NoDestino, [ProximoNo|Visitados], RotaFinal, ImpactoPorKm, ImpactoRestante),
    ImpactoAtual is Distancia * ImpactoPorKm,
    ImpactoTotal is ImpactoAtual + ImpactoRestante.











adicionar_impacto :-
    assertz(impacto(eletrico, 0.5)),
    assertz(impacto(fossil, 2.5)),
    assertz(impacto(hibrido, 1.5)).




% ------------------------------ RF13 ---------------------------------
% rota_mais_sustentavel_com_ou_sem_distribuidor_intermedio(+NoOrigem, +NoDestinoFinal, +TipoTransporte, -MelhorRota, -ImpactoMaisBaixo)
%
% Input:
%   NoOrigem         – Identificador do nó de origem (ex: q1)
%   NoDestinoFinal   – Identificador do nó de destino final (ex: d1)
%   TipoTransporte   – Tipo de transporte utilizado (eletrico, hibrido, fossil)
%
% Output:
%   MelhorRota       – Lista de nós do percurso mais sustentável
%   ImpactoMaisBaixo – Valor total do impacto ambiental
% ---------------------------------------------------------------------
rota_mais_sustentavel_com_ou_sem_distribuidor_intermedio(NoOrigem, NoDestinoFinal, TipoTransporte, MelhorRota, ImpactoMaisBaixo) :-
    impacto(TipoTransporte, ImpactoPorKm),

    % Caminho direto entre origem e destino
    caminho_impacto(NoOrigem, NoDestinoFinal, [NoOrigem], CaminhoDireto, ImpactoPorKm, ImpactoDireto),

    % Caminhos com distribuidores intermedios
    findall(
        (ImpactoTotal, CaminhoAlternativo),
        (
            distribuidor(DistribuidorIntermedio, _, _),
            DistribuidorIntermedio \= NoDestinoFinal,

            caminho_impacto(NoOrigem, DistribuidorIntermedio, [NoOrigem], Caminho1, ImpactoPorKm, Impacto1),
            caminho_impacto(DistribuidorIntermedio, NoDestinoFinal, [DistribuidorIntermedio], Caminho2, ImpactoPorKm, Impacto2),

            Caminho2 = [_ | Resto2],
            append(Caminho1, Resto2, CaminhoAlternativo),

            ImpactoTotal is Impacto1 + Impacto2
        ),
        RotasAlternativas
    ),

    % Junta a rota direta com as alternativas, ordenas e escolhe a com menor impacto
    append([(ImpactoDireto, CaminhoDireto)], RotasAlternativas, TodasAsRotas),
    sort(TodasAsRotas, [(ImpactoMaisBaixo, MelhorRota) | _]).


% ------------------------------ Caminho Impacto -------------------------------
% caminho_impacto(+NoAtual, +NoDestino, +Visitados, -RotaFinal, +ImpactoPorKm, -ImpactoTotal)
%
% Calcula uma rota entre dois Nós acumulando o impacto ambiental
% ------------------------------------------------------------------------------
% Caso base: chegou ao destino
caminho_impacto(NoDestino, NoDestino, Visitados, RotaFinal, _, 0) :-
    reverse(Visitados, RotaFinal).

% Caso recursivo: continua a explorar o grafo
caminho_impacto(NoAtual, NoDestino, Visitados, RotaFinal, ImpactoPorKm, ImpactoTotal) :-
    ligacao(NoAtual, ProximoNo, dados(DistanciaKm, _, _, _)),
    \+ member(ProximoNo, Visitados),
    caminho_impacto(ProximoNo, NoDestino, [ProximoNo | Visitados], RotaFinal, ImpactoPorKm, ImpactoRestante),
    ImpactoAtual is DistanciaKm * ImpactoPorKm,
    ImpactoTotal is ImpactoAtual + ImpactoRestante.











% ------------------------------ RF14 ---------------------------------
% Listar a transportadora ideal para uma rota com base em múltiplos critérios
%
% Input:
%   RotaDesejada          – Lista de nós que representam a rota pretendida
%   PesosCriterios        – Pesos atribuídos explicitamente aos critérios:
%                            [PesoCusto, PesoTempo, PesoCapacidade, PesoImpactoAmbiental]
%
% Output:
%   TransportadoraIdeal   – Transportadora ideal representada por:
%                           (IdTransportadora, NomeTransportadora, ValorTotalCalculado)
%
% Funcionamento:
%   1. Identifica todas as transportadoras capazes de realizar a rota.
%   2. Calcula custo ajustado ao combustível, tempo total, inverso da capacidade, impacto ambiental.
%   3. Aplica os pesos aos critérios.
%   4. Escolhe a transportadora com menor valor ponderado.
% ---------------------------------------------------------------------
listar_transportadora_ideal(RotaDesejada, [PesoCusto, PesoTempo, PesoCapacidade, PesoImpactoAmbiental], TransportadoraIdeal) :-
    findall(
        (ValorTotalCalculado, IdTransportadora, NomeTransportadora),
        (
            transportadora(IdTransportadora, NomeTransportadora, CapacidadeTransportadora, CombustivelTransportadora, AreasCobertas),
            transportadora_pode_realizar_rota(RotaDesejada, AreasCobertas),
            calcular_custo_total_ajustado(RotaDesejada, CombustivelTransportadora, CustoTotalAjustado),
            calcular_tempo_total(RotaDesejada, TempoTotal),
            calcular_impacto_total(RotaDesejada, CombustivelTransportadora, ImpactoTotal),
            ValorTotalCalculado is PesoCusto * CustoTotalAjustado +
                                   PesoTempo * TempoTotal +
                                   PesoCapacidade * (1 / CapacidadeTransportadora) +
                                   PesoImpactoAmbiental * ImpactoTotal
        ),
        ListaAvaliacoes
    ),
    sort(ListaAvaliacoes, [(MenorValorTotal, MelhorId, MelhorNome)|_]),
    TransportadoraIdeal = (MelhorId, MelhorNome, MenorValorTotal).



% ------------------------------ Zona do Nó ---------------------------------
% Liga ID do nó à sua zona, seja quinta ou distribuidor
zona_no(No, Zona) :- quinta(No, _, Zona).
zona_no(No, Zona) :- distribuidor(No, _, Zona).



% ------------------------------ Verificação de cobertura -------------------
% Garante que a transportadora cobre todas as zonas da rota
transportadora_pode_realizar_rota([], _).
transportadora_pode_realizar_rota([No|Resto], AreasCobertas) :-
    zona_no(No, Zona),
    member(Zona, AreasCobertas),
    transportadora_pode_realizar_rota(Resto, AreasCobertas).



% ------------------------------ Custo ajustado -----------------------------
multiplicador_custo_combustivel(eletrico, 0.8).
multiplicador_custo_combustivel(hibrido, 1.0).
multiplicador_custo_combustivel(fossil, 1.2).

calcular_custo_total_ajustado([_], _, 0).
calcular_custo_total_ajustado([Origem, Destino|Resto], Combustivel, CustoTotalAjustado) :-
    ligacao(Origem, Destino, dados(_, _, _, CustoLigacao)),
    multiplicador_custo_combustivel(Combustivel, MultiplicadorCusto),
    CustoAtual is CustoLigacao * MultiplicadorCusto,
    calcular_custo_total_ajustado([Destino|Resto], Combustivel, CustoRestante),
    CustoTotalAjustado is CustoAtual + CustoRestante.



% ------------------------------ Tempo total ---------------------------------
calcular_tempo_total([_], 0).
calcular_tempo_total([Origem, Destino|Resto], TempoTotal) :-
    ligacao(Origem, Destino, dados(_, TempoLigacao, _, _)),
    calcular_tempo_total([Destino|Resto], TempoRestante),
    TempoTotal is TempoLigacao + TempoRestante.



% ------------------------------ Impacto total -------------------------------
calcular_impacto_total(Rota, Combustivel, ImpactoTotal) :-
    impacto(Combustivel, ImpactoPorKm),
    calcular_distancia_total(Rota, DistanciaTotal),
    ImpactoTotal is DistanciaTotal * ImpactoPorKm.



% ------------------------------ Distância total -----------------------------
calcular_distancia_total([_], 0).
calcular_distancia_total([Origem, Destino|Resto], DistanciaTotal) :-
    ligacao(Origem, Destino, dados(Distancia, _, _, _)),
    calcular_distancia_total([Destino|Resto], DistanciaRestante),
    DistanciaTotal is Distancia + DistanciaRestante.


% ----------------RF 14-------- Exemplo de utilização
% ------------------------------ Exemplo de uso:
%
% ?- listar_transportadora_ideal([q1, d2, d1], [0.4, 0.3, 0.2, 0.1], Ideal).
%
% Onde:
%   - [q1, d2, d1] é a rota desejada.
%   - Pesos para [Custo, Tempo, Capacidade, Impacto] são respectivamente [0.4, 0.3, 0.2, 0.1]
%
% Ideal terá a melhor transportadora segundo estes critérios e pesos.
% -----------------------------------------------------------------------------------




























% -------------------------------- RF15 -------------------------------
% sugestao_agrupamento_entregas(+Cultura, +CapacidadeMaxima, -ListaGrupos)
%
% Input:
%   Cultura           – Nome da cultura (ex: milho, tomate)
%   CapacidadeMaxima – Capacidade máxima de transporte em litros
%
% Output:
%   ListaGrupos – Lista de grupos de quintas (cada grupo é uma lista de IDs)
%
% Funcionamento:
%   - Recolhe todas as quintas com essa cultura e respetivo consumo.
%   - Agrupa quintas próximas (<=10km) cuja soma de consumo seja <= CapacidadeMaxima.
%   - Garante que cada quinta só aparece num grupo.
%   - Ignora quintas com outra cultura ou sem ligação viável.
%
% Exemplo:
%   ?- sugestao_agrupamento_entregas(milho, 8000, Grupos).
%   Grupos = [[q1, q2], [q3], [q5]]
% ---------------------------------------------------------------------

sugestao_agrupamento_entregas(Cultura, CapacidadeMaxima, ListaGrupos) :-
    findall((IdQuinta, Litros),
            consumo(IdQuinta, Cultura, Litros),
            QuintasComConsumo),
    agrupar_quintas_proximas(QuintasComConsumo, CapacidadeMaxima, ListaGrupos).



% ---------------------------------------------------------------------
% agrupar_quintas_proximas(+Quintas, +Capacidade, -Grupos)
%
% Agrupa quintas com base na proximidade e capacidade disponível.
% ---------------------------------------------------------------------
agrupar_quintas_proximas([], _, []).
agrupar_quintas_proximas([(IdBase, LitrosBase)|Outras], CapMax, [GrupoIds|GruposRestantes]) :-
    % Encontrar quintas vizinhas com capacidade combinada válida
    findall((IdVizinha, LitrosVizinha),
            (
                member((IdVizinha, LitrosVizinha), Outras),
                distancia_quintas(IdBase, IdVizinha, Distancia),
                Distancia =< 10,
                LitrosBase + LitrosVizinha =< CapMax
            ),
            Candidatas),

    % Grupo atual com a quinta base e candidatas válidas
    GrupoTuplos = [(IdBase, LitrosBase) | Candidatas],

    % Extrair apenas os IDs das quintas
    extrair_ids_quintas(GrupoTuplos, GrupoIds),

    % Remover as quintas deste grupo da lista original
    remover_quintas(GrupoTuplos, Outras, ListaRestante),

    % Repetir para o resto das quintas
    agrupar_quintas_proximas(ListaRestante, CapMax, GruposRestantes).



% ---------------------------------------------------------------------
% distancia_quintas(+Q1, +Q2, -Distancia)
%
% Calcula a distância entre duas quintas usando caminho/5.
% Se não houver caminho, retorna uma distância muito alta.
% ---------------------------------------------------------------------
distancia_quintas(Q1, Q2, Distancia) :-
    caminho(Q1, Q2, [Q1], _, Distancia), !.
distancia_quintas(_, _, 100000).  % fallback



% ---------------------------------------------------------------------
% extrair_ids_quintas(+ListaTuplos, -ListaIds)
%
% Converte tuplos (Id, _) numa lista só com os Ids.
% ---------------------------------------------------------------------
extrair_ids_quintas([], []).
extrair_ids_quintas([(Id, _)|T], [Id|R]) :-
    extrair_ids_quintas(T, R).



% ---------------------------------------------------------------------
% remover_quintas(+Grupo, +ListaOriginal, -ListaFiltrada)
%
% Remove as quintas de Grupo da ListaOriginal.
% ---------------------------------------------------------------------
remover_quintas([], L, L).
remover_quintas([(Id, _)|T], Lista, ListaFiltrada) :-
    select((Id, _), Lista, ListaAtualizada),
    remover_quintas(T, ListaAtualizada, ListaFiltrada).




















%---------------------------------------------------------%
% Limpa Buffer
%
%
% Usar quando querermos eliminar todos os dados para nao afetar o
% funcionamento
%---------------------------------------------------------%
reset_bd :-
    retractall(quinta(_,_,_)),
    retractall(sensor(_,_,_)),
    retractall(produtor(_,_,_)),
    retractall(distribuidor(_,_,_)),
    retractall(transportadora(_,_,_,_,_)),
    retractall(ligacao(_,_,_)),
    retractall(dono(_,_)),
    retractall(leitura(_,_,_,_)),
    retractall(consumo(_,_,_)),
    retractall(impacto(_,_)),
    retractall(historico_alteracao(_,_,_,_)).





















