-- ============================================================
-- 02 - AUDITORIA E RECUPERAÇÃO
-- ============================================================

USE controle_estoque;

DROP TABLE IF EXISTS log_auditoria;
CREATE TABLE log_auditoria (
    id_log INT NOT NULL AUTO_INCREMENT,
    usuario VARCHAR(100) NOT NULL DEFAULT (CURRENT_USER()),
    operacao ENUM('INSERT','UPDATE','DELETE') NOT NULL,
    tabela VARCHAR(50) NOT NULL,
    id_registro INT,
    valor_antigo TEXT,
    valor_novo TEXT,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('confirmada','revertida') NOT NULL DEFAULT 'confirmada',
    PRIMARY KEY (id_log)
);

DROP TRIGGER IF EXISTS trg_log_produto_insert;
DROP TRIGGER IF EXISTS trg_log_produto_update;
DROP TRIGGER IF EXISTS trg_log_produto_delete;
DROP TRIGGER IF EXISTS trg_log_movimentacao_insert;

DELIMITER $$
CREATE TRIGGER trg_log_produto_insert
AFTER INSERT ON produto
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (operacao, tabela, id_registro, valor_antigo, valor_novo)
    VALUES (
        'INSERT',
        'produto',
        NEW.id_produto,
        NULL,
        CONCAT('nome=', NEW.nome, ' | preco=', NEW.preco, ' | quantidade=', NEW.quantidade)
    );
END$$

CREATE TRIGGER trg_log_produto_update
AFTER UPDATE ON produto
FOR EACH ROW
BEGIN
    IF OLD.nome <> NEW.nome OR OLD.preco <> NEW.preco OR OLD.quantidade <> NEW.quantidade THEN
        INSERT INTO log_auditoria (operacao, tabela, id_registro, valor_antigo, valor_novo)
        VALUES (
            'UPDATE',
            'produto',
            NEW.id_produto,
            CONCAT('nome=', OLD.nome, ' | preco=', OLD.preco, ' | quantidade=', OLD.quantidade),
            CONCAT('nome=', NEW.nome, ' | preco=', NEW.preco, ' | quantidade=', NEW.quantidade)
        );
    END IF;
END$$

CREATE TRIGGER trg_log_produto_delete
BEFORE DELETE ON produto
FOR EACH ROW
BEGIN
    INSERT INTO log_auditoria (operacao, tabela, id_registro, valor_antigo, valor_novo)
    VALUES (
        'DELETE',
        'produto',
        OLD.id_produto,
        CONCAT('nome=', OLD.nome, ' | preco=', OLD.preco, ' | quantidade=', OLD.quantidade,
               ' | id_categoria=', OLD.id_categoria, ' | id_fornecedor=', IFNULL(OLD.id_fornecedor, 'NULL')),
        NULL
    );
END$$

CREATE TRIGGER trg_log_movimentacao_insert
AFTER INSERT ON movimentacao
FOR EACH ROW
BEGIN
    DECLARE estoque_depois INT;
    DECLARE estoque_antes INT;

    SELECT quantidade
    INTO estoque_depois
    FROM produto
    WHERE id_produto = NEW.id_produto;

    IF NEW.tipo = 'entrada' THEN
        SET estoque_antes = estoque_depois - NEW.quantidade;
    ELSE
        SET estoque_antes = estoque_depois + NEW.quantidade;
    END IF;

    INSERT INTO log_auditoria (operacao, tabela, id_registro, valor_antigo, valor_novo)
    VALUES (
        'INSERT',
        'movimentacao',
        NEW.id_movimentacao,
        CONCAT('estoque_antes=', estoque_antes),
        CONCAT('tipo=', NEW.tipo, ' | quantidade=', NEW.quantidade, ' | estoque_depois=', estoque_depois)
    );
END$$
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_undo_produto;
DROP PROCEDURE IF EXISTS sp_checkpoint;

DELIMITER $$
CREATE PROCEDURE sp_undo_produto(IN p_id_produto INT)
BEGIN
    DECLARE v_id_log INT;
    DECLARE v_valor_antigo TEXT;
    DECLARE v_nome VARCHAR(150);
    DECLARE v_preco DECIMAL(10,2);
    DECLARE v_quantidade INT;

    SELECT id_log, valor_antigo
    INTO v_id_log, v_valor_antigo
    FROM log_auditoria
    WHERE tabela = 'produto'
      AND id_registro = p_id_produto
      AND operacao = 'UPDATE'
      AND status = 'confirmada'
    ORDER BY data_hora DESC, id_log DESC
    LIMIT 1;

    IF v_id_log IS NOT NULL THEN
        SET v_nome = SUBSTRING_INDEX(SUBSTRING_INDEX(v_valor_antigo, 'nome=', -1), ' |', 1);
        SET v_preco = CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(v_valor_antigo, 'preco=', -1), ' |', 1) AS DECIMAL(10,2));
        SET v_quantidade = CAST(SUBSTRING_INDEX(v_valor_antigo, 'quantidade=', -1) AS SIGNED);

        UPDATE produto
        SET nome = v_nome,
            preco = v_preco,
            quantidade = v_quantidade
        WHERE id_produto = p_id_produto;

        UPDATE log_auditoria
        SET status = 'revertida'
        WHERE id_log = v_id_log;
    END IF;
END$$

CREATE PROCEDURE sp_checkpoint()
BEGIN
    INSERT INTO log_auditoria (operacao, tabela, id_registro, valor_novo)
    VALUES ('INSERT', '__CHECKPOINT__', 0, CONCAT('checkpoint=', NOW()));
END$$
DELIMITER ;
