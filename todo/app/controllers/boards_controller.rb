# app/controllers/boards_controller.rb
class BoardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @boards = current_user.boards
    @last_accessed_boards = current_user.boards.order(last_access: :desc)
    @today = Time.current
    @daily_board = current_user.boards.where("title LIKE ?", "%Board Diário%").first
    
    
    @active_mood = current_user.user_moods.find_by(active: true)&.mood

    @user_moods_today = current_user.user_moods.where(updated_at: @today.beginning_of_day..@today.end_of_day, active: true)
    Rails.logger.info "Moods: #{@today}"
    @has_mood_today = @user_moods_today.exists?
    Rails.logger.info "Moods: #{@has_mood_today}"

    @selected_moods = @has_mood_today ? @user_moods_today.pluck(:mood_id) : []
    
    # Preparar dados para o gráfico de cards
    @cards = current_user.cards.order(:created_at)
    @first_card_date = 30.days.ago.to_date
    @last_card_date = @cards.last&.created_at&.to_date || Date.today
  
    # Gerar um array de todas as datas entre a primeira e a última criação de card
    @date_range = (@first_card_date..@last_card_date).to_a
  
    # Organizar os cards por data
    @cards_by_date = @date_range.map do |date|
      cards_for_date = @cards.where(created_at: date.beginning_of_day..date.end_of_day).to_a      
      {
        date: date,
        cards: cards_for_date
      }
    end

     # Determinar a quantidade máxima de cards em qualquer dia
     max_cards = @cards_by_date.map { |day| day[:cards].size }.max || 0

     # Preencher os dias com menos cards para igualar à quantidade máxima
     @cards_by_date.each do |day|
      Rails.logger.info "Diaaa #{day}"
       if day[:cards].size < max_cards
         # Adiciona entradas nil para representar espaços vazios
         (max_cards - day[:cards].size).times do        
           day[:cards] << nil
         end
       end
     end

  end

  def show
    @board = current_user.boards.find(params[:id])
    @board.increment!(:access_count)
    @board.update(last_access: Time.current)

    if @board.title.include?('Board Diário')
      @daily_board_cards = fetch_daily_board_cards(@board, current_user.moods)
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
    @board.priority = 0
    
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

  def fetch_daily_board_cards(board, moods)
    # Busca os cards que não estão completos e com a data de vencimento entre hoje e 3 dias a partir de hoje
    cards = Card.joins(board_item: :board)
                .where(boards: { user_id: current_user.id })
                .where("cards.completed = false AND (cards.due_date BETWEEN ? AND ?)", Date.today, 3.days.from_now)
  
    # Se houver humores informados pelo usuário, pegar também os cards desses humores e dos humores próximos
    if moods.present?
      mood_ids = moods.pluck(:id).map do |mood_id|
        case mood_id
        when 1
          [1, 2] # Humor 1 (atual) e próximo humor 2
        when 2
          [1, 2, 3] # Humor 2 (atual) e próximos humores 1 e 3
        when 3
          [2, 3, 4] # Humor 3 (atual) e próximos humores 2 e 4
        when 4
          [3, 4, 5] # Humor 4 (atual) e próximos humores 3 e 5
        when 5
          [4, 5] # Humor 5 (atual) e próximo humor 4
        else
          [] # Caso de erro, nenhum humor associado
        end
      end.flatten.uniq
  
      # Adiciona também os cards filtrados pelos humores do usuário e os próximos
      cards_by_mood = Card.joins(board_item: :board)
                          .where(boards: { user_id: current_user.id })
                          .where("cards.completed = false AND cards.mood_id IN (?)", mood_ids)
      
      # Unindo os dois conjuntos de cards (de humor e de vencimento próximo) sem duplicação
      cards = cards.or(cards_by_mood)
    end
  
    Rails.logger.info "Cards retornados (combinação de humor e vencimento próximo):"
    cards.each do |card|
      Rails.logger.info "Card ID: #{card.id}, Título: #{card.title}, Due Date: #{card.due_date}, Humor: #{card.mood&.name}, Prioridade: #{card.priority}"
    end
  
    # Se não encontrar nenhum card nas condições anteriores, buscar os incompletos ordenados por prioridade
    if cards.empty?
      Rails.logger.info "Nenhuma tarefa encontrada com vencimento próximo e humores correspondentes. Buscando outras tarefas por prioridade."
      
      cards = Card.joins(board_item: :board)
                  .where(boards: { user_id: current_user.id })
                  .where(completed: false)
                  .order(priority: :desc) # Ordena pela prioridade, maior valor vem primeiro
    end
  
    Rails.logger.info "Cards finais retornados:"
    cards.each do |card|
      Rails.logger.info "Card ID: #{card.id}, Título: #{card.title}, Due Date: #{card.due_date}, Humor: #{card.mood&.name}, Prioridade: #{card.priority}"
    end
  
    cards
  end
  
  
end
