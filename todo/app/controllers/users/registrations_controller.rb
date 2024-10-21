class Users::RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters, only: [:create, :update]

    protected

    # Adicione os parâmetros permitidos
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avatar])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :avatar])
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
  end
  