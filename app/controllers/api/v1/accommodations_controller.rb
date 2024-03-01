class Api::V1::AccommodationsController < ApplicationController
  before_action :get_farm

  def show
    begin
      render json: AccommodationsSerializer.new(@farm.accommodation)
    end
  end

  def create
    begin
      accommodation = @farm.build_accommodation(accommodation_params)
      accommodation.save
      render json: AccommodationsSerializer.new(accommodation), status: :created
    end
  end

  def update
    begin
      @farm.accommodation.update(accommodation_params)
      render json: AccommodationsSerializer.new(@farm.accommodation), status: :accepted
    end
  end

  def destroy
    begin
      render json: AccommodationsSerializer.new(@farm.accommodation.destroy), status: :no_content
    end
  end

private

  def get_farm
    @user = User.find(params[:user_id])
    @farm = @user.farm
  end

  def accommodation_params
    params.permit(:farm_id, :housing, :transportation, :meals, :images)
  end
end
