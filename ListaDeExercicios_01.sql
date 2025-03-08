#reproduzindo a base de dados

create database db_loja;
use db_loja;

CREATE TABLE categorias (
    id INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE produtos (
    id INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10 , 2 ) NOT NULL,
    id_categoria INT(11)
);

CREATE TABLE itens_pedido (
    id_pedido INT(11) NOT NULL,
    id_produto INT(11) NOT NULL,
    qantidade INT(11)
);

CREATE TABLE pedidos (
    id INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    data_pedido DATETIME NOT NULL,
    id_cliente INT(11) NOT NULL
);

CREATE TABLE clientes (
    id INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
);

#inserindo a nova categoria 'Eletrônicos'
insert into categorias (nome) values ('Eletrônicos');

#listando todas as categorias
select * from categorias;

#inserindo dois produtos na categoria 'Eletronicos'
insert into produtos (nome, descricao, preco, id_categoria)
values
	('Smartfone', 'Celular de útima geração!', 3000.00, (select id from categorias where nome = 'Eletrônicos')),
    ('Smart TV', 'Televisão smart de alta definição!', 4000.00, (select id from categorias where nome = 'Eletrônicos'));
    
#listando os produtos da categoria 'Eletrônicos'
select * from produtos
where id_categoria = (select id from categorias where nome = 'Eletrônicos');

INSERT INTO clientes (nome, email) VALUES ('João Silva', 'joao.silva@gmail.com');

SELECT * FROM clientes;

INSERT INTO pedidos (id_cliente)
VALUES ((SELECT id FROM clientes WHERE nome = 'João Silva'));

SELECT * FROM pedidos;

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade)
VALUES (
    (SELECT id FROM pedidos WHERE id_cliente = (SELECT id FROM clientes WHERE nome = 'João Silva') ORDER BY id DESC LIMIT 1),
    (SELECT id FROM produtos WHERE nome = 'Smartphone'),
    2
);

SELECT * FROM itens_pedido;

SELECT * FROM itens_pedido;

INSERT INTO categorias (nome) VALUES ('Livros'), ('Jogos'), ('Roupas');

INSERT INTO produtos (nome, descricao, preco, id_categoria)
VALUES (
    'Camiseta',
    'Camiseta de qualidade',
    59.90,
    (SELECT id FROM categorias WHERE nome = 'Roupas')
);

INSERT INTO clientes (nome, email) VALUES ('Maria Oliveira', 'maria.oliveira@gmail.com');

INSERT INTO pedidos (id_cliente)
VALUES ((SELECT id FROM clientes WHERE nome = 'Maria Oliveira'));

-- Adiciona 1 Smart TV
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade)
VALUES (
    (SELECT id FROM pedidos WHERE id_cliente = (SELECT id FROM clientes WHERE nome = 'Maria Oliveira') ORDER BY id DESC LIMIT 1),
    (SELECT id FROM produtos WHERE nome = 'Smart TV'),
    1
);

-- Adiciona 1 Camiseta
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade)
VALUES (
    (SELECT id FROM pedidos WHERE id_cliente = (SELECT id FROM clientes WHERE nome = 'Maria Oliveira') ORDER BY id DESC LIMIT 1),
    (SELECT id FROM produtos WHERE nome = 'Camiseta'),
    1
);

INSERT INTO categorias (nome) VALUES ('Acessórios');

INSERT INTO produtos (nome, descricao, preco, id_categoria)
VALUES (
    'Capa para Smartphone',
    'Capa protetora para smartphone',
    79.90,
    (SELECT id FROM categorias WHERE nome = 'Acessórios')
);

SELECT * FROM produtos
WHERE id_categoria = (SELECT id FROM categorias WHERE nome = 'Eletrônicos');

SELECT p.*
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id
WHERE c.nome = 'Maria Oliveira';

SELECT * FROM produtos
WHERE preco > 1000;

SELECT *
FROM produtos p
WHERE NOT EXISTS (
    SELECT 1 FROM itens_pedido ip WHERE ip.id_produto = p.id
);

SELECT ip.id_pedido, COUNT(DISTINCT ip.id_produto) AS tipos_produtos
FROM itens_pedido ip
GROUP BY ip.id_pedido
HAVING tipos_produtos > 1;

SELECT p.*, c.nome AS categoria
FROM produtos p
JOIN categorias c ON p.id_categoria = c.id;

SELECT c.nome, c.email, COUNT(p.id) AS total_pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.id_cliente
GROUP BY c.id
ORDER BY total_pedidos DESC;

SELECT nome, preco, (preco / 1.1) AS preco_em_euros
FROM produtos;

SELECT * FROM produtos
WHERE nome LIKE 'S%';