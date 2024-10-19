# app/controllers/boards_controller.rb
class BoardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @boards = current_user.boards
    produtividade
  end

  def produtividade
    # Definir o período para o gráfico (do primeiro ao último card completado)
    first_completed_at = Card.joins(board_item: :board)
                           .where(boards: { user_id: current_user.id })
                           .where(completed: true)
                           .minimum(:completed_at)
  
    last_completed_at = Card.joins(board_item: :board)
                            .where(boards: { user_id: current_user.id })
                            .where(completed: true)
                            .maximum(:completed_at)
    
    Rails.logger.info "First completed at: #{first_completed_at}"
    Rails.logger.info "Last completed at: #{last_completed_at}"
    
    # Se o usuário não completou nenhuma tarefa, definir um período padrão
    if first_completed_at.nil? || last_completed_at.nil?
      Rails.logger.info "Nenhum card completado. Definindo período padrão para hoje."
      first_completed_at = Date.today.beginning_of_day
      last_completed_at = Date.today.end_of_day
    end
    
    # Busca todos os cards completados pelo usuário dentro do período
    @completed_cards = Card.joins(board_item: :board)
                          .where(boards: { user_id: current_user.id })
                          .where(completed: true, completed_at: first_completed_at..last_completed_at)
    
    Rails.logger.info "Número de cards completados no período: #{@completed_cards.count}"
    Rails.logger.debug "Cards completados: #{@completed_cards.inspect}"
    
    # Agrupar cards completados por dia usando Groupdate
    @cards_by_day = @completed_cards.group_by_day(:completed_at, range: first_completed_at..last_completed_at).count
    
    Rails.logger.info "Cards agrupados por dia: #{@cards_by_day}"
    
   # Preencher os dias sem atividades com zero
    # O Groupdate já preenche os dias no range com zero, então a inversão pode não ser necessária
   
    
    Rails.logger.info "Cards agrupados com dias sem atividades preenchidos: #{@cards_by_day}"
  end

  def show
    @board = current_user.boards.find(params[:id])
    @board.update(last_access: Time.current)

    if @board.title.include?('Board Diário')
      Rails.logger.info @board
      Rails.logger.info "aaaaaaaaaaa"
      Rails.logger.info current_user.mood
      @daily_board_cards = fetch_daily_board_cards(@board, current_user.mood)
      Rails.logger.info "Daily Board Cards: #{@daily_board_cards.map(&:title)}"
    end
  end

  def new
    @board = current_user.boards.new
    # Inicializar alguns board_items vazios
    3.times { @board.board_items.build }
  end

  def create
    @board = current_user.boards.new(board_params)

    if @board.save
      redirect_to @board, notice: 'Board criado com sucesso.'
    else
      render :new
    end
  end

  def create_daily_board  
    # Verificar se já existe um board diário para o dia de hoje
    daily_board = current_user.boards.where("title LIKE ?", "%Board Diário%").first
  
    if daily_board.nil?
      # Criar um novo board diário
      daily_board = current_user.boards.create(title: "Board Diário - #{Date.today.strftime('%d/%m/%Y')}")
  
      # Criar as duas colunas: To Do e Done
      todo_column = daily_board.board_items.create(name: 'To Do', priority: 1)
      done_column = daily_board.board_items.create(name: 'Done', priority: 2)

    end
  
    respond_to do |format|
      format.html { redirect_to daily_board, notice: 'Board diário criado com sucesso ou já existente.' }
      format.js   # Renderiza create_daily_board.js.erb
    end
  end

  


  # Outras ações (edit, update, destroy) podem ser adicionadas aqui

  private

  def board_params
    params.require(:board).permit(
      :title,
      board_items_attributes: [:id, :name, :_destroy]
    )
  end

  def fetch_daily_board_cards(board, mood)
    # Exemplo de lógica para buscar os cards para o board diário
    # Busca os cards que não estão completos e com a data de vencimento entre hoje e 3 dias a partir de hoje (independente do humor)
 # Busca os cards que não estão completos e com a data de vencimento entre hoje e 3 dias a partir de hoje
      cards = Card.joins(board_item: :board)
      .where(boards: { user_id: current_user.id })
      .where("cards.completed = false AND (cards.due_date BETWEEN ? AND ?)", Date.today, 3.days.from_now)

      # Adiciona também os cards filtrados por humor, caso o mood seja passado
      if mood.present?
      cards_by_mood = Card.joins(board_item: :board)
                .where(boards: { user_id: current_user.id })
                .where("cards.completed = false AND cards.mood_id = ?", mood.id)

      # Unindo os dois conjuntos de cards (de humor e de vencimento próximo) sem duplicação
      cards = cards.or(cards_by_mood)
      end
      Rails.logger.info "Cards retornados (combinação de humor e vencimento próximo):"
      cards.each do |card|
        Rails.logger.info "Card ID: #{card.id}, Título: #{card.title}, Due Date: #{card.due_date}, Humor: #{card.mood&.name}, Prioridade: #{card.priority}"
      end
      # Se não encontrar nenhum card nas condições anteriores, buscar os incompletos ordenados por prioridade
      if cards.empty?
      cards = Card.joins(board_item: :board)
        .where(boards: { user_id: current_user.id })
        .where(completed: false)
        .order(priority: :desc) # Ordena pela prioridade, 4 (alta) vem primeiro
      end
      Rails.logger.info "Cards retornados (combinação de humor e vencimento próximo):"
      cards.each do |card|
        Rails.logger.info "Card ID: #{card.id}, Título: #{card.title}, Due Date: #{card.due_date}, Humor: #{card.mood&.name}, Prioridade: #{card.priority}"
      end
      cards

  end
end
