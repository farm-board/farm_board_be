class Api::V1::FarmsController < ApplicationController
  def index
    render json: FarmSerializer.new(Farm.all)
  end

  def show
    farm = Farm.find(params[:id])
    begin
        render json: FarmSerializer.new(farm)
    end
  end

  def create
    begin 
        render json: FarmSerializer.new(Farm.create!(farm_params)), status: :created
    end
  end

  def update
    begin
        render json: FarmSerializer.new(Farm.update!(params[:id], farm_params)), status: :accepted
    end
  end

  def destroy
    farm = Farm.find(params[:id])
    begin
        render json: FarmSerializer.new(farm.destroy), status: :no_content
    end
  end


private
  def farm_params
    params.permit(:name, :location, :email, :phone, :image, :bio)
  end
end
