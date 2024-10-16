class DashboardController < ApplicationController
  before_action :authenticate_user! # Garante que o usuário esteja logado

  def index
    # Aqui você pode adicionar qualquer lógica ou variáveis para a view
  end
end
