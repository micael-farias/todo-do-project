class Users::RegistrationsController < Devise::RegistrationsController
    # Outros métodos já existentes...
  
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
  