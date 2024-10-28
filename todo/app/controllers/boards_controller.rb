class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :destroy, :update, :duplicate]
  before_action :check_user_uses_mobile

  def show
    @board.increment!(:access_count)
    @board.update(last_access: Utils::DateService.today)
    @highlight_card_id = params[:highlight_card]
    @cards = @board.cards.order(created_at: :desc) 

    if @board.daily_board?
      fetch_daily_board_cards
      @completed_cards_today = current_user.cards
                                           .where(completed: true, completed_at: Utils::DateService.today.all_day)
                                           .order(completed_at: :desc)
    end
  end

  def create
    service = Boards::CreateBoardService.new(current_user, board_params)
    result = service.call
  
    if result[:success]
      rendered_board = render_to_string(
        partial: 'boards/card', 
        locals: { board: result[:board] }
      )
  
      render_success(board: result[:board], rendered_board: rendered_board)
    else
      render_error(result[:message])
    end
  end
  
  def update
    respond_to do |format|
      if @board.update(board_params)
        format.html { redirect_to @board, notice: 'Board was successfully updated.' }
        format.json { render json: { success: true, board: @board }, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { success: false, message: @board.errors.full_messages.to_sentence }, status: :unprocessable_entity }
      end
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

  def check_user_uses_mobile
    @user_uses_mobile = browser.device.mobile?
  end 

  def fetch_daily_board_cards
    moods = @board.user.moods
    fetch_service = Boards::FetchDailyBoardCardsService.new(current_user, moods)
    @daily_board_cards = fetch_service.call
  end
end
