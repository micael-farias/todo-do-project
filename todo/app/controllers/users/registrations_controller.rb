class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters, only: [:create, :update]

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
  
      devise_parameter_sanitizer.permit(:account_update, keys: [
        :avatar,
        :name,
        :mood_category_id,
        user_preference_attributes: [
          :show_recent_boards,
          :show_popular_boards,
          :show_daily_board,
          :show_card_priority,
          :show_card_due_date,
          :show_card_mood,
          :show_form_after_create_card
        ]
      ])
    end 

    protected

    def update_resource(resource, params)
      resource.update_without_password(params)
    end
    
  end
  