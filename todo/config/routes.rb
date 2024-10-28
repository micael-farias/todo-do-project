Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'

    unauthenticated do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  get 'cards/search', to: 'cards#search', as: 'cards/search'

  authenticated :user do
    root to: 'home#index'
  end
  
  resources :boards do
    member do
      post :duplicate
    end

    collection do
      post :create_daily_board
    end

    resources :board_items, only: [:create, :update, :destroy, :edit] do
      resources :cards, only: [:create, :update, :edit, :destroy] do
        member do
          patch :move
          patch :toggle_complete
        end
      end
    end
  end

  resources :user_moods, only: [:create, :destroy] do
    collection do
      post :update_user_moods
    end
  end
end
