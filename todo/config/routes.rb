# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  # Redirecionar para a tela de login para usuários não autenticados
  devise_scope :user do
    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  # Rota para a dashboard após login
  authenticated :user do
    root 'dashboard#index', as: :authenticated_root
  end
end
