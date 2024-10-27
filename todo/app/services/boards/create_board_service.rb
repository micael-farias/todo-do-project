module Boards
    class CreateBoardService
      def initialize(user, board_params)
        @user = user
        @board_params = board_params
      end
  
      def call
        @board = @user.boards.new(@board_params)
        
        if @board.save
          @board.board_items.create([
            { name: 'To Do', position: 1 },
            { name: 'Done', position: 2 }
          ])
  
          { success: true, board: @board }
        else
          { success: false, message: @board.errors.full_messages.join(", ") }
        end
      end
    end
  end
  