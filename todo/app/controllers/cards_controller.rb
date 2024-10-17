# app/controllers/cards_controller.rb
class CardsController < ApplicationController
    before_action :set_board_item
  
    def create
      @card = @board_item.cards.new(card_params)
      if @card.save
        render json: { success: true, card: @card }
      else
        render json: { success: false, message: @card.errors.full_messages.join(", ") }
      end
    end
  
    def update
      @card = @board_item.cards.find(params[:id])
      if @card.update(card_params)
        redirect_to @board_item.board, notice: 'Card atualizado com sucesso.'
      else
        redirect_to @board_item.board, alert: 'Não foi possível atualizar o card.'
      end
    end
  
    def destroy
      @card = @board_item.cards.find(params[:id])
      @card.destroy
      redirect_to @board_item.board, notice: 'Card excluído com sucesso.'
    end
  
    def move
      @card = Card.find(params[:id])
      @card.update(
        board_item_id: params[:board_item_id],
        position: params[:position]
      )
      head :ok
    end
    
    private
  
    def set_board_item
      @board_item = BoardItem.find(params[:board_item_id])
    end
  
    def card_params
      params.require(:card).permit(:title, :description)
    end


      
  end
  