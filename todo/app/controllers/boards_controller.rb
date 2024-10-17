# app/controllers/boards_controller.rb
class BoardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @boards = current_user.boards
  end

  def show
    @board = current_user.boards.find(params[:id])
  end

  def new
    @board = current_user.boards.new
    # Inicializar alguns board_items vazios
    3.times { @board.board_items.build }
  end

  def create
    @board = current_user.boards.new(board_params)

    if @board.save
      redirect_to @board, notice: 'Board criado com sucesso.'
    else
      render :new
    end
  end

  # Outras ações (edit, update, destroy) podem ser adicionadas aqui

  private

  def board_params
    params.require(:board).permit(
      :title,
      board_items_attributes: [:id, :name, :_destroy]
    )
  end
end
