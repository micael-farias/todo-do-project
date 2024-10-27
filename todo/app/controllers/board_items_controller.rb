class BoardItemsController < ApplicationController
  before_action :set_board, only: [:create, :update, :destroy ]
  before_action :set_board_item, only: [:update, :destroy ]

  def create
    @board_item = @board.board_items.new(board_item_params)
    @board_item.position = (@board.board_items.maximum(:position) || 1) + 1
    last_board_item = BoardItem.where(board_id: @board.id).order(id: :desc).first
    
    if @board_item.save

      if last_board_item
        last_board_item.cards.update_all(completed: false, completed_at: nil)
      end

      render_success(rendered_column: render_to_string(partial: 'board_items/index', locals: { item: @board_item }, formats: [:html]))
    else
      render_error(@board_item.errors.full_messages.join(", "))
    end
  end

  def update
    if @board_item.update(board_item_params)
      render_success(board_item: @board_item)
    else
      render_error(@board_item.errors.full_messages.join(", "))
    end
  end

  def destroy
    if @board_item.destroy
      last_board_item = BoardItem.where(board_id: @board.id).order(id: :desc).first

      if last_board_item
        last_board_item.cards.update_all(completed: true, completed_at: Utils::DateService.today)
      end

      render_success
    else
      render_error(@board_item.errors.full_messages.join(", "))
    end
  end

  private

  def set_board
    @board = find_record(current_user.boards, params[:board_id], 'Board')
  end

  def set_board_item
    @board_item = find_record(@board.board_items, params[:id], 'Board Item') if @board
  end

  def board_item_params
    params.require(:board_item).permit(:name)
  end
end
