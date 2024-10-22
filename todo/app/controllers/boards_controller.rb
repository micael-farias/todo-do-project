# app/controllers/boards_controller.rb
class BoardsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @board = current_user.boards.find(params[:id])

    if @board.destroy
      respond_to do |format|
        format.json { render json: { success: true }, status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: { success: false, message: @board.errors.full_messages.join(", ") }, status: :unprocessable_entity }
      end
    end
  end

  def duplicate
    original_board = Board.find(params[:id])
    new_board = original_board.dup # Duplica o board original
    new_board.title = "#{original_board.title} - Cópia" # Adiciona "- Cópia" ao título

    if new_board.save
      # Duplica as colunas (BoardItems) sem os cards
      original_board.board_items.each do |item|
        new_board.board_items.create(name: item.name, position: item.position)
      end
  
      render json: { success: true, new_board_id: new_board.id }
    else
      render json: { success: false, message: 'Erro ao duplicar o board.' }
    end
  end
  

  def index
    @boards = current_user.boards.order(created_at: :desc)
    @last_accessed_boards = current_user.boards.order(last_access: :desc)
    @today = Time.current
    @daily_board = current_user.boards.where("title LIKE ?", "%Board Diário%").first
    @active_mood = current_user.active_theme_mood
    Rails.logger.info "Mooscsassadds: #{@active_mood.to_json}"

    
    @user_moods_today = current_user.user_moods.where(updated_at: @today.beginning_of_day..@today.end_of_day, active: true)
    @has_mood_today = @user_moods_today.exists?

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
    respond_to do |format|
      if @board.save
        format.json { render json: { success: true, board: @board }, status: :created }
      else
        format.json { render json: { success: false, message: @board.errors.full_messages.join(", ") }, status: :unprocessable_entity }
      end
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
    # Define o intervalo de datas para vencimento
    today = Date.today
    three_days_from_now = 3.days.from_now.to_date
  
    # 1. Buscar os cards que estão se vencendo mais próximos (entre hoje e 3 dias)
    cards_due_soon = Card.joins(board_item: :board)
                         .where(boards: { user_id: current_user.id })
                         .where(completed: false)
                         .where(due_date: today..three_days_from_now)
                         .order(due_date: :asc, priority: :desc)
  
    # 2. Buscar os cards que pertencem aos humores selecionados, excluindo os cards já encontrados
    if moods.present?
      mood_ids = moods.pluck(:id).map do |mood_id|
        case mood_id
        when 1
          [1, 2] # Humor 1 (atual) e próximo humor 2
        when 2
          [1, 2, 3] # Humor 2 (atual) e próximos humores 1 e 3
        when 3
          [1, 2, 3, 4, 5] # Humor 3 (atual) e próximos humores 2 e 4
        when 4
          [3, 4, 5] # Humor 4 (atual) e próximos humores 3 e 5
        when 5
          [4, 5] # Humor 5 (atual) e próximo humor 4
        else
          [] # Caso de erro, nenhum humor associado
        end
      end.flatten.uniq
  
      # Excluir os cards já retornados na busca de "vencimento próximo"
      cards_by_mood = Card.joins(board_item: :board)
                          .where(boards: { user_id: current_user.id })
                          .where(completed: false, mood_id: mood_ids)
                          .where.not(id: cards_due_soon.pluck(:id))
                          .order(priority: :desc)
    else
      cards_by_mood = Card.none
    end
  
    # 3. Buscar o restante dos cards que não foram concluídos e ainda não estão nas listas anteriores
    remaining_cards = Card.joins(board_item: :board)
                          .where(boards: { user_id: current_user.id })
                          .where(completed: false)
                          .where.not(id: cards_due_soon.pluck(:id) + cards_by_mood.pluck(:id))
                          .order(priority: :desc)
  
    # Combinar todos os resultados em um único conjunto de cards
    final_cards = cards_due_soon + cards_by_mood + remaining_cards
  
    # Log para depuração
    Rails.logger.info "Cards finais retornados:"
    final_cards.each do |card|
      Rails.logger.info "Card ID: #{card.id}, Título: #{card.title}, Due Date: #{card.due_date}, Humor: #{card.mood&.name}, Prioridade: #{card.priority}"
    end
  
    final_cards
  end
  
  
  
  
end
