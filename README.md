# 📦 Sistema de Controle de Estoque

Projeto desenvolvido para a disciplina de Administração de Banco de Dados, com foco na modelagem, implementação e validação de um sistema de controle de estoque utilizando MySQL.

---

## 🎯 Objetivo

O objetivo deste projeto é implementar um banco de dados relacional capaz de gerenciar produtos, categorias, fornecedores e movimentações de estoque, garantindo a integridade dos dados por meio de restrições e regras de negócio automatizadas.

---

## 🧠 Funcionalidades

* Cadastro de **categorias**
* Cadastro de **fornecedores**
* Cadastro de **produtos**
* Registro de **movimentações de estoque** (entrada e saída)
* Atualização automática do estoque por meio de **trigger**
* Validação de integridade com:

  * `PRIMARY KEY`
  * `FOREIGN KEY`
  * `CHECK`
  * `NOT NULL`

---

## ⚙️ Tecnologias Utilizadas

* MySQL
* MySQL Workbench

---

## 🗂️ Estrutura do Repositório

```
controle-estoque-bd/
│
├── sql/
│   ├── estrutura.sql       # Criação do banco, tabelas e trigger
│   ├── testes.sql          # Scripts de teste (inserções e validações)
│   └── completo.sql        # (Opcional) Script completo
│
├── modelos/
│   ├── modelo_conceitual.png
│   └── modelo_logico.png
│
├── imagens/
│   ├── insercao_valida_categoria.png
│   ├── insercao_valida_produto.png
│   ├── erro_check.png
│   ├── erro_not_null.png
│   ├── trigger_entrada.png
│   ├── trigger_saida.png
│   ├── erro_trigger.png
│   └── consulta_final.png
│
└── README.md
```

---

## 🚀 Como Executar o Projeto

1. Abra o MySQL Workbench
2. Execute o script de estrutura:

   ```sql
   sql/estrutura.sql
   ```
3. Execute o script de testes:

   ```sql
   sql/testes.sql
   ```
4. Utilize os comandos `SELECT` para verificar os resultados

---

## ⚙️ Funcionamento da Trigger

Foi implementada uma trigger para garantir a atualização automática do estoque:

* Movimentações do tipo **entrada** aumentam o estoque
* Movimentações do tipo **saída** diminuem o estoque
* Caso a quantidade de saída seja maior que o estoque disponível, a operação é bloqueada

Essa abordagem garante que o estoque nunca assuma valores negativos, mantendo a integridade dos dados.

---

## 🧪 Testes Realizados

Foram realizados testes para validar:

* Inserções válidas de dados
* Regras de integridade (CHECK e NOT NULL)
* Funcionamento da trigger
* Bloqueio de operações inválidas

Os resultados dos testes podem ser visualizados na pasta `imagens/`.

---

## 👥 Integrantes

* Alceu Botelho
* Andrezza Piloni
* Clara Ferreira
* Eduardo Milione
* Felipe Bignoto
* Murilo Schittino
* Vinícius Loures
