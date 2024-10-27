# config/routes.rb
Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  # Redirecionar para a tela de login para usuários não autenticados
  devise_scope :user do
    get '/users/sign_out' => 'devise/sessions#destroy'     

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
  get 'tags/render', to: 'tags#render_tag', as: 'render_tag'
  patch '/boards/:board_id/board_items/:board_item_id/cards/:id/toggle_complete', to: 'cards#toggle_complete', as: :toggle_complete_card
  get 'cards/search', to: 'cards#search', as: 'cards/search'

  # Rota para a dashboard após login
  authenticated :user do
    root 'home#index'
  end

  resources :user_moods, only: [:create, :destroy]
  post 'update_user_moods', to: 'user_moods#update_user_moods'

  resources :boards do
    post 'duplicate', on: :member

    collection do
      post :create_daily_board
      post :update_user_moods
    end
    resources :board_items, only: [:create, :update, :destroy, :edit] do  
      resources :cards, only: [:create, :update, :edit, :destroy] do
        member do
          patch :move
        end
      end
    end
  end
                      
end
