# app/controllers/board_items_controller.rb
class BoardItemsController < ApplicationController
    before_action :set_board
  
    def create
      @board_item = @board.board_items.new(board_item_params)
      if @board_item.save
        redirect_to @board, notice: 'Coluna criada com sucesso.'
      else
        redirect_to @board, alert: 'Não foi possível criar a coluna.'
      end
    end
  
    def update
      @board_item = @board.board_items.find(params[:id])
      if @board_item.update(board_item_params)
        redirect_to @board, notice: 'Coluna atualizada com sucesso.'
      else
        redirect_to @board, alert: 'Não foi possível atualizar a coluna.'
      end
    end
  
    def destroy
      @board_item = @board.board_items.find(params[:id])
      @board_item.destroy
      redirect_to @board, notice: 'Coluna excluída com sucesso.'
    end
  
    private
  
    def set_board
      @board = current_user.boards.find(params[:board_id])
    end
  
    def board_item_params
      params.require(:board_item).permit(:name)
    end
  end
  