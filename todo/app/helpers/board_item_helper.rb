module BoardItemHelper
    def board_column_width(board)
        'width: 600px;' if board.daily_board?
    end
end
