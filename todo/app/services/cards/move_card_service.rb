# app/services/cards/move_card_service.rb
module Cards
  class MoveCardService
      def initialize(card, target_board_item_id, target_position, board)
        @card = card
        @target_board_item_id = target_board_item_id
        @target_position = target_position
        @board_title = board.title
        @board = board
      end
  
      def call
        target_board_item = BoardItem.find(@target_board_item_id)

        if @board.daily_board?
          handle_daily_board_move(target_board_item)
        else
          handle_normal_board_move(target_board_item)
        end
  
        { success: true }
      rescue => e
        Rails.logger.error "Erro ao mover o card: #{e.message}"
        { success: false, message: 'Erro ao mover o card.' }
      end
  
      private
  
      def handle_daily_board_move(target_board_item)
        last_column = @board.board_items.order(:position).last
        if @target_board_item_id == last_column.id
          original_last_item = @card.board_item.board.board_items.order(:position).last
          update_card(original_last_item, @target_position, completed: true, completed_at: Utils::DateService.today)
        else
          original_first_item = @card.board_item.board.board_items.order(:position).first
          update_card(original_first_item, @target_position, completed: false, completed_at: nil)
        end
      end
  
      def handle_normal_board_move(target_board_item)
        update_card(target_board_item, @target_position, completed: @target_board_item_id == target_board_item.board.board_items.order(:position).last.id, completed_at: @target_board_item_id == target_board_item.board.board_items.order(:position).last.id ? Time.current : nil)
      end
  
      def update_card(target_board_item, position, completed:, completed_at:)
        # Update previous_board_item_id only if moving to a different column
        if @card.board_item_id != target_board_item.id
          @card.previous_board_item_id = @card.board_item_id
          @card.board_item_id = target_board_item.id
        end

        @card.assign_attributes(
          board_item_id: target_board_item.id,
          position: position,
          completed: completed,
          completed_at: completed_at
        )
        
        if @card.changed?
          if @card.save
            Rails.logger.info "Card atualizado com sucesso. Mudanças: #{@card.changes}"
          else
            Rails.logger.error "Falha ao atualizar o card: #{@card.errors.full_messages.join(', ')}"
          end
        else
          Rails.logger.info "Nenhuma mudança detectada no card, atualização não necessária."
        end
        
        
      end
    end
  end  
  
