class HomeController < ApplicationController
    before_action :check_user_uses_mobile
    
    def index
      active_boards = current_user.boards.active
      @boards = active_boards.includes(:board_items).order(created_at: :desc)
      @last_accessed_boards = active_boards.order(last_access: :desc)
      @days_interval = (@user_uses_mobile ? 15 : 30)
  
      mood_service = Moods::MoodService.new(current_user)
      @active_mood = mood_service.active_mood
      @random_message = mood_service.random_message
      @user_moods_today = mood_service.user_moods_today
      @has_mood_today = mood_service.has_mood_today?
      @selected_moods = mood_service.selected_moods
  
      daily_board_service = Boards::DailyBoardService.new(current_user)
      @daily_board =  daily_board_service.fetch_daily_board
     
      cards_graph_service = Cards::CardsGraphService.new(current_user, @days_interval)
      @cards_by_date = cards_graph_service.padded_cards_by_date
      @first_card_date = cards_graph_service.first_card_date
      @last_card_date = cards_graph_service.last_card_date
      @date_range = cards_graph_service.date_range
      Board.verify_daily_board(current_user, @user_uses_mobile)
    end
  
    private
  
    def check_user_uses_mobile
      @user_uses_mobile = browser.device.mobile?
    end 

  end
  