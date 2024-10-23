module Cards
  class CardsGraphService
    def initialize(user)
      @user = user
      @cards = @user.cards.order(:created_at)
      @first_card_date = 30.days.ago.to_date
      @last_card_date = @cards.last&.created_at&.to_date || Utils::DateService.today
    end
  
    def cards_by_date
      @cards_by_date ||= (@first_card_date..@last_card_date).to_a.map do |date|
        cards_for_date = @cards.where(created_at: date.beginning_of_day..date.end_of_day).to_a
        { date: date, cards: cards_for_date }
      end
    end
  
    def max_cards
      @max_cards ||= cards_by_date.map { |day| day[:cards].size }.max || 0
    end
  
    def padded_cards_by_date
      cards_by_date.each do |day|
        if day[:cards].size < max_cards
          (max_cards - day[:cards].size).times { day[:cards] << nil }
        end
      end
      cards_by_date
    end
  
    attr_reader :first_card_date, :last_card_date, :date_range
  end
end  