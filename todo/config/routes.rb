# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  # Redirecionar para a tela de login para usuários não autenticados
  devise_scope :user do
    patch 'users/update_mood', to: 'users/registrations#update_mood'

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  # Rota para a dashboard após login
  authenticated :user do
    root 'boards#index'
  end


  resources :boards do
    collection do
      post :create_daily_board
    end
    resources :board_items, only: [:create, :update, :destroy] do
      resources :cards, only: [:create, :update, :edit, :destroy] do
        member do
          patch :move
        end
      end
    end
  end
                      
end
