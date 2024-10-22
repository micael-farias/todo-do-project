class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters, only: [:create, :update]

    def edit
      Rails.logger.info "Usuario aqui  #{current_user.show_card_priority}"
      @user = current_user # Certifique-se de que o usuário correto está sendo carregado
    end

    protected

    # Adicione os parâmetros permitidos
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
      devise_parameter_sanitizer.permit(:account_update, keys: [
        :avatar,
        :show_recent_boards,
        :show_popular_boards,
        :show_daily_board,
        :show_card_priority,
        :show_card_due_date,
        :show_card_mood,
        :mood_category_id,
        :name
      ])
    end  
    
    def update_mood
      @user = current_user
      mood = Mood.find(params[:mood_id])
  
      if @user.update(mood: mood)
        render json: { success: true, mood: mood.name }, status: :ok
      else
        render json: { success: false, error: "Não foi possível atualizar o humor." }, status: :unprocessable_entity
      end
    end

    def user_params
      user_params = params.require(:user).permit(:name, :email, :password, :password_confirmation) # don't permit `password_digest` here, that database column should not be allowed to be set by the user!
    
      # Remove the password and password confirmation keys for empty values
      user_params.delete(:password) unless user_params[:password].present?
      user_params.delete(:password_confirmation) unless user_params[:password_confirmation].present?
    
      user_params
    end

    protected

    def update_resource(resource, params)
      resource.update_without_password(params)
    end
  end
  