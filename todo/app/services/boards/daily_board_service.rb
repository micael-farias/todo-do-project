module Boards
  class DailyBoardService
    def initialize(user)
      @user = user
    end

    def fetch_daily_board
      @user.boards.daily.first
    end

    def create_daily_board
      daily_board = @user.boards.create(
        title: "Board Diário",
        daily: true,
        active: false
      )
      daily_board.board_items.create([
        { name: 'To Do', position: 1 },
        { name: 'Done', position: 2 }
      ])
      daily_board
    end

    def ensure_daily_board
      daily_board = fetch_daily_board
      unless daily_board
        daily_board = create_daily_board
      end
      daily_board
    end
  end
end
