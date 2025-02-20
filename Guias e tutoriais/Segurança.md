# Segurança no PostgreSQL

Este guia aborda as melhores práticas de segurança para proteger seu banco de dados PostgreSQL. Ele inclui exemplos práticos de como configurar autenticação segura, restringir permissões, auditar alterações e proteger dados confidenciais.

---

## 1. Autenticação Remota e Segura com SSL
### Por que é importante?

A autenticação remota sem criptografia pode expor senhas e dados sensíveis durante a transmissão. O uso de SSL/TLS garante que as conexões sejam criptografadas.

### Como configurar:
1- Habilite SSL no PostgreSQL :
- Edite o arquivo postgresql.conf:
    
        ssl = on
    
        ssl_cert_file = 'server.crt'
    
        ssl_key_file = 'server.key'

2- Configure o pg_hba.conf para exigir SSL :
- Adicione uma entrada para forçar conexões seguras:

        hostssl all all 0.0.0.0/0 md5

3- Teste a conexão SSL :
- Use o cliente psql para conectar-se com SSL:

        psql "host=meu-servidor dbname=minha_base user=usuario sslmode=require"

---

## 2. Introdução à Segurança - Restrições a Usuários
### Por que é importante?

Restringir permissões minimiza os riscos de acesso não autorizado ou alterações acidentais.

### Como configurar:

1- Crie usuários com privilégios mínimos :

        CREATE ROLE leitor LOGIN PASSWORD 'senha_segura';

        GRANT CONNECT ON DATABASE minha_base TO leitor;

        GRANT SELECT ON ALL TABLES IN SCHEMA public TO leitor;

2- Revogue permissões desnecessárias :

        REVOKE ALL ON DATABASE minha_base FROM PUBLIC;

3- Use roles hierárquicas :

        CREATE ROLE admin;

        GRANT admin TO leitor;

## 3. Auditando as Alterações de Dados

Por que é importante?

### Auditar alterações ajuda a identificar atividades suspeitas e garantir conformidade.

### Como configurar:

1- Habilite logs de auditoria :
- Edite o arquivo postgresql.conf:

        log_statement = 'mod'  -- Registra INSERT, UPDATE, DELETE

        log_connections = on

        log_disconnections = on

2- Verifique os logs :

Os logs estarão disponíveis no diretório especificado em logging_collector.

## 4. Coletando Mudanças Usando Triggers

### Por que é importante?

Triggers permitem registrar automaticamente alterações em uma tabela de auditoria.

### Como configurar:

1- Crie uma tabela de auditoria :

        CREATE TABLE auditoria (

            id SERIAL PRIMARY KEY,

            operacao TEXT,

            tabela TEXT,

            registro JSONB,

            data TIMESTAMP DEFAULT CURRENT_TIMESTAMP

        );

2- Crie um trigger para registrar alterações :

        CREATE OR REPLACE FUNCTION registrar_alteracao() RETURNS TRIGGER AS $$

        BEGIN

            IF TG_OP = 'INSERT' THEN

                INSERT INTO auditoria (operacao, tabela, registro)

                VALUES ('INSERT', TG_TABLE_NAME, row_to_json(NEW));

            ELSIF TG_OP = 'UPDATE' THEN

                INSERT INTO auditoria (operacao, tabela, registro)

                VALUES ('UPDATE', TG_TABLE_NAME, row_to_json(NEW));

            ELSIF TG_OP = 'DELETE' THEN

                INSERT INTO auditoria (operacao, tabela, registro)

                VALUES ('DELETE', TG_TABLE_NAME, row_to_json(OLD));

            END IF;

            RETURN NEW;

        END;

        $$ LANGUAGE plpgsql;


        CREATE TRIGGER trigger_auditoria

        AFTER INSERT OR UPDATE OR DELETE ON minha_tabela

        FOR EACH ROW EXECUTE FUNCTION registrar_alteracao();

## 5. Criptografia de Dados Confidenciais
### Por que é importante?

Criptografar dados sensíveis protege contra acessos não autorizados, mesmo em caso de violação.

### Como configurar:

1- Use extensões para criptografia :
- Instale a extensão pgcrypto:

        CREATE EXTENSION pgcrypto;

2- Criptografe dados ao inserir :

        INSERT INTO usuarios (nome, senha)

        VALUES ('joao', crypt('senha_segura', gen_salt('bf')));

3- Verifique a senha criptografada :

        SELECT * FROM usuarios WHERE senha = crypt('senha_segura', senha);

## 6. Implementando uma Row Level Security (RLS)
Por que é importante?
A RLS permite controlar o acesso a linhas específicas com base em políticas.

Como configurar:
Habilite a RLS na tabela :
sql
Copy
1
ALTER TABLE minha_tabela ENABLE ROW LEVEL SECURITY;
Crie uma política de segurança :
sql
Copy
1
2
3
4
⌄
CREATE POLICY politica_leitura
ON minha_tabela
FOR SELECT
USING (usuario_atual = current_user);
Exemplo de consulta restrita :
Somente o usuário associado às linhas poderá visualizá-las.
7. Inspecionando Permissões
Por que é importante?
Inspecionar permissões regularmente ajuda a identificar configurações inadequadas.

Como configurar:
Liste permissões de tabelas :
sql
Copy
1
\z minha_tabela
Liste todas as roles e suas permissões :
sql
Copy
1
2
⌄
SELECT rolname, rolsuper, rolcreaterole, rolcreatedb, rolcanlogin
FROM pg_roles;
Revise permissões desnecessárias :
Revogue permissões excessivas:
sql
Copy
1
REVOKE ALL PRIVILEGES ON DATABASE minha_base FROM usuario_desnecessario;
Conclusão
Implementar medidas de segurança no PostgreSQL é essencial para proteger seus dados e garantir a integridade do sistema. Este guia fornece exemplos práticos para configurar autenticação segura, auditar alterações, criptografar dados e muito mais. Certifique-se de revisar regularmente suas configurações e ajustá-las conforme necessário para manter seu banco de dados seguro.