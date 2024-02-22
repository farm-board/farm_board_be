class Api::V1::ReferencesController < ApplicationController
    before_action :get_employee

    def index
      render json: ReferenceSerializer.new(@employee.references)
    end

    def show
      begin
        reference = @employee.references.find(params[:id])
        render json: ReferenceSerializer.new(reference)
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: e.message }, status: :not_found
      end
    end

    def create
        begin
            reference = @employee.references.build(reference_params)
                if reference.save
                    render json: ReferenceSerializer.new(reference), status: :created
                else
                    render json: { errors: reference.errors.full_messages }, status: :unprocessable_entity
                end
          rescue StandardError => e
            render json: { errors: e.message }, status: :unprocessable_entity
        end
    end

    def update
      reference = @employee.references.find(params[:id])
      if reference.update(reference_params)
        render json: ReferenceSerializer.new(reference), status: :accepted
      else
        render json: { errors: reference.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :not_found
    rescue StandardError => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end

    def destroy
      reference = @employee.references.find(params[:id])
      if reference.destroy
        head :no_content
      else
        render json: { errors: 'Failed to destroy reference' }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :not_found
    rescue StandardError => e
      render json: { errors: e.message }, status: :unprocessable_entity
    end

    private

    def reference_params
      params.permit(:first_name, :last_name, :email, :phone, :relationship, :employee_id)
    end

    def get_employee
      @user = User.find(params[:user_id])
      @employee = @user.employee
    end
end
