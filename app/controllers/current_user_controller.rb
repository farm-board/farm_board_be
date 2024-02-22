class CurrentUserController < ApplicationController
  before_action :authenticate_user!
  def index
    render json: UserSerializer.new(current_user).serializable_hash[:data][:attributes], status: :ok
  end

  def update
    if current_user.update!(user_params)
      case current_user.role_type
      when 'farm'
        current_user.employee.destroy if current_user.employee
        Farm.create(user: current_user)
        render json: UserSerializer.new(current_user).serializable_hash[:data][:attributes], status: :ok
      when 'employee'
        current_user.farm.destroy if current_user.farm
        Employee.create(user: current_user)
        render json: UserSerializer.new(current_user).serializable_hash[:data][:attributes], status: :ok
      end
    else
      render json: { errors: current_user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:role_type)
  end
end
