module Boards
  class FetchDailyBoardCardsService
    def initialize(user, moods)
      @user = user
      @moods = moods
    end
  
    def call
      three_days_from_now = 3.days.from_now.to_date
  
      # 1. Cards que estão se vencendo entre hoje e 3 dias, do usuário
      cards_due_soon = Card.joins(board_item: :board)
                           .where(boards: { user_id: @user.id })
                           .where(completed: false)
                           .where(due_date: Utils::DateService.today..three_days_from_now)
                           .order(due_date: :asc, priority: :desc)
      # 2. Cards que pertencem aos humores selecionados, excluindo os já encontrados
      cards_by_mood = if @moods.present?
                        Card.joins(board_item: :board)
                            .where(boards: { user_id: @user.id })
                            .where(completed: false, mood_id: @user.active_mood.mood_id)
                            .where.not(id: cards_due_soon.pluck(:id))
                            .order(priority: :desc)
                      else
                        Card.none
                      end
  
      # 3. Resto dos cards não concluídos e não listados anteriormente, do usuário
      remaining_cards = Card.joins(board_item: :board)
                            .where(boards: { user_id: @user.id })
                            .where(completed: false)
                            .where.not(id: (cards_due_soon.pluck(:id) + cards_by_mood.pluck(:id)))
                            .order(priority: :desc)
  
      # Combinar todos os resultados
      final_cards = cards_due_soon + cards_by_mood + remaining_cards
  
      final_cards
    rescue => e
      Rails.logger.error "Erro ao buscar cards do usuário: #{e.message}"
      []
    end
  
    private
  
  end
end
