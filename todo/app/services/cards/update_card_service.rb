module Cards
  class UpdateCardService
    def initialize(card, card_params, user_preferences)
      @card = card
      @card_params = card_params
      @user_preferences = user_preferences
    end

    def call

      ActiveRecord::Base.transaction do
        if @card.update(@card_params)
          update_tags if @card_params[:tags].present?
          { success: true, card: @card.as_json(include: [:tags, :mood]), user: @user_preferences }
        else
          Rails.logger.info "senhor #{@card.errors.full_messages.join(', ')} #{@card_params} #{@user_preferences}"#result[:success]

          { success: false, message: @card.errors.full_messages.join(', ') }
        end
      end
    rescue => e
      Rails.logger.error "Erro ao atualizar o card: #{e.message}"
      { success: false, message: 'Erro ao atualizar o card.' }
    end

    private

    def update_tags
      Rails.logger.info "senhor #{@card.to_json} #{@card_params} #{@user_preferences}"#result[:success]

      tag_names = @card_params[:tags].split(',').map(&:strip).reject(&:blank?).uniq
      @card.tags.where.not(name: tag_names).destroy_all
      tag_names.each { |name| @card.tags.find_or_create_by(name: name) }
    end
  end
end
  