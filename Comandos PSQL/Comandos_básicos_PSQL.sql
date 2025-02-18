-- ==============================
-- Comandos Básicos do PostgreSQL
-- ==============================

-- ==============================
-- Conexão e Navegação
-- ==============================

-- Conectar ao banco de dados
-- Substitua 'nome_do_banco' pelo nome do banco que deseja acessar.
\c nome_do_banco

-- Listar todos os bancos de dados disponíveis
\l

-- Listar todas as tabelas no banco de dados atual
\dt

-- Verificar o esquema de uma tabela
\d nome_da_tabela

-- Listar todos os usuários (roles)
\du

-- Descrever os detalhes de uma função ou procedimento
\df nome_da_funcao

-- Limpar a tela do terminal no psql
\! clear

-- Sair do psql
\q

-- Executar um script SQL externo
\i caminho/para/arquivo.sql

-- ==============================
-- Gerenciamento de Conexões
-- ==============================

-- Listar todas as conexões ativas no banco de dados
SELECT * FROM pg_stat_activity;

-- Encerrar uma conexão específica
-- Substitua 'pid' pelo ID do processo da conexão que deseja encerrar.
SELECT pg_terminate_backend(pid);

-- Habilitar/desabilitar autocommit
-- Por padrão, o autocommit está habilitado. Para desabilitar:
\set AUTOCOMMIT off

-- ==============================
-- Criação de Banco de Dados
-- ==============================

-- Criar um novo banco de dados
CREATE DATABASE nome_do_banco;

-- Excluir um banco de dados
DROP DATABASE nome_do_banco;

-- Alterar o proprietário de um banco de dados
ALTER DATABASE nome_do_banco OWNER TO novo_proprietario;

-- ==============================
-- Usuários e Esquemas
-- ==============================

-- Criar um novo usuário (role)
CREATE USER nome_do_usuario WITH PASSWORD 'senha_segura';

-- Alterar a senha de um usuário
ALTER USER nome_do_usuario WITH PASSWORD 'nova_senha_segura';

-- Excluir um usuário
DROP USER nome_do_usuario;

-- Criar um novo esquema
CREATE SCHEMA nome_do_esquema;

-- Alterar o proprietário de um esquema
ALTER SCHEMA nome_do_esquema OWNER TO novo_proprietario;

-- Excluir um esquema
DROP SCHEMA nome_do_esquema CASCADE;

-- ==============================
-- Privilégios
-- ==============================

-- Conceder todos os privilégios em um banco de dados para um usuário
GRANT ALL PRIVILEGES ON DATABASE nome_do_banco TO nome_do_usuario;

-- Revogar todos os privilégios de um usuário em um banco de dados
REVOKE ALL PRIVILEGES ON DATABASE nome_do_banco FROM nome_do_usuario;

-- Conceder privilégios em uma tabela para um usuário
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE nome_da_tabela TO nome_do_usuario;

-- Revogar privilégios em uma tabela de um usuário
REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLE nome_da_tabela FROM nome_do_usuario;

-- ==============================
-- Manipulação de Tabelas
-- ==============================

-- Criar uma nova tabela
-- Exemplo: Criar uma tabela chamada 'usuarios' com três colunas.
CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Excluir uma tabela
DROP TABLE nome_da_tabela;

-- Alterar o proprietário de uma tabela
ALTER TABLE nome_da_tabela OWNER TO novo_proprietario;

-- Inserir dados em uma tabela
INSERT INTO usuarios (nome, email) VALUES ('João Silva', 'joao@example.com');

-- Consultar todos os registros de uma tabela
SELECT * FROM usuarios;

-- Atualizar registros em uma tabela
UPDATE usuarios SET email = 'joao.silva@example.com' WHERE id = 1;

-- Excluir registros de uma tabela
DELETE FROM usuarios WHERE id = 1;

-- ==============================
-- Índices e Views
-- ==============================

-- Criar um índice em uma coluna para melhorar a performance
CREATE INDEX idx_nome_da_coluna ON nome_da_tabela (nome_da_coluna);

-- Excluir um índice
DROP INDEX idx_nome_da_coluna;

-- Criar uma view (visão)
CREATE VIEW nome_da_view AS SELECT * FROM usuarios WHERE email LIKE '%@example.com';

-- Excluir uma view
DROP VIEW nome_da_view;

-- ==============================
-- Sequências
-- ==============================

-- Criar uma sequência (sequence)
CREATE SEQUENCE nome_da_sequencia START 1;

-- Usar uma sequência para gerar valores incrementais
SELECT nextval('nome_da_sequencia');

-- Excluir uma sequência
DROP SEQUENCE nome_da_sequencia;

-- ==============================
-- Gerenciamento de Armazenamento em Disco (Tablespaces)
-- ==============================

-- Criar um tablespace
CREATE TABLESPACE nome_do_tablespace LOCATION '/caminho/para/diretorio';

-- Alterar o proprietário de um tablespace
ALTER TABLESPACE nome_do_tablespace OWNER TO novo_proprietario;

-- Excluir um tablespace
DROP TABLESPACE nome_do_tablespace;

-- Mover uma tabela para um tablespace específico
ALTER TABLE nome_da_tabela SET TABLESPACE nome_do_tablespace;

-- ==============================
-- Uso do Comando ALTER SYSTEM
-- ==============================

-- Alterar um parâmetro global diretamente no postgresql.conf
-- Exemplo: Alterar o número máximo de conexões
ALTER SYSTEM SET max_connections = 200;

-- Recarregar as configurações após alterações com ALTER SYSTEM
SELECT pg_reload_conf();

-- ==============================
-- Backup e Restauração
-- ==============================

-- Executar um backup de um banco de dados
-- Execute este comando no terminal, não no psql.
-- pg_dump -U nome_do_usuario -d nome_do_banco -f backup.sql

-- Restaurar um backup de um banco de dados
-- Execute este comando no terminal, não no psql.
-- psql -U nome_do_usuario -d nome_do_banco -f backup.sql

-- ==============================
-- Atualizar Versão do PostgreSQL
-- ==============================

-- Verificar a versão atual do PostgreSQL
SHOW server_version;

-- Atualizar o PostgreSQL (executar no terminal, não no psql)
-- 1. Faça backup do banco de dados:
--    pg_dumpall -U postgres > backup.sql
-- 2. Instale a nova versão do PostgreSQL.
-- 3. Restaure o backup na nova instância:
--    psql -U postgres -f backup.sql

-- ==============================
-- Manipulação de Instâncias PostgreSQL no Mesmo Host
-- ==============================

-- Iniciar uma instância PostgreSQL específica
pg_ctl -D /caminho/para/diretorio/data start

-- Parar uma instância PostgreSQL específica
pg_ctl -D /caminho/para/diretorio/data stop

-- Verificar o status de uma instância PostgreSQL
pg_ctl -D /caminho/para/diretorio/data status

-- Criar uma nova instância PostgreSQL
initdb -D /caminho/para/nova_instancia/data

-- Configurar portas diferentes para várias instâncias
-- Edite o arquivo postgresql.conf de cada instância:
-- listen_addresses = '*'
-- port = 5433 (ou outra porta disponível)

-- ==============================
-- Transações
-- ==============================

-- Iniciar uma transação manualmente
BEGIN;

-- Confirmar uma transação
COMMIT;

-- Reverter uma transação
ROLLBACK;

-- ==============================
-- Monitoramento e Estatísticas
-- ==============================

-- Verificar o tamanho de uma tabela
SELECT pg_size_pretty(pg_total_relation_size('nome_da_tabela'));

-- Verificar o tamanho total de um banco de dados
SELECT pg_size_pretty(pg_database_size('nome_do_banco'));