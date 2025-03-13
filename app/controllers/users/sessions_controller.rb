# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include RackSessionFix
  respond_to :json
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  def destroy
    # 1) Attempt to revoke the JWT if present/valid
    token = request.env['warden-jwt_auth.token']  # or parse from headers
    if token.present?
      begin
        # Devise normally auto-revokes on valid tokens,
        # but you can do a manual call if needed:
        Warden::JWTAuth::RevocationStrategies::JTI.revoke_jwt(token, nil)
      rescue StandardError => e
        Rails.logger.error "JWT revocation failed: #{e.message}"
      end
    end

    # 2) Force sign out from any Devise session scope
    sign_out(:user)  # or sign_out_all_scopes if you want
    reset_session     # kills the Rails session

    # 3) Return a success response no matter what
    render json: { status: { code: 200, message: 'Logged out successfully' } }, status: :ok
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private

  def respond_with(resource, _opts = {})
    render json: {
      status: { code: 200, message: 'Logged in successfully.' },
      data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    }
  end

  def respond_to_on_destroy
    if current_user
      render json: {
        status: { code: 200, message: 'Logged out successfully.' }
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: 'User not logged in.' },
      }, status: :unauthorized
    end
  end
end
