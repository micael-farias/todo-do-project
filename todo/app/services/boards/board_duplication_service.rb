class BoardDuplicationService
    def initialize(board)
      @original_board = board
    end
  
    def duplicate
      new_board = @original_board.dup
      new_board.title = "#{@original_board.title} - Cópia"
  
      ActiveRecord::Base.transaction do
        if new_board.save
          @original_board.board_items.each do |item|
            new_board.board_items.create!(name: item.name, position: item.position)
          end
          new_board
        else
          raise ActiveRecord::Rollback, "Erro ao duplicar o board."
        end
      end
    rescue ActiveRecord::Rollback
      nil
    end
  end
  