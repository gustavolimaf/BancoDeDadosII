create database db_loja;

use db_loja;

CREATE TABLE categorias (
    id INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE produtos (
    id INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2),
    id_categoria INT(11),
    PRIMARY KEY (id),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id)
);

CREATE TABLE clientes (
    id INT(11) NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE pedidos (
    id INT(11) NOT NULL AUTO_INCREMENT,
    data_pedido DATETIME NOT NULL,	
    id_cliente INT(11),
    PRIMARY KEY (id),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id)
);

CREATE TABLE itens_pedido (
    id_pedido INT(11) NOT NULL,
    id_produto INT(11) NOT NULL,
    quantidade INT(11) NOT NULL,
    PRIMARY KEY (id_pedido, id_produto),
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id),
    FOREIGN KEY (id_produto) REFERENCES produtos(id)
);

-- 2. Inserir categoria "Eletrônicos"
INSERT INTO categorias (nome) VALUES ('Eletrônicos');

-- 2.1. Listar categorias
SELECT * FROM categorias;

-- 3. Adicionar produtos na categoria "Eletrônicos"
INSERT INTO produtos (nome, descricao, preco, id_categoria) VALUES 
('Smartphone', 'Smartphone de última geração', 1200.00, (SELECT id FROM categorias WHERE nome = 'Eletrônicos')),
('Smart TV', 'Televisão 4K de 48 polegadas', 3000.00, (SELECT id FROM categorias WHERE nome = 'Eletrônicos'));

-- 3.1. Listar produtos da categoria "Eletrônicos" (CORREÇÃO: produtos, não categorias)
SELECT p.* 
FROM produtos p
INNER JOIN categorias c ON p.id_categoria = c.id
WHERE c.nome = 'Eletrônicos';

-- 4. Registrar cliente "João Silva" (CORREÇÃO: email completo e nome correto)
INSERT INTO clientes (nome, email) 
VALUES ('João Silva', 'joao.silva@gmail.com');  -- Corrigido "gamil.com" para "gmail.com"

-- 4.1. Listar clientes
SELECT * FROM clientes;

-- 5. Criar pedido para João Silva
INSERT INTO pedidos (data_pedido, id_cliente) 
VALUES (NOW(), (SELECT id FROM clientes WHERE nome = 'João Silva'));

-- 5.1. Listar pedidos
SELECT * FROM pedidos;

-- 6. Adicionar 2 Smartphones ao pedido de João Silva
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade) 
VALUES (
    (SELECT id FROM pedidos WHERE id_cliente = (SELECT id FROM clientes WHERE nome = 'João Silva') ORDER BY id DESC LIMIT 1),
    (SELECT id FROM produtos WHERE nome = 'Smartphone'),
    2
);

-- 6.1. Listar itens do pedido (CORREÇÃO: junção com tabela produtos)
SELECT ip.id_pedido, p.nome AS produto, ip.quantidade 
FROM itens_pedido ip
INNER JOIN produtos p ON ip.id_produto = p.id;

-- 7. Inserir três categorias
INSERT INTO categorias (nome) VALUES ('Livros'), ('Jogos'), ('Roupas');

-- 8. Adicionar "Camiseta" em "Roupas"
INSERT INTO produtos (nome, descricao, preco, id_categoria) 
VALUES ('Camiseta', 'Camiseta de algodão', 59.90, (SELECT id FROM categorias WHERE nome = 'Roupas'));

-- 9. Registrar "Maria Oliveira" (CORREÇÃO: adicionar email)
INSERT INTO clientes (nome, email) 
VALUES ('Maria Oliveira', 'maria.oliveira@gmail.com');  -- Email adicionado

-- 10. Criar pedido para Maria Oliveira (CORREÇÃO: adicionar dois itens)
-- Primeiro cria o pedido
INSERT INTO pedidos (data_pedido, id_cliente) 
VALUES (NOW(), (SELECT id FROM clientes WHERE nome = 'Maria Oliveira'));

-- Depois insere os itens
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade) 
VALUES 
    ((SELECT id FROM pedidos WHERE id_cliente = (SELECT id FROM clientes WHERE nome = 'Maria Oliveira') ORDER BY id DESC LIMIT 1),
    (SELECT id FROM produtos WHERE nome = 'Smart TV'), 1),
    
    ((SELECT id FROM pedidos WHERE id_cliente = (SELECT id FROM clientes WHERE nome = 'Maria Oliveira') ORDER BY id DESC LIMIT 1),
    (SELECT id FROM produtos WHERE nome = 'Camiseta'), 1);

-- 11. Adicionar categoria e produto (CORREÇÃO: usar transação para atomicidade)
START TRANSACTION;
INSERT INTO categorias (nome) VALUES ('Acessórios');
INSERT INTO produtos (nome, descricao, preco, id_categoria) 
VALUES ('Capa para Smartphone', 'Capa protetora para smartphone', 49.90, LAST_INSERT_ID());
COMMIT;

-- 12. Produtos de Eletrônicos
SELECT p.* 
FROM produtos p
INNER JOIN categorias c ON p.id_categoria = c.id
WHERE c.nome = 'Eletrônicos';

-- 13. Pedidos de Maria Oliveira
SELECT ped.* 
FROM pedidos ped
INNER JOIN clientes cli ON ped.id_cliente = cli.id
WHERE cli.nome = 'Maria Oliveira';

-- 14. Produtos acima de R$ 1000
SELECT * FROM produtos WHERE preco > 1000;

-- 15. Produtos nunca pedidos
SELECT p.* 
FROM produtos p
LEFT JOIN itens_pedido ip ON p.id = ip.id_produto
WHERE ip.id_produto IS NULL;

-- 16. Pedidos com múltiplos produtos
SELECT ped.* 
FROM pedidos ped
WHERE (SELECT COUNT(DISTINCT id_produto) FROM itens_pedido WHERE id_pedido = ped.id) > 1;

-- 17. Produtos com suas categorias
SELECT p.nome AS produto, c.nome AS categoria 
FROM produtos p
INNER JOIN categorias c ON p.id_categoria = c.id;

-- 18. Clientes e total de pedidos
SELECT cli.nome, COUNT(ped.id) AS total_pedidos
FROM clientes cli
LEFT JOIN pedidos ped ON cli.id = ped.id_cliente
GROUP BY cli.id
ORDER BY total_pedidos DESC;

-- 19. Preço em Euros (CORREÇÃO: usar divisão correta)
SELECT nome, preco, ROUND(preco / 1.1, 2) AS preco_em_euros 
FROM produtos;

-- 20. Produtos começando com "S"
SELECT * FROM produtos WHERE nome LIKE 'S%';
