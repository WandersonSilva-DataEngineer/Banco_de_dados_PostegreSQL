# Guia de Backup e Restore no PostgreSQL

Este guia detalha os métodos de backup e restauração no PostgreSQL, incluindo exemplos práticos e explicações 
claras. Também aborda a automação de backups no Linux e ferramentas avançadas como PgBackRest , PITR (Point-in-Time Recovery) e Barman .

---

## 1. Comandos de Backup com pg_dump
O comando pg_dump é uma ferramenta poderosa para realizar backups lógicos de tabelas ou bancos de dados inteiros. Abaixo estão exemplos e explicações de cada opção:

### Backup Completo em Formato Tar
bash

        pg_dump -h localhost -p 5432 -U postgres -W -F t meudb_admin > meudb_admin.tar

- -h localhost: Especifica o host do banco de dados.
- -p 5432: Porta do PostgreSQL.
- -U postgres: Usuário para autenticação.
- -W: Solicita a senha do usuário.
- -F t: Formato do backup (tar).
- meudb_admin: Nome do banco de dados.
- "> meudb_admin.tar": Redireciona a saída para um arquivo tar.

*Explicação :* Este comando cria um backup completo do banco de dados meudb_admin no formato tar.

### Backup de Tabelas Específicas
bash

        pg_dump -h localhost -p 5432 -U postgres -F c -b -v -t *.pagar* -f pagar.backup meudb_admin

Explicação :  

        -h localhost: Especifica o host do banco de dados.
        -F c: Formato personalizado (compactado).
        -b: Inclui blobs grandes.
        -v: Modo verboso (detalhes da operação).
        -t *.pagar*: Faz backup apenas das tabelas que correspondem ao padrão *.pagar*.
        -f pagar.backup: Salva o backup no arquivo pagar.backup.

Este comando faz backup apenas das tabelas relacionadas ao padrão *.pagar* no banco de dados meudb_admin.

### Backup Excluindo Schema Público
bash

        pg_dump -h localhost -p 5432 -U postgres -F c -b -v -N public -f all_sch_except_pub.backup meudb_admin

- -N public: Exclui o schema público do backup.

Explicação : Este comando cria um backup excluindo o schema public.

### Backup com Inserts Explícitos
bash

        pg_dump -h localhost -p 5432 -U postgres -F p --column-inserts -f select_tables.backup meudb_admin

- -F p: Formato texto plano (SQL).
- --column-inserts: Gera instruções INSERT explícitas para cada linha.

Explicação : Este comando gera um backup SQL com instruções INSERT, útil para restaurações incrementais.

### Backup Paralelo
bash


        pg_dump -h localhost -p 5432 -U postgres -j 3 -Fd -f algumdiretorio/ meudb_admin

- -j 3: Usa 3 processos paralelos.
- -Fd: Formato diretório (suporta backups paralelos).

Explicação : Este comando realiza um backup paralelo em formato de diretório.

### Backup Global (pg_dumpall)
bash

        pg_dumpall -h localhost -U postgres --port=5432 -f myglobals.sql --globals-only

- --globals-only: Faz backup apenas dos objetos globais (roles, tablespaces, etc.).

Explicação : Este comando salva as configurações globais do cluster PostgreSQL.

---

## 2. Métodos de Restauração

### Restauração com psql
bash

        psql -U username -f backupfile.sql

- -U username: Usuário para autenticação.
- -f backupfile.sql: Arquivo SQL contendo o backup.

Explicação : Este comando restaura um backup SQL no banco de dados especificado.

### Restauração com pg_restore
bash

        pg_restore --verbose --clean --no-acl --no-owner --host localhost -U postgres --dbname meudb_admin meudb_admin.tar

- --verbose: Mostra detalhes da restauração.
- --clean: Remove objetos existentes antes da restauração.
- --no-acl: Ignora permissões.
- --no-owner: Define o proprietário atual como dono dos objetos restaurados.

Explicação : Este comando restaura um backup no formato tar ou personalizado.

### Restauração com Criação de Banco de Dados
bash

        pg_restore -h localhost -p 5432 --list -U postgres --dbname=postgres --create --verbose meudb_admin.tar

- --create: Cria automaticamente o banco de dados durante a restauração.

Explicação : Este comando restaura o backup e cria o banco de dados se ele não existir.

## 3. Automação de Backups no Linux

### Script Básico de Backup

Crie um script chamado pg_backup.sh:

bash

        #!/bin/bash
        DATA=$(date +%Y%m%d)
        pg_dump -U postgres -d meudb_admin -F c -b -v -f /backups/meudb_admin_$DATA.backup

- DATA=$(date +%Y%m%d): Captura a data atual.
- -F c: Formato personalizado.
- -b: Inclui blobs grandes.
- -v: Modo verboso.
- -f: Salva o backup em /backups/.

#### Execução Automática :
Adicione ao cron:

bash
        crontab -e
        0 2 * * * /caminho/para/pg_backup.sh

- Executa o backup diariamente às 2h.

### Script com Rotação de Backups
Crie um script chamado pg_backup_rotated.sh:

bash
Copy
1
2
3
4
#!/bin/bash
DATA=$(date +%Y%m%d)
find /backups -type f -mtime +7 -exec rm {} \;
pg_dump -U postgres -d meudb_admin -F c -b -v -f /backups/meudb_admin_$DATA.backup
find /backups -type f -mtime +7 -exec rm {} \;: Remove backups com mais de 7 dias.
Explicação : Este script realiza backups diários e remove arquivos antigos.

4. Ferramentas Avançadas
PgBackRest
O PgBackRest é uma ferramenta robusta para backups e restaurações incrementais.

Configuração
Instale o PgBackRest:
bash
Copy
1
sudo apt install pgbackrest
Configure o arquivo /etc/pgbackrest.conf:
ini
Copy
1
2
3
4
5
6
[global]
repo1-path=/var/lib/pgbackrest
repo1-retention-full=2

[meudb_admin]
pg1-path=/var/lib/postgresql/data
Execute o backup:
bash
Copy
1
pgbackrest --stanza=meudb_admin --type=full backup
Restauração
bash
Copy
1
pgbackrest --stanza=meudb_admin --type=time "--target=2023-10-01 12:00:00" restore
Point-in-Time Recovery (PITR)
O PITR permite restaurar o banco de dados até um ponto específico no tempo.

Configuração
Habilite o WAL Archiving no postgresql.conf:
conf
Copy
1
2
3
wal_level = replica
archive_mode = on
archive_command = 'cp %p /caminho/para/wal/%f'
Realize um backup base:
bash
Copy
1
pg_basebackup -U postgres -D /caminho/para/backup --wal-method=stream
Configure o arquivo recovery.conf:
conf
Copy
1
2
restore_command = 'cp /caminho/para/wal/%f %p'
recovery_target_time = '2023-10-01 12:00:00'
Barman
O Barman é uma ferramenta externa para gerenciamento centralizado de backups.

Configuração
Instale o Barman:
bash
Copy
1
sudo apt install barman
Configure o arquivo /etc/barman.conf:
ini
Copy
1
2
3
4
[meudb_admin]
description = "Backup do meu banco"
conninfo = host=localhost user=postgres dbname=meudb_admin
backup_method = postgres
Execute o backup:
bash
Copy
1
barman backup meudb_admin
Restauração:
bash
Copy
1
barman recover meudb_admin latest /var/lib/postgresql/data
Conclusão
Este guia apresenta métodos de backup e restauração no PostgreSQL, desde comandos básicos até ferramentas avançadas como PgBackRest , PITR e Barman . Use essas informações para implementar estratégias eficientes de backup e garantir a segurança dos seus dados.