<h2 align="center">
  App Todo 🚀
</h2>

<hr>

## Descrição

O desafio individual é a implementação de uma Lista de Tarefas ( TO DO ), cada lista pode-se adicionar várias tarefas.

Para fazer esse projeto decidi ir além de uma simples lista de afazeres. Tendo como base o Kanban, incorporei elementos de humor pra tornar a experiencia de realizar tarefas mais envolvente. Cada dia, o usuário poderá gerar um quadro de tarefas que prioriza as atividades com base no prazo, humor atual e prioridade.


## Decisões Técnicas

- **Ruby**: 3.3.5 (última versão)
- **Rails**: 7.2.1 (última versão)
- **Banco de Dados**: PostgreSQL
- **Frontend**: Bootstrap, HTML/CSS
- **Cache e Filas**: Redis
- **Autenticação**: Devise

<hr>

## Diferenciais

Diariamente, o usuário poderá escolher o humor que ele está no dia corrente, e após isso, será gerado um quadro de tarefas com todas as tarefas pendentes ( não concluidas ) organizado da seguinte forma:

1. **Tarefas Próximas do Prazo**: Prioriza tarefas que estão a 3 dias de vencer.
2. **Humor do Usuário**: Seleciona tarefas com base no humor atual do usuário.
3. **Prioridade das Tarefas**: Ordena o restante das tarefas por prioridade.

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

- **Humor e Personalização**
  - Escolher o humor atual para realizar tarefas.
  - Receber mensagens personalizadas de acordo com o humor.
  - O aplicativo sugere o humor ideal para cada tarefa utilizando IA.

- **Quadros de Tarefas**
  - Adicionar, editar e deletar colunas em um quadro de tarefas.
  - Duplicar quadros de tarefas.
  - Visualizar todos os quadros de tarefas.
  - Acessar o quadro de tarefas diário.

- **Usuário e Autenticação**
  - Criar e acessar conta de usuário.
  - Editar dados pessoais.
  - Parametrizar categorias de quadros de tarefas.
  - Resumo das tarefas dos últimos 30 dias.
  - Versão mobile da aplicação com funcionalidades básicas.

## Considerações

- **Integração com IA**: Ao criar uma tarefa, o aplicativo utiliza uma inteligência artificial para sugerir qual seria o humor ideal para a realização da tarefa de acordo com o titulo

- **Abordagem Humorada**: A integração do humor visa aumentar o engajamento dos usuários fazendo com que ele se identifique com as personalidades

- **Organização Inteligente**: A priorização das tarefas baseada em prazos, humor e prioridade garante que o usuário foque no que realmente importa a cada dia.

## Informações de banco de dados

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
     - **Gretchen pra cada humor existente (Excelente, Bom, Neutro, Ruim, Péssimo)**
     - **O mesmo para Nazaré**
     - **O mesmo para Shrek**

5. **Mensagens Motivacionais (Theme Mood Messages)**
   - **Função:** Fornecer mensagens motivacionais que são exibidas para o usuário. Quando o usuário seleciona seu humor diário, uma mensagem aleatória do tema de humor selecionado é exibida em um card específico na interface.



## Autores

- Michael Farias

## Agradecimentos

- Espero que gostem do projeto, foi desenvolvido com muito amor :)