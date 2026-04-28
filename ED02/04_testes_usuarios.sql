-- ============================================================
-- 04 - TESTES POR USUÁRIO
-- ============================================================

-- ============================================================
-- COMO USAR:

-- Execute cada bloco numa conexão separada no Workbench,
-- logado com o respectivo usuário.
-- Se os roles não ativarem automaticamente, rode:
-- SET ROLE ALL;
-- logo após conectar.
-- ============================================================

-- ============================================================
-- BLOCO 1 — usr_consulta / senha: Consulta@2024
-- Roles: role_consulta
-- ============================================================

-- ----------------------------------------------------------
-- T01 ✅ DEVE FUNCIONAR — SELECT na vw_estoque_publico
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T01 - vw_estoque_publico' AS teste;
SELECT * FROM vw_estoque_publico;

-- ----------------------------------------------------------
-- T02 ✅ DEVE FUNCIONAR — SELECT na vw_estoque_critico
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T02 - vw_estoque_critico' AS teste;
SELECT * FROM vw_estoque_critico;

-- ----------------------------------------------------------
-- T03 ❌ DEVE FALHAR — SELECT na usuarios_app (REVOKE aplicado)
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T03 - SELECT usuarios_app (esperado: erro de permissao)' AS teste;
SELECT * FROM usuarios_app;

-- ----------------------------------------------------------
-- T04 ❌ DEVE FALHAR — INSERT em movimentacao
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T04 - INSERT movimentacao (esperado: erro de permissao)' AS teste;
INSERT INTO movimentacao (tipo, quantidade, id_produto)
VALUES ('entrada', 1, 1);

-- ----------------------------------------------------------
-- T05 ❌ DEVE FALHAR — SELECT na vw_estoque_gerencial
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T05 - vw_estoque_gerencial (esperado: erro de permissao)' AS teste;
SELECT * FROM vw_estoque_gerencial;

-- ----------------------------------------------------------
-- T06 ❌ DEVE FALHAR — UPDATE em produto
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T06 - UPDATE produto (esperado: erro de permissao)' AS teste;
UPDATE produto SET preco = 1.00 WHERE id_produto = 1;



-- ============================================================
-- BLOCO 2 — usr_operador / senha: Operador@2024
-- Roles: role_operador (herda role_consulta)
-- ============================================================

-- ----------------------------------------------------------
-- T07 ✅ DEVE FUNCIONAR — SELECT na vw_estoque_publico (herdado)
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T07 - vw_estoque_publico (herdado de role_consulta)' AS teste;
SELECT * FROM vw_estoque_publico;

-- ----------------------------------------------------------
-- T08 ✅ DEVE FUNCIONAR — SELECT na vw_estoque_critico (herdado)
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T08 - vw_estoque_critico (herdado de role_consulta)' AS teste;
SELECT * FROM vw_estoque_critico;

-- ----------------------------------------------------------
-- T09 ✅ DEVE FUNCIONAR — SELECT na vw_movimentacoes
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T09 - vw_movimentacoes' AS teste;
SELECT * FROM vw_movimentacoes;

-- ----------------------------------------------------------
-- T10 ✅ DEVE FUNCIONAR — INSERT em movimentacao
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T10 - INSERT movimentacao (entrada)' AS teste;
INSERT INTO movimentacao (tipo, quantidade, id_produto)
VALUES ('entrada', 1, 1);

-- ----------------------------------------------------------
-- T11 ✅ DEVE FUNCIONAR — INSERT saida com estoque suficiente
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T11 - INSERT movimentacao (saida valida)' AS teste;
INSERT INTO movimentacao (tipo, quantidade, id_produto)
VALUES ('saida', 1, 2);

-- ----------------------------------------------------------
-- T12 ❌ DEVE FALHAR — saida com estoque insuficiente (trigger)
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T12 - INSERT movimentacao saida sem estoque (esperado: erro de trigger)' AS teste;
INSERT INTO movimentacao (tipo, quantidade, id_produto)
VALUES ('saida', 99999, 1);

-- ----------------------------------------------------------
-- T13 ❌ DEVE FALHAR — UPDATE em produto
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T13 - UPDATE produto (esperado: erro de permissao)' AS teste;
UPDATE produto SET preco = 100.00 WHERE id_produto = 1;

-- ----------------------------------------------------------
-- T14 ❌ DEVE FALHAR — SELECT na vw_estoque_gerencial
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T14 - vw_estoque_gerencial (esperado: erro de permissao)' AS teste;
SELECT * FROM vw_estoque_gerencial;

-- ----------------------------------------------------------
-- T15 ❌ DEVE FALHAR — DELETE em produto
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T15 - DELETE produto (esperado: erro de permissao)' AS teste;
DELETE FROM produto WHERE id_produto = 1;



-- ============================================================
-- BLOCO 3 — usr_gerente / senha: Gerente@2024
-- Roles: role_gerente (herda role_operador e role_consulta)
-- ============================================================

-- ----------------------------------------------------------
-- T16 ✅ DEVE FUNCIONAR — SELECT na vw_estoque_publico (herdado)
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T16 - vw_estoque_publico (herdado)' AS teste;
SELECT * FROM vw_estoque_publico;

-- ----------------------------------------------------------
-- T17 ✅ DEVE FUNCIONAR — SELECT na vw_movimentacoes (herdado)
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T17 - vw_movimentacoes (herdado)' AS teste;
SELECT * FROM vw_movimentacoes;

-- ----------------------------------------------------------
-- T18 ✅ DEVE FUNCIONAR — SELECT na vw_estoque_gerencial
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T18 - vw_estoque_gerencial' AS teste;
SELECT * FROM vw_estoque_gerencial;

-- ----------------------------------------------------------
-- T19 ✅ DEVE FUNCIONAR — UPDATE em produto
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T19 - UPDATE produto (preco)' AS teste;
UPDATE produto SET preco = 3299.90 WHERE id_produto = 1;

-- ----------------------------------------------------------
-- T20 ✅ DEVE FUNCIONAR — INSERT em categoria
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T20 - INSERT categoria' AS teste;
INSERT INTO categoria (nome) VALUES ('Acessórios');

-- ----------------------------------------------------------
-- T21 ✅ DEVE FUNCIONAR — UPDATE em fornecedor
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T21 - UPDATE fornecedor' AS teste;
UPDATE fornecedor SET contato = 'novo@techsupply.com' WHERE id_fornecedor = 1;

-- ----------------------------------------------------------
-- T22 ✅ DEVE FUNCIONAR — INSERT em produto
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T22 - INSERT produto' AS teste;
INSERT INTO produto (nome, preco, quantidade, id_categoria, id_fornecedor)
VALUES ('Headset Sony', 499.90, 10, 3, 2);

-- ----------------------------------------------------------
-- T23 ❌ DEVE FALHAR — DELETE em produto
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T23 - DELETE produto (esperado: erro de permissao)' AS teste;
DELETE FROM produto WHERE id_produto = 1;

-- ----------------------------------------------------------
-- T24 ❌ DEVE FALHAR — SELECT em log_auditoria
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T24 - SELECT log_auditoria (esperado: erro de permissao)' AS teste;
SELECT * FROM log_auditoria;

-- ----------------------------------------------------------
-- T25 ❌ DEVE FALHAR — DROP TABLE
-- ----------------------------------------------------------
USE controle_estoque;
SET ROLE ALL;

SELECT 'T25 - DROP TABLE (esperado: erro de permissao)' AS teste;
DROP TABLE categoria;



-- ============================================================
-- BLOCO 4 — usr_dba / senha: DBA@Estoque2024!
-- Permissões: ALL PRIVILEGES WITH GRANT OPTION
-- ============================================================

-- ----------------------------------------------------------
-- T26 ✅ DEVE FUNCIONAR — SELECT em qualquer tabela
-- ----------------------------------------------------------
USE controle_estoque;

SELECT 'T26 - SELECT log_auditoria' AS teste;
SELECT * FROM log_auditoria ORDER BY data_hora DESC LIMIT 10;

-- ----------------------------------------------------------
-- T27 ✅ DEVE FUNCIONAR — SELECT em usuarios_app
-- ----------------------------------------------------------
USE controle_estoque;

SELECT 'T27 - SELECT usuarios_app' AS teste;
SELECT id_usuario, nome_usuario, email, LEFT(senha_hash,20) AS hash_parcial,
       ativo, data_criacao, ultimo_acesso
FROM usuarios_app;

-- ----------------------------------------------------------
-- T28 ✅ DEVE FUNCIONAR — Chamar procedure de auditoria
-- ----------------------------------------------------------
USE controle_estoque;

SELECT 'T28 - CALL sp_checkpoint' AS teste;
CALL sp_checkpoint();

-- ----------------------------------------------------------
-- T29 ✅ DEVE FUNCIONAR — Testar login válido via procedure
-- ----------------------------------------------------------
USE controle_estoque;

SELECT 'T29 - Login valido (joao_silva)' AS teste;
CALL sp_validar_login('joao_silva', 'JoaoSenha123');
SELECT ultimo_acesso FROM usuarios_app WHERE nome_usuario = 'joao_silva';

-- ----------------------------------------------------------
-- T30 ✅ DEVE FUNCIONAR — Testar login inválido via procedure
-- ----------------------------------------------------------
USE controle_estoque;

SELECT 'T30 - Login invalido (senha errada)' AS teste;
CALL sp_validar_login('joao_silva', 'senhaErrada');
SELECT valor_novo FROM log_auditoria
WHERE tabela = 'LOGIN' ORDER BY data_hora DESC LIMIT 2;

-- ----------------------------------------------------------
-- T31 ✅ DEVE FUNCIONAR — Testar undo de produto (auditoria)
-- ----------------------------------------------------------
USE controle_estoque;

SELECT 'T31 - sp_undo_produto (revertendo produto 1)' AS teste;
-- Primeiro faz um UPDATE para gerar log
UPDATE produto SET preco = 9999.00, nome = 'Produto Alterado Teste' WHERE id_produto = 1;
-- Verifica o log gerado
SELECT * FROM log_auditoria WHERE tabela = 'produto' AND id_registro = 1 ORDER BY id_log DESC LIMIT 1;
-- Reverte
CALL sp_undo_produto(1);
-- Confirma reversão
SELECT id_produto, nome, preco FROM produto WHERE id_produto = 1;

-- ----------------------------------------------------------
-- T32 ✅ DEVE FUNCIONAR — Conceder permissão a outro usuário (GRANT OPTION)
-- ----------------------------------------------------------
USE controle_estoque;

SELECT 'T32 - GRANT SELECT em log_auditoria para usr_gerente' AS teste;
GRANT SELECT ON controle_estoque.log_auditoria TO 'usr_gerente'@'localhost';
-- Revogar em seguida para não alterar o modelo original
REVOKE SELECT ON controle_estoque.log_auditoria FROM 'usr_gerente'@'localhost';

-- ----------------------------------------------------------
-- T33 ❌ DEVE FALHAR — Permissão global concedida só pelo root
-- ----------------------------------------------------------
USE controle_estoque;

SELECT 'T33 - SHOW GRANTS usr_consulta' AS teste;
SHOW GRANTS FOR 'usr_consulta'@'localhost';

SELECT 'T33 - SHOW GRANTS usr_operador' AS teste;
SHOW GRANTS FOR 'usr_operador'@'localhost';

SELECT 'T33 - SHOW GRANTS usr_gerente' AS teste;
SHOW GRANTS FOR 'usr_gerente'@'localhost';