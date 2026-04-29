# Controle de Estoque - Banco de Dados

Projeto desenvolvido para a disciplina de Administração de Banco de Dados, utilizando MySQL 8.0 e MySQL Workbench.

---

## Parte 1 - Modelagem e Integridade

Modelagem de um banco de dados relacional completo com restrições de integridade, operações que envolvem validação e controle de dados.

**Arquivos:**
- `01_estrutura_basica.sql` → criação do banco, tabelas, chaves, constraints e trigger de estoque
- `02_testes_ed01.sql` → testes de validação

**Tabelas:** `categoria`, `fornecedor`, `produto`, `movimentacao`

---

## Parte 2 - Segurança e Controle de Acesso

Implementação de mecanismos de segurança, controle de acesso por perfil e auditoria de operações.

**Arquivos:**
- `02_auditoria.sql` → tabela de log, triggers de auditoria e procedure de reversão
- `03_seguranca.sql` → usuários, roles, permissões (GRANT/REVOKE) e views
- `04_testes_usuario.sql` → 33 testes individuais por perfil de usuário

**Usuários criados:**

| Usuário | Perfil |
|---|---|
| `usr_consulta` | Somente leitura |
| `usr_operador` | Consulta + movimentações |
| `usr_gerente` | Operador + manutenção de produtos |
| `usr_dba` | Administrador total (GRANT OPTION) |

---

## Como Executar

Execute os scripts na ordem numérica com um usuário root no Workbench.

Para testar as permissões, abra uma conexão separada para cada usuário e execute o bloco correspondente em `04_testes_usuario.sql`, rodando `SET ROLE ALL;` logo após conectar.

<p align="center">
  <img src="./ED02/Casos de Teste - ED02/Conexões.png" alt="conexões"/>
</p>

---

## Integrantes

- ALCEU VASCONCELLOS BOTELHO DOS REIS
- CLARA ROCHA FERREIRA
- EDUARDO GOMES MILIONE
- FELIPE BIGNOTO PALACIO
- LENNON PEREIRA RANGEL
- MURILO PÉRES SILVA SCHITTINO DE CARVALHO
- VINÍCIUS LOURES OLIVEIRA
