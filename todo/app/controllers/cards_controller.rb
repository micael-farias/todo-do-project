# app/controllers/cards_controller.rb
class CardsController < ApplicationController
    before_action :set_board_item
  
    def create
      @card = @board_item.cards.new(card_params)
      if @card.save
        respond_to do |format|
          format.html { redirect_to @board_item.board, notice: 'Card criado com sucesso.' }
          format.js   # Renderiza create.js.erb
        end
      else
        respond_to do |format|
          format.html { redirect_to @board_item.board, alert: 'Não foi possível criar o card.' }
          format.js   # Renderiza create.js.erb com erros
        end
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
  