class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :destroy, :duplicate]

  def index
    active_boards = current_user.boards.active
    @boards = active_boards.includes(:board_items).order(created_at: :desc)
    @last_accessed_boards = active_boards.order(last_access: :desc)
    
    mood_service = Moods::MoodService.new(current_user)
    @active_mood = mood_service.active_mood
    @random_message = mood_service.random_message
    @user_moods_today = mood_service.user_moods_today
    @has_mood_today = mood_service.has_mood_today?
    @selected_moods = mood_service.selected_moods

    daily_board_service = Boards::DailyBoardService.new(current_user)
    @daily_board =  daily_board_service.fetch_daily_board

    cards_graph_service = Cards::CardsGraphService.new(current_user)
    @cards_by_date = cards_graph_service.padded_cards_by_date
    @first_card_date = cards_graph_service.first_card_date
    @last_card_date = cards_graph_service.last_card_date
    @date_range = cards_graph_service.date_range
    
  end

  def show
    @board.increment!(:access_count)
    @board.update(last_access: Utils::DateService.today)

    if @board.daily_board?
      fetch_daily_board_cards
      @completed_cards_today = current_user.cards
                                           .where(completed: true, completed_at: Utils::DateService.today.all_day)
                                           .order(completed_at: :desc)
    end
  end

  def create
    @board = current_user.boards.new(board_params)
    if @board.save
      @board.board_items.create([
        { name: 'To Do', position: 1 },
        { name: 'Done', position: 2 }
      ])
      
      render_success(board: @board)
    else
      render_error(@board.errors.full_messages.join(", "))
    end
  end

  def destroy
    if @board.destroy
      render_success
    else
      render_error(@board.errors.full_messages.join(", "))
    end
  end

  def duplicate
    duplication_service = Boards::BoardDuplicationService.new(@board)
    new_board = duplication_service.duplicate

    if new_board
      render_success(new_board_id: new_board.id)
    else
      render_error('Erro ao duplicar o board.')
    end
  end

  private

  def set_board
    @board = find_record(current_user.boards, params[:id], 'Board')
  end

  def board_params
    params.require(:board).permit(:title, board_items_attributes: [:id, :name, :_destroy])
  end

  def fetch_daily_board_cards
    moods = @board.user.moods
    fetch_service = Boards::FetchDailyBoardCardsService.new(current_user, moods)
    @daily_board_cards = fetch_service.call
  end
end
