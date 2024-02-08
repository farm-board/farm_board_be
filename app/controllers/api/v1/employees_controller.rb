class Api::V1::EmployeesController < ApplicationController
    def index
      render json: EmployeeSerializer.new(Employee.all)
    end
  
    def show
      employee = Employee.find(params[:id])
      render json: EmployeeSerializer.new(employee)
    end
  
    def create
        employee = Employee.create!(employee_params)
        render json: EmployeeSerializer.new(employee), status: :created
    end
      
  
    def update
      render json: EmployeeSerializer.new(Employee.update!(params[:id], employee_params)), status: :accepted
    end
  
    def destroy
      employee = Employee.find(params[:id])
      render json: EmployeeSerializer.new(employee.destroy), status: :no_content
    end
  
    private
  
    def employee_params
        params.permit(:first_name, :last_name, :phone, :email, :location, :bio, :age, skills: [])
    end
end
  