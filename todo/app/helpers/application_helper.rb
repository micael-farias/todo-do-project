module ApplicationHelper
    def cards_for_column(board, item)
        if board.daily_board?
          if item == board.board_items.first
            @daily_board_cards
          elsif item == board.board_items.second
            @completed_cards_today
          else
            []
          end
        else
          item.cards.order(:position)
        end
      end
    
      def due_info_for_card(card, board, item)
        if board.daily_board? && item == board.board_items.second
          card.completed_at.strftime('%d/%m/%Y %H:%M')
        else
          card.due_date.present? ? card.due_date.strftime('%d/%m/%Y') : nil
        end
      end
    
      def due_label_for_card(board, item)
        if board.daily_board? && item == board.board_items.second
          'Completado em'
        else
          'Vencimento'
        end
      end
end