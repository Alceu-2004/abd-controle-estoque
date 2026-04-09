-- ============================================================
-- ESTRUTURA DO BANCO DE DADOS
-- ============================================================

DROP DATABASE IF EXISTS controle_estoque;
CREATE DATABASE controle_estoque;
USE controle_estoque;

CREATE DATABASE IF NOT EXISTS controle_estoque
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE controle_estoque;

-- TABELA: Categoria
DROP TABLE IF EXISTS categoria;
CREATE TABLE categoria (
  id_categoria INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_categoria),
  UNIQUE (nome)
);

-- TABELA: Fornecedor
DROP TABLE IF EXISTS fornecedor;
CREATE TABLE fornecedor (
  id_fornecedor INT NOT NULL AUTO_INCREMENT,
  nome VARCHAR(150) NOT NULL,
  contato VARCHAR(100),
  PRIMARY KEY (id_fornecedor)
);

-- TABELA: Produto
DROP TABLE IF EXISTS produto;
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

-- TABELA: Movimentacao
DROP TABLE IF EXISTS movimentacao;
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