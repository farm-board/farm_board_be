class Api::V1::EmployeesController < ApplicationController
    before_action :get_employee

    def index
      render json: EmployeeSerializer.new(Employee.all)
    end

    def show
      render json: EmployeeSerializer.new(@employee)
    end

    def update
      begin
          @employee.update!(employee_params)
          render json: EmployeeSerializer.new(@employee), status: :accepted
      end
    end

    # POST /api/v1/users/:user_id/employees/:id/upload_image
    def upload_image
      unless @employee
        render json: { error: "Employee not found" }, status: :not_found
        return
      end

      @employee.main_image.attach(params[:image])

      render json: { message: "Image uploaded successfully" }, status: :ok
    end

    # GET /api/v1/users/:user_id/employees/:id/image
    def show_image
      unless @employee && @employee.main_image.attached?
        render json: { error: "Image not found" }, status: :not_found
        return
      end

      image_url = url_for(@employee.main_image)

      render json: { image_url: image_url }, status: :ok
    end

    private

    def get_employee
      @user = User.find(params[:user_id])
      @employee = @user.employee
    end

    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :city, :state, :zip_code, :bio, :age, :main_image, skills: [])
    end
end
