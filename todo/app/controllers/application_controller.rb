class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def find_record(model, id, resource_name = 'Recurso')
    record = model.find_by(id: id)
    unless record
      render_not_found(resource_name)
      return nil
    end
    record
  end

  def render_not_found(resource_name = 'Recurso')
    render json: { success: false, message: "#{resource_name} não encontrado." }, status: :not_found
  end

  def render_success(data = {})
    render json: { success: true }.merge(data), status: :ok
  end

  def render_error(message, status = :unprocessable_entity)
    render json: { success: false, message: message }, status: status
  end
end
