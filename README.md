# 🚗 Sistema de Gerenciamento para Oficina Mecânica

![Status](https://img.shields.io/badge/status-conclu%C3%ADdo-green)

Um aplicativo completo e multiplataforma, desenvolvido em Flutter, para a gestão integrada de uma oficina mecânica. O sistema abrange desde o cadastro de clientes e veículos até o controle financeiro, com emissão de faturas e relatórios de desempenho.

---

## ✨ Funcionalidades Principais

O projeto foi desenvolvido com uma arquitetura robusta (MVVM) e conta com as seguintes funcionalidades:

- **👨‍👩‍👧‍👦 Gerenciamento de Clientes:**

  - Cadastro, edição, listagem e exclusão de clientes.

- **🚙 Gerenciamento de Veículos:**

  - Cadastro, edição, listagem e exclusão de veículos, com associação a um cliente.

- **🔧 Gerenciamento de Serviços:**

  - Agendamento de serviços com seletores de data e hora.
  - Validação para impedir agendamentos no mesmo dia e horário.
  - Dropdown para seleção de status (`Agendado`, `Em Andamento`, etc.).

- **🔩 Gestão de Estoque de Peças:**

  - Controle de peças com quantidade, preço de custo e venda, e nível mínimo.
  - Aviso proativo (Toast/SnackBar) na tela principal de peças quando itens atingem o estoque mínimo.
  - Destaque visual e `Tooltip` para itens com baixo estoque na lista.
  - Geração de um relatório de estoque para visualização.

- **🧾 Gestão de Faturas:**

  - Criação de faturas associadas a um serviço.
  - Dropdown para seleção do serviço e do status de pagamento.
  - Geração de uma visualização detalhada da fatura, pronta para emissão ao cliente.

- **💵 Gestão de Pagamentos:**

  - Registro de pagamentos vinculados a uma fatura.
  - Tratamento de erros da API para pagamentos que excedem o valor da fatura, com feedback claro para o usuário.
  - Seletores para data e método de pagamento.

- **📊 Relatórios Financeiros:**
  - Tela de relatório com KPIs (Indicadores-chave): Total Faturado, Total Recebido e Saldo a Receber.
  - Listagem de todas as contas a receber (faturas em aberto).

---

## 💻 Tecnologias Utilizadas

- **Framework:** [Flutter](https://flutter.dev/)
- **Linguagem:** [Dart](https://dart.dev/)
- **Arquitetura:** MVVM (Model-View-ViewModel)
- **Gerenciamento de Estado:** [Provider](https://pub.dev/packages/provider)
- **Comunicação com API:** [http](https://pub.dev/packages/http)
- **Formatação de Datas:** [intl](https://pub.dev/packages/intl)
- **Backend:** A aplicação consome uma API REST para todas as operações de dados.

---

## 🚀 Como Executar o Projeto

Para executar este projeto localmente, siga os passos abaixo:

1.  **Pré-requisitos:**

    - Ter o [SDK do Flutter](https://flutter.dev/docs/get-started/install) instalado.
    - Ter um editor de código configurado, como VS Code ou Android Studio.

2.  **Clonar o repositório:**

    ```bash
    git clone [https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git](https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git)
    ```

3.  **Acessar a pasta do projeto:**

    ```bash
    cd NOME_DA_PASTA
    ```

4.  **Instalar as dependências:**

    ```bash
    flutter pub get
    ```

5.  **Executar o aplicativo:**
    ```bash
    flutter run
    ```

---

## 🎨 Telas do Aplicativo

| Tela Principal | Relatório Financeiro |
| :---: | :---: |
| ![Tela Principal](https://github.com/user-attachments/assets/c2d554b5-f447-4638-bf48-f0733c2408bb) | ![Relatório Financeiro](https://github.com/user-attachments/assets/cc659112-94e1-4e16-acee-3558d54cfcee) |

| Detalhes do Serviço | Lista de Peças com Aviso |
| :---: | :---: |
| ![Detalhes do Serviço](https://github.com/user-attachments/assets/9fd7fb77-15f9-4d51-9f84-1b137392d33e) | ![Lista de Peças](https://github.com/user-attachments/assets/fbc9398a-3741-4f57-8a4e-50ef615c69c0) |
---

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.
