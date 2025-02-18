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

Para facilitar a consulta das configurações atuais do PostgreSQL, disponibilizamos alguns comandos SQL prontos para uso. Esses comandos estão disponíveis no arquivo `Comandos PSQL/consultas_configuracoes.sql`.

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

### Como Usar
#### Clone este repositório:
- git clone https://github.com/seu-usuario/postgresql-configurations.git
#### Execute os comandos SQL no terminal do PostgreSQL:
- psql -U seu_usuario -d seu_banco -f Comandos\ PSQL/consultas_configuracoes.sql
#### Consulte os exemplos de arquivos de configuração na pasta Exemplos/ para personalizar suas configurações.