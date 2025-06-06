-- RF 1 Implementar as operações CRUD da BD para as entidades identificadas.  (CRUD)
INSERT INTO Produtor (NIF, Name, Address, PhoneNum, AreaCultivada)
VALUES (101000011, 'André Pinto', 'Rua das Laranjeiras, 99', 919876543, '4.2');

SELECT * FROM Produtor;

UPDATE Produtor
SET Address = 'Rua Nova das Laranjeiras, 100'
WHERE NIF = 101000011;

DELETE FROM Produtor
WHERE NIF = 101000011;
SELECT * FROM Produtor;
-- ----------------------------------------------------------------------------


-- RF 2  Registar valores provenientes das produções (quantidade, qualidade, comercialização, etc..).
-- Goal: Mostrar todas as colheitas realizadas com dados agregados do produtor e tipo de cultivo.
-- Basicamente feito no DATA.sql
CREATE OR REPLACE VIEW vw_RF2_RegistosDeProducaoDetalhados AS
SELECT 
    RP.LoteID,                              -- ID do lote produzido
    P.Name AS NomeProdutor,                -- Nome do produtor responsável
    C.Tipo AS TipoCultivo,                 -- Tipo de cultura (ex: Tomate, Batata)
    RP.Quantidade,                         -- Quantidade colhida (em kg)
    RP.DataColhida,                        -- Data em que foi feita a colheita
    RP.Qualidade,                          -- Qualidade do lote (0 a 1, ou escala de 0 a 10)
    RP.Destino                             -- Distribuidor ou destino final da produção
FROM 
    RegistosProducao RP                    -- Tabela principal de registos
JOIN Cultivo C ON RP.Cultivo_ID_Registos_Producao = C.ID            -- Liga com a tabela Cultivo
JOIN Produtor P ON C.Produtor_NIF_Cultivo = P.NIF;                  -- Liga com a tabela Produtor

SELECT * FROM vw_RF2_RegistosDeProducaoDetalhados;
-- --------------------------------------------------------------------------------------------------

-- RF 3 Visualizar o histórico de colheitas de um produtor num intervalo de tempo.
CREATE OR REPLACE VIEW vw_RF3_HistoricoColheitas AS
SELECT 
    C.ID AS CultivoID,                -- ID do cultivo
    P.Name AS NomeProdutor,           -- Nome do produtor
    C.Tipo AS Cultura,                -- Tipo da cultura (ex: Tomate)
    C.DataPlantado,                   -- Data em que foi plantado
    C.DataColhido,                    -- Data em que foi colhido
    C.Rendimento,                     -- Rendimento esperado
    C.TipoPratica                     -- Tipo de prática agrícola (Biológica, Convencional...)
FROM 
    Cultivo C
JOIN 
    Produtor P ON C.Produtor_NIF_Cultivo = P.NIF;

SELECT *
FROM vw_RF3_HistoricoColheitas
WHERE 
    NomeProdutor = 'João Silva'
    AND DataColhido BETWEEN '2024-03-01' AND '2024-06-30'
ORDER BY 
    DataColhido DESC; -- DESC = Decrescente
-- ------------------------------------------------------------------------------

-- RF4 - Histórico de colheitas de um produtor num intervalo de tempo
CREATE OR REPLACE VIEW vw_RF4_HistoricoColheitas AS
SELECT 
    ID                  AS CultivoID,
    Tipo                AS Cultura,
    DataPlantado,
    DataColhido,
    Rendimento,
    TipoPratica
FROM 
    Cultivo
WHERE 
    Produtor_NIF_Cultivo = 101000001
    AND DataColhido BETWEEN '2024-03-01' AND '2024-06-30'
ORDER BY 
    DataColhido DESC;
-- ---------------------------------------------------------------------
-- SELECT * FROM Cultivo WHERE Produtor_NIF_Cultivo = 101000001;
SELECT * FROM vw_RF4_HistoricoColheitas;


-- RF5 - Histórico de colheitas de um produtor num intervalo de tempo
CREATE OR REPLACE VIEW vw_RF5_ProdutoresComMaisVendas AS
SELECT 
    P.NIF,                                       -- NIF do produtor
    P.Name AS NomeProdutor,                      -- Nome do produtor
    COUNT(C.ID) AS TotalComercializacoes,        -- Nº de comercializações
    SUM(C.QuantidadeVendida) AS TotalKgVendidos  -- Total vendido em Kg
FROM 
    Produtor P
JOIN 
    Cultivo CU ON CU.Produtor_NIF_Cultivo = P.NIF
JOIN 
    RegistosProducao RP ON RP.Cultivo_ID_Registos_Producao = CU.ID
JOIN 
    Comercializacao C ON C.LoteID_RegistosProducao = RP.LoteID
GROUP BY 
    P.NIF, P.Name
ORDER BY 
    TotalKgVendidos DESC;
-- -------------------------------------------------------------------
# Para consultar os dados:
SELECT * FROM vw_RF5_ProdutoresComMaisVendas;



-- RF6: Estado atual dos tratamentos e estoque de produtos
-- Esta query mostra:
-- - O nome e fornecedor de cada tratamento
-- - A data de aplicação
-- - A quantidade usada
-- - O total disponível em stock
-- - E a quantidade restante (em stock) após uso
CREATE OR REPLACE VIEW vw_RF6_EstadoTratamentosEstoque AS
SELECT 
    Nome,                               -- Nome do tratamento
    Fornecedor,                         -- Fornecedor do tratamento
    DataAplicacao,                      -- Data em que foi aplicado
    QuantidadeUsada,                    -- Quantidade que já foi usada
    QuantidadeEstoqueTotal,             -- Quantidade total recebida
    (QuantidadeEstoqueTotal - QuantidadeUsada) AS QuantidadeRestante -- Quantidade ainda disponível
FROM 
    Tratamentos;
-- ----------------------------------------------------------------------------------------------------
# Para consultar os dados, usa:
SELECT * FROM vw_RF6_EstadoTratamentosEstoque;


-- RF7: Estado dos sensores IoT – máximos, mínimos e médias
-- Esta view processa os dados dos sensores ligados aos cultivos
-- e calcula estatísticas agregadas úteis para análise agrícola.
CREATE OR REPLACE VIEW vw_RF7_EstadoSensoresIoT AS
SELECT 
    MAX(Temperatura) AS TemperaturaMaxima,
    MIN(Temperatura) AS TemperaturaMinima,
    ROUND(AVG(Temperatura), 2) AS TemperaturaMedia,

    MAX(humidadeSolo) AS HumidadeMaxima,
    MIN(humidadeSolo) AS HumidadeMinima,
    ROUND(AVG(humidadeSolo), 2) AS HumidadeMedia,

    MAX(luminosidade) AS LuminosidadeMaxima,
    MIN(luminosidade) AS LuminosidadeMinima,
    ROUND(AVG(luminosidade), 2) AS LuminosidadeMedia,

    MAX(NivelIrrigacao) AS IrrigacaoMaxima,
    MIN(NivelIrrigacao) AS IrrigacaoMinima,
    ROUND(AVG(NivelIrrigacao), 2) AS IrrigacaoMedia,

    MAX(QualidadeAr) AS QualidadeArMaxima,
    MIN(QualidadeAr) AS QualidadeArMinima,
    ROUND(AVG(QualidadeAr), 2) AS QualidadeArMedia
FROM 
    Sensores_IoT;
-- ------------------------------------------------------------
-- Para consultar os resultados:
SELECT * FROM vw_RF7_EstadoSensoresIoT;


-- RF8: Gerar relatórios sobre eficiência agrícola e uso de recursos. Por exemplo, mostrar a produção total de um determinado produto e os recursos utilizados para o mesmo. ( Area onde o recurso foi usado)
-- Ex: ""Quanto milho foi produzido e quais foram os recursos aplicados nesse processo?"
CREATE OR REPLACE VIEW vw_RF8_EficienciaAgricola AS
SELECT 
    C.Tipo AS TipoCultivo,                                -- Tipo do cultivo (ex: Tomate, Batata...)
    SUM(RP.Quantidade) AS ProducaoTotalKg,                -- Soma da quantidade produzida (em kg) para o cultivo
    SUM(GR.Quantidade) AS RecursosUtilizadosTotal,        -- Soma da quantidade de recursos utilizados no cultivo
    GROUP_CONCAT(DISTINCT GR.Tipo_Recurso) AS TiposRecursosAplicados  -- Lista de tipos diferentes de recurso aplicados
FROM 
    Cultivo C                                             -- Tabela de cultivos
JOIN 
    RegistosProducao RP ON RP.Cultivo_ID_Registos_Producao = C.ID  -- Junta os registos de produção
LEFT JOIN 
    Gestao_Recursos GR ON GR.NIF_Produtor = C.Produtor_NIF_Cultivo -- Junta os recursos usados, ligados ao produtor
GROUP BY 
    C.Tipo                                                -- Agrupa por tipo de cultura
ORDER BY 
    ProducaoTotalKg DESC;                                 -- Ordena do mais produtivo para o menos produtivo
-- -------------------------------------------------------------------------------------------------------------------
-- Para consultar os resultados:
SELECT * FROM vw_RF8_EficienciaAgricola;


-- RF9 Proponha um requisito relevante e ainda por identificar que implique a criação e a especificação de uma ou mais entidades. Implemente
-- "Listar os produtos mais vendidos por cada produtor."
-- RF9: View para listar os produtos mais vendidos por cada produtor
CREATE OR REPLACE VIEW vw_RF9_ProdutosMaisVendidos AS  -- Cria (ou substitui) uma view com o nome vw_RF9_ProdutosMaisVendidos
SELECT 
    PMV.ID,                                            -- ID do registo na tabela ProdutosMaisVendidos (auto_increment)
    P.Name AS NomeProdutor,                            -- Nome do produtor, vindo da tabela Produtor
    PMV.TipoProduto,                                   -- O tipo de produto vendido (ex: Tomate, Batata)
    PMV.QuantidadeVendidaTotal                         -- Quantidade total vendida desse produto
FROM 
    ProdutosMaisVendidos PMV                           -- A view parte da tabela ProdutosMaisVendidos
JOIN 
    Produtor P ON P.NIF = PMV.Produtor_NIF_PMV         -- Junta com a tabela Produtor para ir buscar o nome do produtor
ORDER BY 
    PMV.QuantidadeVendidaTotal DESC;                   -- Ordena os resultados do mais vendido para o menos vendido
-- ------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM vw_RF9_ProdutosMaisVendidos;



-- RF10: Produtores com cultivos do tipo 'Biológica' após 2024-03-01
-- RF10: Produtores com cultivos do tipo 'Biológica' após 2024-03-01
CREATE OR REPLACE VIEW vw_RF10_ProdutoresCultivoBiologico AS
SELECT 
    P.NIF,
    P.Name AS NomeProdutor,
    C.Tipo AS TipoCultura,
    C.DataPlantado
FROM 
    Produtor P
JOIN Cultivo C ON C.Produtor_NIF_Cultivo = P.NIF
WHERE 
    C.TipoPratica = 'Biológica'
    AND C.DataPlantado > '2024-03-01';
-- ------------------------------------------------------------------------------------
SELECT * FROM vw_RF10_ProdutoresCultivoBiologico;


-- RF 11 – Proponha um requisito relevante ainda por identificar e que requeira uma query com funções de agregação (sum, max, min, avg, etc) para o satisfazer. Implemente.
-- Ver estatísticas de qualidade de colheitas por tipo de cultura
-- RF11: Estatísticas da qualidade de colheitas por tipo de cultura
CREATE OR REPLACE VIEW vw_RF11_EstatisticasQualidadePorCultura AS
SELECT 
    C.Tipo AS TipoCultura,                       -- Tipo de cultivo (ex: Tomate, Milho, etc)
    COUNT(RP.Qualidade) AS TotalColheitas,      -- Total de registos dessa cultura
    MIN(RP.Qualidade) AS QualidadeMinima,       -- Qualidade mínima registada
    MAX(RP.Qualidade) AS QualidadeMaxima,       -- Qualidade máxima registada
    ROUND(AVG(RP.Qualidade), 2) AS QualidadeMedia -- Qualidade média (arredondada a 2 casas)
FROM 
    RegistosProducao RP
JOIN 
    Cultivo C ON C.ID = RP.Cultivo_ID_Registos_Producao
GROUP BY 
    C.Tipo;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT * FROM vw_RF11_EstatisticasQualidadePorCultura;



-- RF 12 – Proponha um requisito relevante ainda por identificar e que requeira o desenvolvimento de functions/procedures para o satisfazer. Implemente.
-- Function para calcular e verificar a eficiência de um produtor
SELECT 
    P.NIF,                                               -- Mostra o NIF do produtor (chave primária)
    P.Name AS NomeProdutor,                              -- Mostra o nome do produtor (renomeado como 'NomeProdutor')
    fn_CalcularEficienciaProdutor(P.NIF) AS Eficiencia   -- Chama a função criada no RF12 e calcula a eficiência com base no NIF de cada produtor
FROM 
    Produtor P;                                  -- Tabela principal onde estão registados todos os produtores
-- -----------------------------------------------------------------------------------------------------------------------------------------------------




