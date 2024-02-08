class Api::V1::PostingsController < ApplicationController
  before_action :get_farm

  def index
    render json: PostingsSerializer.new(@farm.postings.all)
  end

  def show
    posting = @farm.postings.find(params[:id])
    begin
      render json: PostingsSerializer.new(posting)
    end
  end

  def create
    begin
      render json: PostingsSerializer.new(@farm.postings.create!(posting_params)), status: :created
    end
  end

  def update
    begin
        render json: PostingsSerializer.new(@farm.postings.update!(params[:id], posting_params)), status: :accepted
    end
  end

  def destroy
    posting = @farm.postings.find(params[:id])
    begin
        render json: PostingsSerializer.new(posting.destroy), status: :no_content
    end
  end

private

  def get_farm
    @farm = Farm.find(params[:farm_id])
  end

  def posting_params
    params.permit(:farm_id, :title, :description, :salary, :offers_lodging, :images, :duration, :age_requirement, :payment_type, skill_requirements: [])
  end
end
