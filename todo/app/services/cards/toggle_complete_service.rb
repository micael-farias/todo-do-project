module Cards
    class ToggleCompleteService
      def initialize(card, completed, board)
        @card = card
        @completed = ActiveModel::Type::Boolean.new.cast(completed)
        @board = board
      end
  
      def call
        if @completed
          mark_as_complete
        else
          mark_as_incomplete
        end
  
        if @card.save
          { success: true }
        else
          { success: false, message: @card.errors.full_messages.join(", ") }
        end
      end
  
      private
  
      def mark_as_complete
        last_column = @board.board_items.last
        if @card.board_item_id != last_column.id
          @card.previous_board_item_id = @card.board_item_id
          @card.board_item_id = last_column.id
        end
      end
  
      def mark_as_incomplete
        if @card.previous_board_item_id.present?
          @card.board_item_id = @card.previous_board_item_id
          @card.previous_board_item_id = nil
        else
          @card.board_item_id = @board.board_items.first.id
        end
      end
    end
  end
  