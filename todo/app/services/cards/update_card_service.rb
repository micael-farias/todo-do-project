module Cards
  class UpdateCardService
    def initialize(card, card_params, user_preferences)
      @card = card
      @card_params = card_params
      @user_preferences = user_preferences
    end

    def call
      ActiveRecord::Base.transaction do
        update_tags if @card_params[:tags].present?

        if update_card
          { success: true, card: @card.as_json(include: [:tags, :mood]), user: @user_preferences }
        else
          { success: false, message: @card.errors.full_messages.join(', ') }
        end
      end
    rescue => e
      Rails.logger.error "Erro ao atualizar o card: #{e.message}"
      { success: false, message: 'Erro ao atualizar o card.' }
    end

    private

    def update_card
      @card.update(@card_params.except(:tags).merge(mood_source: 'user_assigned'))
    end

    def update_tags
      tag_names = parse_tags(@card_params[:tags])
      return if tag_names.empty?

      @card.tags.where.not(name: tag_names).destroy_all

      tag_names.each do |name|
        @card.tags.find_or_create_by(name: name)
      end
    end

    def parse_tags(tags_param)
      return [] unless tags_param.is_a?(String)
      tags_param.split(',').map(&:strip).reject(&:blank?).uniq
    end
  end
end
