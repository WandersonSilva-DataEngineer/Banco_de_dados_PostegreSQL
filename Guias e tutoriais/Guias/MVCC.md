# MVCC (Controle de Concorrência Multiversão) no PostgreSQL

O **MVCC** (Multiversion Concurrency Control) é um recurso fundamental do PostgreSQL que permite que várias transações ocorram simultaneamente sem bloqueios excessivos. Ele garante consistência e isolamento ao manter versões antigas das linhas enquanto novas transações estão em andamento.

## Como Funciona o MVCC?

- **Versões de Linhas:** Quando uma linha é atualizada ou excluída, o PostgreSQL não sobrescreve os dados imediatamente. Em vez disso, ele cria uma nova versão da linha e mantém a versão antiga até que não haja mais transações ativas que possam precisar dela.
  
- **Isolamento:** Isso permite que transações simultâneas leiam os dados sem interferir umas nas outras. Por exemplo:
  - Uma transação pode ler a versão antiga de uma linha enquanto outra transação está atualizando a mesma linha.
  - A primeira transação verá os dados como estavam antes da atualização, garantindo isolamento.

- **Limpeza de Versões Antigas:** As versões antigas das linhas são eventualmente limpas pelo processo de **VACUUM**, que remove tuplas mortas (versões obsoletas).

## Exemplo Prático

Imagine duas transações:

```sql
-- Transação A: Lê dados
BEGIN;
SELECT * FROM clientes WHERE id = 1;

-- Transação B: Atualiza dados
BEGIN;
UPDATE clientes SET nome = 'João Novo' WHERE id = 1;
COMMIT;

-- Transação A: Lê novamente
SELECT * FROM clientes WHERE id = 1;
COMMIT;