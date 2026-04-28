-- ============================================================
-- 03 - SEGURANÇA, USUÁRIOS, PERMISSÕES E VIEWS
-- ============================================================

USE controle_estoque;

-- Dados sensíveis protegidos por hash.
DROP TABLE IF EXISTS usuarios_app;
CREATE TABLE usuarios_app (
    id_usuario INT NOT NULL AUTO_INCREMENT,
    nome_usuario VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL,
    senha_hash CHAR(64) NOT NULL,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,
    data_criacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ultimo_acesso DATETIME,
    PRIMARY KEY (id_usuario)
);

INSERT INTO usuarios_app (nome_usuario, email, senha_hash) VALUES
    ('joao_silva', 'joao@empresa.com', SHA2('JoaoSenha123', 256)),
    ('maria_santos', 'maria@empresa.com', SHA2('MariaSenha456', 256)),
    ('carlos_oliveira', 'carlos@empresa.com', SHA2('CarlosSenha789', 256));

DROP PROCEDURE IF EXISTS sp_validar_login;
DELIMITER $$
CREATE PROCEDURE sp_validar_login(
    IN p_usuario VARCHAR(100),
    IN p_senha VARCHAR(255)
)
BEGIN
    DECLARE v_id_usuario INT;

    SELECT id_usuario
    INTO v_id_usuario
    FROM usuarios_app
    WHERE nome_usuario = p_usuario
      AND senha_hash = SHA2(p_senha, 256)
      AND ativo = TRUE;

    IF v_id_usuario IS NOT NULL THEN
        UPDATE usuarios_app
        SET ultimo_acesso = NOW()
        WHERE id_usuario = v_id_usuario;

        INSERT INTO log_auditoria (operacao, tabela, id_registro, valor_novo)
        VALUES ('INSERT', 'LOGIN', v_id_usuario, CONCAT('login válido: ', p_usuario));
    ELSE
        INSERT INTO log_auditoria (operacao, tabela, valor_novo)
        VALUES ('INSERT', 'LOGIN', CONCAT('login inválido: ', p_usuario));
    END IF;
END$$
DELIMITER ;

-- Views para restringir dados exibidos.
DROP VIEW IF EXISTS vw_estoque_publico;
DROP VIEW IF EXISTS vw_estoque_gerencial;
DROP VIEW IF EXISTS vw_movimentacoes;
DROP VIEW IF EXISTS vw_estoque_critico;

CREATE VIEW vw_estoque_publico AS
SELECT
    p.id_produto,
    p.nome AS produto,
    p.quantidade AS estoque_atual,
    c.nome AS categoria
FROM produto p
JOIN categoria c ON c.id_categoria = p.id_categoria;

CREATE VIEW vw_estoque_gerencial AS
SELECT
    p.id_produto,
    p.nome AS produto,
    p.preco,
    p.quantidade AS estoque_atual,
    p.preco * p.quantidade AS valor_total_estoque,
    c.nome AS categoria,
    f.nome AS fornecedor
FROM produto p
JOIN categoria c ON c.id_categoria = p.id_categoria
LEFT JOIN fornecedor f ON f.id_fornecedor = p.id_fornecedor;

CREATE VIEW vw_movimentacoes AS
SELECT
    m.id_movimentacao,
    p.nome AS produto,
    m.tipo,
    m.quantidade,
    m.data_mov
FROM movimentacao m
JOIN produto p ON p.id_produto = m.id_produto;

CREATE VIEW vw_estoque_critico AS
SELECT
    p.id_produto,
    p.nome AS produto,
    p.quantidade AS estoque_atual,
    c.nome AS categoria
FROM produto p
JOIN categoria c ON c.id_categoria = p.id_categoria
WHERE p.quantidade < 25;

-- Usuários do SGBD.
DROP USER IF EXISTS 'usr_consulta'@'localhost';
DROP USER IF EXISTS 'usr_operador'@'localhost';
DROP USER IF EXISTS 'usr_gerente'@'localhost';
DROP USER IF EXISTS 'usr_dba'@'localhost';

CREATE USER 'usr_consulta'@'localhost' IDENTIFIED BY 'Consulta@2024';
CREATE USER 'usr_operador'@'localhost' IDENTIFIED BY 'Operador@2024';
CREATE USER 'usr_gerente'@'localhost' IDENTIFIED BY 'Gerente@2024';
CREATE USER 'usr_dba'@'localhost' IDENTIFIED BY 'DBA@Estoque2024!';

-- Roles.
DROP ROLE IF EXISTS 'role_consulta';
DROP ROLE IF EXISTS 'role_operador';
DROP ROLE IF EXISTS 'role_gerente';

CREATE ROLE 'role_consulta';
CREATE ROLE 'role_operador';
CREATE ROLE 'role_gerente';

-- Permissões por perfil.
GRANT SELECT ON controle_estoque.vw_estoque_publico TO 'role_consulta';
GRANT SELECT ON controle_estoque.vw_estoque_critico TO 'role_consulta';

GRANT 'role_consulta' TO 'role_operador';
GRANT SELECT ON controle_estoque.vw_movimentacoes TO 'role_operador';
GRANT INSERT ON controle_estoque.movimentacao TO 'role_operador';

GRANT 'role_operador' TO 'role_gerente';
GRANT SELECT ON controle_estoque.vw_estoque_gerencial TO 'role_gerente';
GRANT SELECT, INSERT, UPDATE ON controle_estoque.produto TO 'role_gerente';
GRANT SELECT, INSERT, UPDATE ON controle_estoque.categoria TO 'role_gerente';
GRANT SELECT, INSERT, UPDATE ON controle_estoque.fornecedor TO 'role_gerente';

GRANT 'role_consulta' TO 'usr_consulta'@'localhost';
GRANT 'role_operador' TO 'usr_operador'@'localhost';
GRANT 'role_gerente' TO 'usr_gerente'@'localhost';
GRANT ALL PRIVILEGES ON controle_estoque.* TO 'usr_dba'@'localhost' WITH GRANT OPTION;

SET DEFAULT ROLE 'role_consulta' TO 'usr_consulta'@'localhost';
SET DEFAULT ROLE 'role_operador' TO 'usr_operador'@'localhost';
SET DEFAULT ROLE 'role_gerente' TO 'usr_gerente'@'localhost';

-- Exemplo obrigatório de REVOKE: concede e remove um acesso sensível.
GRANT SELECT ON controle_estoque.usuarios_app TO 'usr_consulta'@'localhost';
REVOKE SELECT ON controle_estoque.usuarios_app FROM 'usr_consulta'@'localhost';

FLUSH PRIVILEGES;
