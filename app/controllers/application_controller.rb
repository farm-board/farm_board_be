class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::NotNullViolation, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotUnique, with: :render_unprocessable_entity_response

  def render_not_found_response(error)
    render json: ErrorSerializer.new(error).serialized_json, status: 404
  end

  def render_unprocessable_entity_response(error)
    render json: ErrorSerializer.new(error).serialized_json, status: 422
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:reset_password_token, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:reset_password, keys: [:reset_password_token, :password, :password_confirmation])
  end

end
