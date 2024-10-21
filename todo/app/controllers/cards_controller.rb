# app/controllers/cards_controller.rb
class CardsController < ApplicationController
    before_action :set_board_and_board_item
    before_action :set_card, only: [:edit, :update]

    def create
      @card = @board_item.cards.new(card_params)
      @card.completed = @card.board_item_id == (@card.board_item.board.board_items.order(:position).last).id
      @card.completed_at = Time.current
      @card.priority = 0

      if @card.save
        #AssignMoodJob.perform_later(@card.id)

  
        last_board_item = @card.board_item.board.board_items.order(:position).last
        card_in_last_column = params[:board_item_id].to_i == last_board_item.id
          Rails.logger.info "Como voce sabe que vou consegur #{params[:board_item_id]}-#{last_board_item.id} #{card_in_last_column}"
        # Renderizar a partial como string
        rendered_card = render_to_string(
          partial: 'card', 
          locals: { 
            card: @card, 
            background_color: '#ffffff', 
            is_last_column: card_in_last_column, 
            due_info: nil, 
            due_label: "Data de Vencimento" 
          }
        )
        render json: { success: true, card: @card, rendered_card: rendered_card }
      else
        render json: { success: false, message: @card.errors.full_messages.join(", ") }
      end
    end
  
    
    def edit
      respond_to do |format|
        format.json { render json: @card.to_json(include: :tags) }
        format.html # se você tiver uma view HTML para edit
      end
    end
  
# PATCH/PUT /boards/:board_id/board_items/:board_item_id/cards/:id
def update
  if @card.update(card_params)
    # Atualizar tags
    if params[:card][:tags].present?
      tag_names = params[:card][:tags].split(',').map(&:strip).reject(&:blank?).uniq
      # Remove tags que não estão mais na lista
      @card.tags.where.not(name: tag_names).destroy_all
      # Adiciona novas tags
      tag_names.each do |tag_name|
        @card.tags.find_or_create_by(name: tag_name)
      end
    else
      # Se nenhuma tag for fornecida, remove todas as tags existentes
      @card.tags.destroy_all
    end

    respond_to do |format|
      format.json { render json: { success: true, card: @card.as_json(include: :tags) }, status: :ok }
      format.html { redirect_to board_path(@board), notice: 'Card was successfully updated.' }
    end
  else
    respond_to do |format|
      format.json { render json: { success: false, message: @card.errors.full_messages.join(', ') }, status: :unprocessable_entity }
      format.html { render :edit }
    end
  end
end

  
    def destroy
      @card = @board_item.cards.find(params[:id])
      @card.destroy
      #redirect_to @board_item.board, notice: 'Card excluído com sucesso.'
    end
  
    def move
      @board = Board.find(params[:board_id])  # Obtém o board a partir do parâmetro
      @card  = Card.find(params[:id])
      Rails.logger.info "Movendo card ID: #{@card.id} - Título: #{@card.title}"
    
      if @board.title.include?('Board Diário')
        Rails.logger.info "Card está em um Board Diário"
    
        daily_board = Board.where("title LIKE ?", "%Board Diário%").first
        Rails.logger.info "Encontrado Board Diário: #{daily_board.title} - ID: #{daily_board.id}"
    
        last_board_item = daily_board.board_items.order(:position).last
        Rails.logger.info "Último item do Board Diário: #{last_board_item.name} - ID: #{last_board_item.id}"
    
        card_in_last_column = params[:board_item_id].to_i == last_board_item.id
        Rails.logger.info "Card na última coluna do Board Diário: #{card_in_last_column}"
    
        if card_in_last_column
          Rails.logger.info "Card está na última coluna. Movendo para o último item do Board original."
    
          original_board_last_item = @card.board_item.board.board_items.order(:position).last
          last_position = original_board_last_item.cards.maximum(:position) || 0
          Rails.logger.info "Movendo para o último Board Item original: #{original_board_last_item.name} - ID: #{original_board_last_item.id}, na posição #{last_position + 1}"
    
          @card.update(
            board_item_id: original_board_last_item.id,
            position: last_position + 1,
            completed: card_in_last_column,
            completed_at: Time.current
          )
        else
          Rails.logger.info "Card NÃO está na última coluna. Movendo para o primeiro item do Board original."
    
          original_board_first_item = @card.board_item.board.board_items.order(:position).first
          last_position_first_item = original_board_first_item.cards.maximum(:position) || 0
          Rails.logger.info "Movendo para o primeiro Board Item original: #{original_board_first_item.name} - ID: #{original_board_first_item.id}, na posição #{last_position_first_item + 1}"
    
          @card.update(
            board_item_id: original_board_first_item.id,
            position: last_position_first_item + 1,
            completed: false,
            completed_at: nil
          )
        end
      else
        Rails.logger.info "Card NÃO está em um Board Diário. Movendo normalmente."
    
        last_board_item = @card.board_item.board.board_items.order(:position).last
        card_in_last_column = params[:board_item_id].to_i == last_board_item.id
        Rails.logger.info "Card na última coluna do Board:#{last_board_item.id} #{params[:board_item_id]}  #{card_in_last_column}"
    
        @card.update(
          board_item_id: params[:board_item_id],
          position: params[:position],
          completed: card_in_last_column,
          completed_at: (card_in_last_column) ? Time.current : nil
        )
      end
    
      Rails.logger.info "Movimento finalizado para o card ID: #{@card.id}"
      head :ok
    end
    
    
    private
  
    def set_board_and_board_item
      @board = Board.find(params[:board_id])
      @board_item = BoardItem.find(params[:board_item_id])
    end
  
    def card_params
      params.require(:card).permit(:title, :description, :mood_id, :due_date, :priority, tags: [])
    end

    def set_card  
      Rails.logger.info params
      
      @card = Card.find(params[:id])
    end

      
  end
  