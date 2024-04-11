class Api::V1::PostingsController < ApplicationController

  def apply
    @posting = Posting.find(params[:id])
    @user = User.find(params[:user_id])
    current_employee = @user.employee
    if current_employee.present?
      PostingEmployee.create(posting: @posting, employee: current_employee, notification: 'Pending')
      render json: { message: "Application submitted successfully!" }, status: :ok
    else
      render json: { error: "There was an issue submitting the appliction." }, status: :no_content
    end
  end

  before_action :get_farm

  def applicants
    posting = @farm.postings.find(params[:id])
    applicants = posting.posting_employees
    render json: ApplicantSerializer.new(applicants)
  end

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
      posting = @farm.postings.find(params[:id])
      posting.update!(posting_params)
      render json: PostingsSerializer.new(posting), status: :accepted
    end
  end

  def destroy
    posting = @farm.postings.find(params[:id])
    posting.posting_employees.destroy_all
    begin
        render json: PostingsSerializer.new(posting.destroy), status: :no_content
    end
  end


private

  def get_farm
    @user = User.find(params[:user_id])
    @farm = @user.farm
  end

  def posting_params
    params.require(:posting).permit(
      attributes: [
        :title,
        :description,
        :salary,
        :offers_lodging,
        :images,
        :duration,
        :age_requirement,
        :payment_type,
        skill_requirements: []
      ]
    )
  end
end
