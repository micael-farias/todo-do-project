
module Moods
  class MoodService

      def initialize(user)
        @user = user
        @today = Utils::DateService.today
      end
    
      def active_mood
        @user.active_theme_mood
      end
    
      def random_message
        active_mood&.theme_mood_messages&.order("RANDOM()")&.first
      end
    
      def user_moods_today
        @user.user_moods.where(updated_at: @today.beginning_of_day..@today.end_of_day, active: true)
      end
    
      def has_mood_today?
        user_moods_today.exists?
      end
    
      def selected_moods
        has_mood_today? ? user_moods_today.pluck(:mood_id) : []
      end
    end
  end