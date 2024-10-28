class CardsController < ApplicationController
  before_action :set_board_and_board_item, except: [:search]
  before_action :set_card, only: [:edit, :update, :destroy, :move, :toggle_complete]

  def create
    service = Cards::CreateCardService.new(@board_item, card_params)
    result = service.call
  
    if result[:success]
      rendered_card = render_to_string(
        partial: 'cards/show',
        locals: {
          card: result[:card],
          current_user: current_user, 
          background_color: '#ffffff',
          is_last_column: result[:card].completed,
          due_info: nil,
          due_label: 'Data de Vencimento'
        }
      )
      render_success(card: result[:card], rendered_card: rendered_card, open_form: current_user.show_form_after_create_card)
    else
      render_error(result[:message])
    end
  end
  
  def search
    @cards = params[:query].present? ? Card.search_by_title(params[:query], current_user) : Card.none
  
    respond_to do |format|
      format.json { render json: format_cards_json(@cards) }
    end
  end

  def edit
    render json: @card.to_json(include: :tags)
  end

  def update
    user_preferences = {
      show_card_due_date: current_user.show_card_due_date,
      show_card_mood: current_user.show_card_mood,
      show_card_priority: current_user.show_card_priority
    }

    service = Cards::UpdateCardService.new(@card, card_params, user_preferences)
    result = service.call

    if result[:success]
      render_success(card: result[:card], user: result[:user])
    else
      render_error(result[:message])
    end
  end

  def destroy
    if @card.destroy
      render_success
    else
      render_error(@card.errors.full_messages.join(", "))
    end
  end

  def move
    service = Cards::MoveCardService.new(@card, params[:board_item_id].to_i, params[:position].to_i, @board)
    result = service.call

    if result[:success]
      head :ok
    else
      render_error(result[:message])
    end
  end
 
  def toggle_complete
    service = Cards::ToggleCompleteService.new(@card, params[:completed], @board)
    result = service.call

    if result[:success]
      render json: { success: true }
    else
      render json: { success: false, message: result[:message] }
    end
  end
  
  private

  def set_board_and_board_item
    @board = find_record(Board, params[:board_id], 'Board')
    @board_item = find_record(BoardItem, params[:board_item_id], 'Board Item') if @board
  end

  def set_card
    @card = find_record(current_user.cards, params[:id], 'Card')
  end

  def card_params
    params.require(:card).permit(:title, :description, :mood_id, :due_date, :priority, :tags)
  end

  def format_cards_json(cards)
    cards.map do |card|
      {
        id: card.id,
        title: card.title,
        board_id: card.board_item.board_id
      }
    end
  end
end
