module Cards
  class CardsGraphService
    attr_reader :first_card_date, :last_card_date, :date_range
  
    def initialize(user)
      @user = user
      @first_card_date = 30.days.ago.to_date
      @last_card_date = Utils::DateService.today
      @date_range = (@first_card_date..@last_card_date).to_a
      @cards = @user.cards
                    .where(created_at: @first_card_date.beginning_of_day..@last_card_date.end_of_day)
                    .order(:created_at)
    end
  
    def cards_by_date
      @cards_by_date ||= begin
        # Agrupa os cartões por data de criação
        grouped_cards = @cards.group_by { |card| card.created_at.to_date }
  
        # Cria um array com os cartões agrupados por data
        @date_range.map do |date|
          { date: date, cards: grouped_cards[date] || [] }
        end
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
  end
  
end  