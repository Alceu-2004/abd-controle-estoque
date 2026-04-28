-- ============================================================
-- 01 - ESTRUTURA BÁSICA DO BANCO
-- Sistema: Controle de Estoque
-- ============================================================

DROP DATABASE IF EXISTS controle_estoque;
CREATE DATABASE controle_estoque
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE controle_estoque;

-- ------------------------------------------------------------
-- TABELA: Categoria
-- ------------------------------------------------------------
CREATE TABLE categoria (
    id_categoria INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_categoria),
    UNIQUE (nome)
);

-- ------------------------------------------------------------
-- TABELA: Fornecedor
-- ------------------------------------------------------------
CREATE TABLE fornecedor (
    id_fornecedor INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    contato VARCHAR(100),
    PRIMARY KEY (id_fornecedor)
);

-- ------------------------------------------------------------
-- TABELA: Produto
-- ------------------------------------------------------------
CREATE TABLE produto (
    id_produto INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(150) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    id_categoria INT NOT NULL,
    id_fornecedor INT,
    PRIMARY KEY (id_produto),
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CHECK (preco > 0),
    CHECK (quantidade >= 0)
);

-- ------------------------------------------------------------
-- TABELA: Movimentacao
-- ------------------------------------------------------------
CREATE TABLE movimentacao (
    id_movimentacao INT NOT NULL AUTO_INCREMENT,
    tipo ENUM('entrada','saida') NOT NULL,
    quantidade INT NOT NULL,
    data_mov DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_produto INT NOT NULL,
    PRIMARY KEY (id_movimentacao),
    FOREIGN KEY (id_produto) REFERENCES produto(id_produto)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (quantidade > 0)
);

-- ------------------------------------------------------------
-- TRIGGER: Atualização de Estoque
-- ------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER trg_atualiza_estoque
BEFORE INSERT ON movimentacao
FOR EACH ROW
BEGIN
    DECLARE estoque_atual INT;

    SELECT quantidade
    INTO estoque_atual
    FROM produto
    WHERE id_produto = NEW.id_produto;

    IF NEW.tipo = 'saida' THEN
        IF estoque_atual < NEW.quantidade THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Estoque insuficiente';
        ELSE
            UPDATE produto
            SET quantidade = quantidade - NEW.quantidade
            WHERE id_produto = NEW.id_produto;
        END IF;
    ELSE
        UPDATE produto
        SET quantidade = quantidade + NEW.quantidade
        WHERE id_produto = NEW.id_produto;
    END IF;
END$$
DELIMITER ;

INSERT INTO categoria (nome) VALUES
    ('Eletrônicos'),
    ('Computadores'),
    ('Periféricos');

INSERT INTO fornecedor (nome, contato) VALUES
    ('TechSupply Ltda', 'techsupply@email.com'),
    ('InfoParts S.A.', 'contato@infoparts.com'),
    ('MegaComp Dist.', 'vendas@megacomp.com');

INSERT INTO produto (nome, preco, quantidade, id_categoria, id_fornecedor) VALUES
    ('Notebook Dell Inspiron', 3499.90, 15, 2, 1),
    ('Mouse Logitech MX Master', 349.90, 50, 3, 2),
    ('Monitor Samsung 24', 1299.00, 20, 1, 3),
    ('Teclado Mecânico Redragon', 279.90, 30, 3, 2),
    ('SSD Kingston 480GB', 189.90, 40, 2, 1);

INSERT INTO movimentacao (tipo, quantidade, id_produto) VALUES
    ('entrada', 10, 1),
    ('entrada', 20, 2),
    ('saida', 5, 1),
    ('saida', 10, 2);
