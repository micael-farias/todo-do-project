module Cards
  class CreateCardService
    def initialize(board_item, card_params)
      @board_item = board_item
      @card_params = card_params
    end

    def call
      @card = @board_item.cards.new(@card_params)
      @card.completed = @card.board_item_id == @board_item.board.board_items.order(:position).last.id
      @card.completed_at = @card.completed ? DateService.today : nil
      @card.priority ||= 0

      if @card.save
        { success: true, card: @card }
      else
        { success: false, message: @card.errors.full_messages.join(', ') }
      end
    end
  end
end
