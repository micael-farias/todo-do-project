module Moods
  class UserMoodUpdateService
    attr_reader :error_message, :theme_mood_data
  
    def initialize(user, selected_mood_id)
      @user = user
      @selected_mood_id = selected_mood_id
      @error_message = nil
      @theme_mood_data = {}
    end
  
    def call
      ActiveRecord::Base.transaction do
        update_user_mood
        activate_daily_board
        assign_theme_mood
  
        if @user_mood.save
          true
        else
          @error_message = @user_mood.errors.full_messages.join(", ")
          false
        end
      end
    rescue => e
      @error_message = "Erro ao atualizar humor: #{e.message}"
      false
    end
  
    private
  
    def update_user_mood
      @user.user_moods.update_all(active: false)
      @user_mood = @user.user_moods.find_or_initialize_by(mood_id: @selected_mood_id)
      @user_mood.active = true
    end
  
    def activate_daily_board
      daily_board = @user.boards.find_by("title LIKE ?", "%Board Diário%")
      daily_board.update(active: true) if daily_board && !daily_board.active
    end
  
    def assign_theme_mood
      theme_mood = ThemeMood.find_by(mood_id: @selected_mood_id, mood_category_id: @user.mood_category_id)
      return unless theme_mood
  
      random_message = theme_mood.theme_mood_messages.order("RANDOM()").first
      @theme_mood_data = {
        image_url: theme_mood.image_url,
        message: random_message&.message,
        name: theme_mood.mood.name
      }
    end
  end
end  