module BoardItems
    class CreateBoardItemService
      def initialize(board, board_item_params)
        @board = board
        @board_item_params = board_item_params
      end
  
      def call
        @board_item = @board.board_items.new(@board_item_params)
        @board_item.position = (@board.board_items.maximum(:position) || 1) + 1
  
        last_board_item = BoardItem.where(board_id: @board.id).order(id: :desc).first
        
        if @board_item.save
          if last_board_item
            last_board_item.cards.update_all(completed: false, completed_at: nil)
          end
  
          { success: true, board_item: @board_item }
        else
          { success: false, message: @board_item.errors.full_messages.join(", ") }
        end
      end
    end
  end
  