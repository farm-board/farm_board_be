class Api::V1::PostingsController < ApplicationController
  before_action :get_farm, only: [:applicants, :index, :show, :create, :update, :destroy]

  def apply
      posting = Posting.find_by(id: params[:id])
      return render json: { error: "Posting not found" }, status: :not_found unless posting

      user = User.find_by(id: params[:user_id])
      return render json: { error: "User not found" }, status: :not_found unless user

      employee = user.employee
      return render json: { error: "Employee not found" }, status: :not_found unless employee

      if PostingEmployee.exists?(posting: posting, employee: employee)
        render json: { error: "You have already applied to this posting." }, status: :unprocessable_entity
      else
        PostingEmployee.create!(posting: posting, employee: employee, notification: 'Pending')
        render json: { message: "Application submitted successfully!" }, status: :ok
      end
  end


  def applicants
    posting = @farm.postings.find(params[:id])
    base_url = "https://walrus-app-bfv5e.ondigitalocean.app/farm-board-be2"
    
    applicants = posting.posting_employees.includes(:employee).map do |applicant|
      employee = applicant.employee
      image_path = employee.main_image.attached? ? url_for(employee.main_image) : nil
      image_url = image_path ? "#{base_url}#{URI(image_path).path}" : nil
      employee.as_json.merge(image_url: image_url, created_at: applicant.created_at)
    end
  
    render json: ApplicantDataSerializer.new(applicants).serializable_hash
  end

  def index
    postings = @farm.postings
    render json: PostingsSerializer.new(postings)
  end

  def show
    posting = @farm.postings.find(params[:id])
    render json: PostingsSerializer.new(posting)
  end

  def create
    posting = @farm.postings.new(posting_params)
  
    if posting.save   
      render json: PostingsSerializer.new(posting), status: :created
    else
      render json: { errors: posting.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update
    posting = @farm.postings.find(params[:id])
  
    if posting.update(posting_params)            # ← no bang
      render json: PostingsSerializer.new(posting), status: :accepted
    else
      render json: { errors: posting.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def destroy
    posting = @farm.postings.find(params[:id])
    posting.posting_employees.destroy_all
    posting.destroy
    head :no_content
  end

  private

  def get_farm
    @user = User.find(params[:user_id])
    @farm = @user.farm
  end

  def posting_params
    params.require(:posting).permit(
      :title, :description, :salary, :offers_lodging, :duration, 
      :age_requirement, :payment_type, :images, skill_requirements: []
    )
  end
end
