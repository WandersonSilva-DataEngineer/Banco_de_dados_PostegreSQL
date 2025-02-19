
-- Exemplo Prático de MVCC no PostgreSQL

-- Criação da tabela de exemplo
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome TEXT NOT NULL
);

-- Inserindo um registro inicial
INSERT INTO clientes (nome) VALUES ('João Antigo');

-- Transação A: Lê os dados
BEGIN;
SELECT * FROM clientes WHERE id = 1;

-- Transação B: Atualiza os dados
BEGIN;
UPDATE clientes SET nome = 'João Novo' WHERE id = 1;
COMMIT;

-- Transação A: Lê novamente
SELECT * FROM clientes WHERE id = 1;
COMMIT;

-- Verificando o resultado final
SELECT * FROM clientes;

-- Limpeza (opcional)
DROP TABLE clientes;