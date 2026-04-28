-- ============================================================
-- TESTES DE INTEGRIDADE
-- ============================================================

-- ------------------------------------------------------------
-- 5.1 INSERÇÕES VÁLIDAS
-- ------------------------------------------------------------

-- Cadastro de categorias
INSERT INTO categoria (nome) VALUES ('Eletronicos');
INSERT INTO categoria (nome) VALUES ('Informatica');
INSERT INTO categoria (nome) VALUES ('Perifericos');

-- Cadastro de fornecedores
INSERT INTO fornecedor (nome, contato) VALUES ('TechSupply Ltda', 'techsupply@email.com');
INSERT INTO fornecedor (nome, contato) VALUES ('InfoParts S.A.', 'contato@infoparts.com');
INSERT INTO fornecedor (nome, contato) VALUES ('MegaComp Dist.', 'vendas@megacomp.com');

-- Cadastro de produtos
INSERT INTO produto (nome, preco, quantidade, id_categoria, id_fornecedor)
VALUES ('Notebook Dell Inspiron', 3499.90, 15, 2, 1);

INSERT INTO produto (nome, preco, quantidade, id_categoria, id_fornecedor)
VALUES ('Mouse Logitech MX Master', 349.90, 50, 3, 2);

INSERT INTO produto (nome, preco, quantidade, id_categoria, id_fornecedor)
VALUES ('Monitor Samsung 24', 1299.00, 20, 1, 3);

INSERT INTO produto (nome, preco, quantidade, id_categoria, id_fornecedor)
VALUES ('Teclado Mecanico Redragon', 279.90, 30, 3, 2);

INSERT INTO produto (nome, preco, quantidade, id_categoria, id_fornecedor)
VALUES ('SSD Kingston 480GB', 189.90, 40, 2, 1);

-- Updates
UPDATE produto SET preco = 3299.90 WHERE id_produto = 1;
UPDATE fornecedor SET contato = 'novo@techsupply.com.br' WHERE id_fornecedor = 1;
UPDATE categoria SET nome = 'Computadores' WHERE id_categoria = 2;

-- ------------------------------------------------------------
-- 5.2 TESTES DE ERRO (executar separadamente)
-- ------------------------------------------------------------

-- Produto com preço negativo (esperado: erro CHECK)
-- EXECUTAR SEPARADAMENTE
-- INSERT INTO produto (nome, preco, quantidade, id_categoria, id_fornecedor)
-- VALUES ('Produto Invalido', -50.00, 10, 1, 1);

-- Produto sem nome (esperado: erro NOT NULL)
-- EXECUTAR SEPARADAMENTE
-- INSERT INTO produto (nome, preco, quantidade, id_categoria, id_fornecedor)
-- VALUES (NULL, 199.90, 5, 1, 1);

-- ------------------------------------------------------------
-- 5.3 TESTES DE MOVIMENTAÇÃO
-- ------------------------------------------------------------

-- Entrada de estoque (esperado: sucesso e aumento do estoque)
INSERT INTO movimentacao (tipo, quantidade, id_produto) VALUES ('entrada', 10, 1);
INSERT INTO movimentacao (tipo, quantidade, id_produto) VALUES ('entrada', 20, 2);

-- Saída de estoque válida (esperado: sucesso e redução do estoque)
INSERT INTO movimentacao (tipo, quantidade, id_produto) VALUES ('saida', 5, 1);
INSERT INTO movimentacao (tipo, quantidade, id_produto) VALUES ('saida', 10, 2);

-- Saída com estoque insuficiente (esperado: erro da trigger)
-- EXECUTAR SEPARADAMENTE
-- INSERT INTO movimentacao (tipo, quantidade, id_produto) VALUES ('saida', 999, 1);

-- ------------------------------------------------------------
-- CONSULTAS DE VERIFICAÇÃO
-- ------------------------------------------------------------

-- Estoque atual por produto
SELECT p.id_produto, p.nome, p.preco, p.quantidade,
       c.nome AS categoria, f.nome AS fornecedor
FROM produto p
JOIN categoria c ON p.id_categoria = c.id_categoria
LEFT JOIN fornecedor f ON p.id_fornecedor = f.id_fornecedor;

-- Histórico de movimentações
SELECT m.id_movimentacao, p.nome AS produto,
       m.tipo, m.quantidade, m.data_mov
FROM movimentacao m
JOIN produto p ON m.id_produto = p.id_produto
ORDER BY m.data_mov DESC;

-- ============================================================
-- FIM DOS TESTES
-- ============================================================