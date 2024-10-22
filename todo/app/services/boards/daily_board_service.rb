# app/services/daily_board_service.rb
class DailyBoardService
    def initialize(user)
      @user = user
      @today = DateService.today
    end
  
    def fetch_daily_board
       @user.boards.daily.first
    end
  
    def create_daily_board
      daily_board = @user.boards.create(title: "Board Diário")
      daily_board.board_items.create([{ name: 'To Do', priority: 1 }, { name: 'Done', priority: 2 }])
      daily_board
    end
  
    def ensure_daily_board
      daily_board = fetch_daily_board
      unless daily_board&.active
        daily_board&.update(active: true) || create_daily_board
      end
      daily_board
    end
  end
  