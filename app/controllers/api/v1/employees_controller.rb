class Api::V1::EmployeesController < ApplicationController
  before_action :get_employee, only: [:show, :update, :upload_image, :show_image]

  def profile_info
    employee = Employee.includes(:experiences, :references).find_by(id: params[:id])
    return render json: { error: "Employee not found" }, status: :not_found unless employee

    image_url = employee.main_image.attached? ? url_for(employee.main_image) : nil
    employee_data = employee.as_json.merge(
      image_url: image_url,
      experiences: employee.experiences,
      references: employee.references
    )

    render json: EmployeeProfileSerializer.new(employee_data).serializable_hash
  end

  def index
    employees = Employee.includes(:experiences, :references).all
    render json: EmployeeSerializer.new(employees)
  end

  def show
    render json: EmployeeSerializer.new(@employee)
  end

  def update
    if @employee.update(employee_params)
      render json: EmployeeSerializer.new(@employee), status: :accepted
    else
      render json: { errors: @employee.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /api/v1/users/:user_id/employees/:id/upload_image
  def upload_image
    @employee.main_image.attach(params[:image])
    render json: { message: "Image uploaded successfully" }, status: :ok
  end

  # GET /api/v1/users/:user_id/employees/:id/image
  def show_image
    if @employee.main_image.attached?
      image_url = url_for(@employee.main_image)
      render json: { image_url: image_url }, status: :ok
    else
      render json: { error: "Image not found" }, status: :not_found
    end
  end

  private

  def get_employee
    @user = User.find(params[:user_id])
    @employee = @user.employee
  end

  def employee_params
    params.require(:employee).permit(
      :first_name, :last_name, :city, :state, :zip_code, :bio, :age, :main_image, 
      :phone, :email, :setup_complete, skills: []
    )
  end
end