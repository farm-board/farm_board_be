class Api::V1::EmployeesController < ApplicationController
    before_action :get_user

    def index
      render json: EmployeeSerializer.new(Employee.all)
    end

    def show
      render json: EmployeeSerializer.new(@user.employee)
    end

    def update
      employee = @user.employee
      begin
          employee.update!(employee_params)
          render json: EmployeeSerializer.new(employee), status: :accepted
      end
    end

    private

    def get_user
      @user = User.find(params[:user_id])
    end

    def employee_params
        params.require(:employee).permit(:first_name, :last_name, :city, :state, :zip_code, :bio, :age, skills: [])
    end
end
