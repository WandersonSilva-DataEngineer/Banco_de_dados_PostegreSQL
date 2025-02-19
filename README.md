# Configurações do PostgreSQL

Este repositório contém informações e exemplos sobre os principais arquivos de configuração do PostgreSQL, bem como comandos úteis para consultar e ajustar as configurações do banco de dados.

## Arquivos de Configuração

1. **postgresql.conf**
   - Este é o arquivo principal de configuração do PostgreSQL. Ele contém parâmetros que controlam o comportamento global do servidor, como conexões, memória, cache e muito mais.
   - Localização padrão: `/etc/postgresql/<version>/main/postgresql.conf` (Linux) ou `C:\Program Files\PostgreSQL\<version>\data\postgresql.conf` (Windows).

2. **pg_hba.conf**
   - Controla a autenticação e as permissões de acesso ao banco de dados. Define quem pode se conectar ao servidor e como (por exemplo, via senha, certificado, etc.).
   - Localização padrão: Mesmo diretório do `postgresql.conf`.

3. **pg_ident.conf**
   - Mapeia nomes de usuários do sistema operacional para usuários do PostgreSQL. Útil para autenticação baseada em identidade.
   - Localização padrão: Mesmo diretório do `postgresql.conf`.

## Consultas Úteis

Para facilitar a consulta das configurações atuais do PostgreSQL, disponibilizamos alguns comandos SQL prontos para uso. Esses comandos estão disponíveis no arquivo `Comandos PLpgSQL/consultas_configuracoes.sql`.

- **Consultar parâmetros específicos**:
  - O comando abaixo lista parâmetros importantes, como `listen_addresses`, `max_connections`, `shared_buffers`, etc., organizados por contexto.
  
- **Consultar localizações de arquivos**:
  - O segundo comando lista os caminhos dos arquivos de configuração usados pelo PostgreSQL.

## Explicação dos Comandos
### Consulta de Parâmetros Específicos :
- O primeiro comando (pg_settings) permite verificar os valores atuais de parâmetros importantes, como listen_addresses (endereços de escuta), max_connections (número máximo de conexões), e outros relacionados à memória (shared_buffers, work_mem, etc.).
- Os campos boot_val e reset_val mostram os valores padrão e os valores após o último reset, respectivamente.
### Consulta de Localizações de Arquivos :
- O segundo comando lista os caminhos dos arquivos de configuração usados pelo PostgreSQL, como postgresql.conf, pg_hba.conf e pg_ident.conf.

# Comandos Básicos do PostgreSQL

Este repositório contém uma lista abrangente de **comandos básicos do PostgreSQL**, organizados por categorias, como conexão e navegação, criação de bancos de dados, manipulação de tabelas, usuários, esquemas, privilégios, tablespaces, backup e restauração, atualização de versão e manipulação de instâncias. Esses comandos estão disponíveis no arquivo `Comandos PLpgSQL/Comandos_básicos_PLSQL.sql`.

## O Que Está Incluído?

1. **Conexão e Navegação**
   - Comandos para conectar-se a bancos de dados, listar tabelas, usuários e outros recursos.

2. **Gerenciamento de Conexões**
   - Comandos para listar e encerrar conexões ativas, além de habilitar/desabilitar o autocommit.

3. **Criação de Banco de Dados**
   - Comandos para criar, excluir e alterar o proprietário de bancos de dados.

4. **Usuários e Esquemas**
   - Comandos para criar, alterar e excluir usuários e esquemas, além de modificar seus proprietários.

5. **Privilégios**
   - Comandos para conceder e revogar privilégios em bancos de dados e tabelas.

6. **Manipulação de Tabelas**
   - Comandos para criar, alterar e excluir tabelas, além de inserir, consultar, atualizar e excluir registros.

7. **Índices e Views**
   - Comandos para criar e excluir índices e views.

8. **Sequências**
   - Comandos para criar, usar e excluir sequências.

9. **Gerenciamento de Armazenamento em Disco (Tablespaces)**
   - Comandos para criar, alterar e excluir tablespaces, além de mover tabelas para tablespaces específicos.

10. **Uso do Comando ALTER SYSTEM**
    - Comandos para alterar parâmetros globais diretamente no `postgresql.conf` e recarregar as configurações.

11. **Backup e Restauração**
    - Comandos para realizar backups e restaurar bancos de dados usando ferramentas como `pg_dump` e `psql`.

12. **Atualização de Versão do PostgreSQL**
    - Passos para verificar a versão atual e realizar a atualização do PostgreSQL.

13. **Manipulação de Instâncias PostgreSQL no Mesmo Host**
    - Comandos para iniciar, parar e verificar o status de instâncias PostgreSQL, além de criar novas instâncias e configurar portas diferentes.

14. **Transações**
    - Comandos para controlar transações manualmente, incluindo início, confirmação e reversão.

15. **Monitoramento e Estatísticas**
    - Comandos para verificar o tamanho de tabelas e bancos de dados.

## Como Usar Este Repositório

1. **Clone o Repositório**
   ```bash
   git clone https://github.com/seu-usuario/postgresql-configurations.git

## Público-Alvo
### Este conteúdo foi criado para:

- Desenvolvedores iniciantes que estão começando a trabalhar com PostgreSQL.
- Profissionais experientes que desejam ter uma referência rápida para comandos básicos e avançados.
- Administradores de banco de dados que precisam de um guia prático para tarefas diárias.