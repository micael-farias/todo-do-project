<h2 align="center">
  App Todo 🚀
</h2>

<hr>

## Sumário
1. [Descrição](#descrição)
2. [Decisões Técnicas](#decisões-técnicas)
3. [Diferenciais](#diferenciais)
4. [Requisitos](#requisitos)
   - [Funcionalidades Principais](#funcionalidades-principais)
   - [Humor e Personalização](#humor-e-personalização)
   - [Quadros de Tarefas](#quadros-de-tarefas)
   - [Usuário e Autenticação](#usuário-e-autenticação)
5. [Requisitos em Formato de Imagem e Tutorial da Aplicação](#requisitos-em-formato-de-imagem-e-tutorial-da-aplicação)
   - [Tela Inicial](#tela-inicial)
   - [Tela de um Board - Tela de um Board Diário](#tela-de-um-board---tela-de-um-board-diário)
   - [Configuração de Perfil](#configuração-de-perfil)
   - [Versão Mobile](#versão-mobile)
6. [Considerações](#considerações)
7. [Informações de Banco de Dados](#informações-de-banco-de-dados)
   - [Estrutura Principal](#estrutura-principal)
   - [Sistema de Humores](#sistema-de-humores)
8. [Decisões de Projeto e Práticas Utilizadas](#decisões-de-projeto-e-práticas-utilizadas)
9. [Autores](#autores)
10. [Agradecimentos](#agradecimentos)
11. [Link da Aplicação](#link-da-aplicação)

---

## Descrição

O desafio individual é a implementação de uma Lista de Tarefas ( TO DO ), cada lista pode-se adicionar várias tarefas.

Para fazer esse projeto decidi ir além de uma simples lista de afazeres. Tendo como base o Kanban, incorporei elementos de humor para tornar a experiência de realizar tarefas mais envolvente. Cada dia, o usuário poderá gerar um quadro de tarefas que prioriza as atividades com base no prazo, humor atual e prioridade.

**Github Projects:** [Clique aqui para acessar o github projects](https://github.com/users/micael-farias/projects/1/views/1)

## Decisões Técnicas

- **Ruby**: 3.3.5 (última versão)
- **Rails**: 7.2.1 (última versão)
- **Banco de Dados**: PostgreSQL
- **Frontend**: Bootstrap, HTML/CSS, Javascript (com importmap)
- **Cache e Filas**: Redis
- **Autenticação**: Devise
- **Integração IA**: Open AI

<hr>

## Diferenciais

Diariamente, o usuário poderá escolher o humor que ele está no dia corrente, e após isso, será gerado um quadro de tarefas com todas as tarefas pendentes ( não concluidas ) organizado da seguinte forma:

1. **Tarefas Próximas do Prazo**: Prioriza tarefas que estão a 3 dias de vencer.
2. **Humor do Usuário**: Seleciona tarefas com base no humor atual do usuário.
3. **Prioridade das Tarefas**: Ordena o restante das tarefas por prioridade.

Além do mais o usuário terá um quadro com resumo de quais tarefas ele fez ou não em forma de gráfico. Cada card representa uma tarefa, se o card está preenchido a tarefa está completa. Cada cor representa uma prioridade, sendo maior prioridade as cores mais claras.

## Requisitos

### Funcionalidades Principais

- **Gestão de Tarefas**
  - Criar listas de tarefas.
  - Adicionar, editar e deletar tarefas.
  - Marcar tarefas como concluídas.
  - Definir e visualizar a data de vencimento das tarefas.
  - Definir e visualizar a prioridade das tarefas.
  - Pesquisar tarefas pelo título.
  - Alterar o status das tarefas.
  - Adicionar tags em tarefas.
  - Parametrizar o que deseja ver em uma tarefa.
  - Visão geral de andamento de tarefas (gráfico de cards)

- **Humor e Personalização**
  - Escolher o humor atual para realizar tarefas.
  - Receber mensagens personalizadas de acordo com o humor.
  - O aplicativo sugere o humor ideal para cada tarefa utilizando IA.

- **Quadros de Tarefas**
  - Adicionar, editar e deletar colunas em um quadro de tarefas.
  - Duplicar quadros de tarefas.
  - Visualizar todos os quadros de tarefas.
  - Acessar o quadro de tarefas diário.
  - Parametrizar quais categorias de quadro deseja ver

- **Usuário e Autenticação**
  - Criar e acessar conta de usuário.
  - Editar dados pessoais.
  - Resumo das tarefas dos últimos 30 dias.
  - Versão mobile da aplicação com funcionalidades básicas.

## Requisitos em Formato de Imagem e Tutorial da Aplicação
A seguir, apresento as telas da aplicação. Para cada elemento, adicionei uma breve explicação através de comentários, assim como adicionei um mini "tutorial" que explica o funcionamento de cada parte da implementação.

### Tela inicial
![Tela inicial](https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fhumor%20card.png?alt=media&token=65b3968d-7efd-48a9-bf50-c4f4e10a9036)

### Tela de um board - Tela de um board diário
![Boards](https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fboards.png?alt=media&token=7eff2317-49de-446a-8cfc-87d545749500)

### Configuração de perfil
![Configuração](https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fconfig.png?alt=media&token=c572bebf-1e03-4a5f-92c6-69c62d47ef02)

### Versão mobile
![Mobile](https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/humors%2Fmobile.png?alt=media&token=1296b2fd-09f4-4685-95f6-642ffede70fe)

## Considerações

- **Integração com IA**: Ao criar uma tarefa, o aplicativo utiliza uma inteligência artificial para sugerir qual seria o humor ideal para a realização da tarefa de acordo com o titulo

- **Abordagem Humorada**: A integração do humor visa aumentar o engajamento dos usuários fazendo com que ele se identifique com as personalidades

- **Organização Inteligente**: A priorização das tarefas baseada em prazos, humor e prioridade garante que o usuário foque no que realmente importa a cada dia.

## Informações de Banco de Dados

![Diagrama de Classes](https://firebasestorage.googleapis.com/v0/b/cloud-storage-33fb2.appspot.com/o/todo-db%2Fdiagrama%20de%20classe.png?alt=media&token=e79dfab6-3073-4ae7-b994-e2dff8e7f303)

### Estrutura Principal

1. **Usuário**
   - **Relacionamentos:**
     - **Boards (Quadros de Tarefa):** Cada usuário pode possuir múltiplos quadros de tarefa.
     - **Preferências:** Cada usuário possui preferências que determinam a visibilidade de certos elementos, seja nos cards das tarefas ou na listagem dos boards.
     - **Humor Ativo:** Cada usuário tem um humor ativo que influencia a experiência dentro do sistema.

2. **Boards (Quadros de Tarefa)**
   - **Relacionamentos:**
     - **Board Items (Colunas):** Cada board pode conter várias colunas, conhecidas como board_items, que funciona como o status da tarefa. Caso uma tarefa esteja na última coluna do seu board, a tarefa é dita como concluida.

3. **Board Items (Colunas)**
   - **Relacionamentos:**
     - **Cards (Tarefas):** Cada board_item pode conter múltiplas tarefas (cards).

4. **Cards (Tarefas)**
   - **Atributos:**
     - **Tags:** Cada tarefa pode ter várias tags para categorizar.
     - **Mood (Humor):** Cada tarefa pode opcionalmente estar associada a um humor específico, indicando o humor necessário para realizar a tarefa.

5. **Preferências do Usuário**
   - **Função:** Permitir que o usuário personalize a interface e a exibição de elementos, como a visibilidade de boards populares, boards recentes, prioridades das tarefas, datas de vencimento, humores nos cards, entre outros.

6. **Active Storage**
   - O **Active Storage** é usado para gerenciar o upload e armazenamento de arquivos, principalmente a foto do perfil do usuário.

### Sistema de Humores

1. **Humores (Moods)**
   - **Exemplos:** Excelente, Bom, Neutro, Ruim, Péssimo.
   - **Função:** Representar diferentes estados emocionais que podem estar associados às tarefas.

2. **Categorias de Humor (Mood Categories)**
   - **Exemplos:** Gretchen, Shrek, Nazaré.
   - **Função:** Representar personagens ou temas específicos que categorizam os humores.

3. **Humores do usuário (User Moods)**
   - **Explicação:** Inicialmente eu trabalhei com a ideia do usuário poder ter mais de um humor (ex: 'Hoje estou entre feliz e enérgico', 'Hoje estou pensativo e inspirado'...). No entanto, para poder diminuir um pouco a complexidade e por questões de tempo, optei para que o usuário tivesse um único humor ativo, que partiria de uma escala (Excelente, Bom, Neutro, Ruim e Péssimo). Dessa forma, o usuário possui apenas um único humor ativo..

4. **Temas de Humor (Theme Moods)**
   - **Relacionamentos:**
     - **Humor (Mood):** Cada tema de humor está relacionado a um humor específico.
     - **Categoria de Humor (Mood Category):** Cada tema de humor está associado a uma categoria de humor.
     - **Mensagens:** Cada tema de humor pode ter múltiplas mensagens motivacionais.
   - **Exemplos:**
     - **Gretchen para cada humor existente (Excelente, Bom, Neutro, Ruim, Péssimo)**
     - **O mesmo para Nazaré**
     - **O mesmo para Shrek**

5. **Mensagens Motivacionais (Theme Mood Messages)**
   - **Função:** Fornecer mensagens motivacionais que são exibidas para o usuário. Quando o usuário seleciona seu humor diário, uma mensagem aleatória do tema de humor selecionado é exibida em um card específico na interface.

## Decisões de Projeto e Práticas Utilizadas

1. **Modularidade do código**

   - Tentei tornar o código mais modular possível fazendo com que cada arquivo fizesse uma funcionalidade específica. Para isso fiz com que as cada arquivo da view fosse organizadas por áreas funcionais do sistema (ex: `card/edit`, `cards/show`, etc.). Além disso, cada arquivo da view teria seu arquivo em javascript(js) e seu estilo(css). A separação por responsabilidades facilitou na manutenção de novas features.

2. **Uso de partials**

      - Quando estava desenvolvendo a parte de frontend, percebi que alguns arquivos .html.erb estavam ficando muito extensos... Por isso tentei adotar o uso de partials (ex: `_card.html.erb`, `_header.html.erb`, `_tags.html.erb`) sempre que possível. Algo que evitou a repetição de código, e deu mais clareza na função de cada arquivo.

3. **Uso de Services Objects**

   - Ao desenvolver as rotas nos controllers, percebi que alguns controllers estavam ficando muitos extensos com a criação de novas funcionalidades. Dessa forma, adotei a prática do uso de **Services**, os quais cada um teriam sua responsabilidade. Então com a lógica complexa delegada aos serviços o código dos controllers passou a ser mais limpo.

4. **Simplificação do código nas views**

   - A fim de reduzir a complexidade dos arquivos `.html.erb`, movi as lógicas para variáveis de instância no controller. Por exemplo, em vez de fazer diretamente na view:
   "<%= if current_user.user_preference.show_daily_board && @daily_board.present? &&  !@user_uses_mobile %>" criei uma variável de instância "@show_daily_board = current_user.user_preference.show_daily_board && @daily_board.present? &&  !@user_uses_mobile" e utilizei na view "<% if @show_daily_board %>". O que trouxe mais semântica ao código.

 5. **Uso de Helpers**
  
      - Criei helpers para centralizar funções utilizadas em diversas partes da aplicação, como o método format_date, que formata datas em 'dd/mm/yyyy'. .

 6. **Centralização de cores**

      - Como planejava implementar a personalização do tema de cores no projeto, criei um arquivo globals/colors.css para centralizar as definições de cores. Isso facilitou bastante alterações presentes e futuras, pois todas as cores podem ser ajustadas a partir de um único local

## Autores

- Michael Farias

## Agradecimentos

- Espero que gostem do projeto, foi desenvolvido com muito amor :)

## Link da Aplicação

[[Clique aqui para acessar a aplicação! :)](https://todo-do-project.onrender.com/)]
