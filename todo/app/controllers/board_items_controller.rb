# app/controllers/board_items_controller.rb
class BoardItemsController < ApplicationController
    before_action :set_board, only: [:create, :update, :destroy]
    before_action :set_board_item, only: [:update, :destroy]  

    def create
      @board_item = @board.board_items.new(board_item_params)
      last_position = @board.board_items.maximum(:position) || 1
      @board_item.position = last_position + 1

      if @board_item.save
        render json: { 
          success: true, 
          rendered_column: render_to_string(partial: 'board_items/column', locals: { item: @board_item }, formats: [:html]) 
        }
      else
        render json: { success: false, message: @board_item.errors.full_messages.join(", ") }
      end
    end
    
    def update
      if @board_item.update(board_item_params)
        respond_to do |format|
          format.html { redirect_to @board, notice: 'Coluna atualizada com sucesso.' }
          format.json { render json: { success: true, board_item: @board_item }, status: :ok }
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.json { render json: { success: false, message: @board_item.errors.full_messages.join(", ") }, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      if @board_item.destroy
        render json: { success: true }
      else
        render json: { success: false, message: @board_item.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_board
      @board = current_user.boards.find(params[:board_id])
    end  

    def set_board_item
      @board_item = @board.board_items.find(params[:id])
    end

    def board_item_params
      params.require(:board_item).permit(:name)
    end
  end
  