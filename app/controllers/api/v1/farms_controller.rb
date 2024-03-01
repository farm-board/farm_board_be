class Api::V1::FarmsController < ApplicationController
  before_action :get_user

  def index
    render json: FarmSerializer.new(Farm.all)
  end

  def show
    begin
        render json: FarmSerializer.new(@user.farm)
    end
  end

  def update
    farm = @user.farm
    begin
        farm.update!(farm_params)
        render json: FarmSerializer.new(farm), status: :accepted
    end
  end

  def destroy
    begin
        render json: FarmSerializer.new(@user.farm.destroy), status: :no_content
    end
  end


private

  def get_user
    @user = User.find(params[:user_id])
  end

  def farm_params
    params.require(:farm).permit(:name, :city, :state, :zip_code, :bio)
  end
end
