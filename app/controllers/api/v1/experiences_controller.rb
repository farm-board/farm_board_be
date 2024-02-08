class Api::V1::ExperiencesController < ApplicationController
    before_action :get_employee

    def index
        render json: ExperienceSerializer.new(Experience.all)
    end

    def show
        begin
          experience = @employee.experiences.find(params[:id])
          render json: ExperienceSerializer.new(experience)
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :not_found
        rescue StandardError => e
          render json: { errors: e.message }, status: :unprocessable_entity
        end
    end

    def create
        begin
          experience = @employee.experiences.build(experience_params)
          if experience.save
            render json: ExperienceSerializer.new(experience), status: :created
          else
            render json: { errors: experience.errors.full_messages }, status: :unprocessable_entity
          end
        rescue StandardError => e
          render json: { errors: e.message }, status: :unprocessable_entity
        end
    end

    def update
        begin
          @experience = @employee.experiences.find(params[:id])
          if @experience.update(experience_params)
            render json: ExperienceSerializer.new(@experience), status: :accepted
          else
            render json: { errors: @experience.errors.full_messages }, status: :unprocessable_entity
          end
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :not_found
        rescue StandardError => e
          render json: { errors: e.message }, status: :unprocessable_entity
        end
    end

    def destroy
        begin
          experience = @employee.experiences.find(params[:id])
          if experience.destroy
            render json: { message: 'Experience successfully destroyed' }, status: :no_content
          else
            render json: { errors: 'Failed to destroy experience' }, status: :unprocessable_entity
          end
        rescue ActiveRecord::RecordNotFound => e
          render json: { errors: e.message }, status: :not_found
        rescue StandardError => e
          render json: { errors: e.message }, status: :unprocessable_entity
        end
    end

    private

        def get_employee
            @employee = Employee.find(params[:employee_id])
        end

        def experience_params
            params.permit(:employee_id, :company_name, :started_at, :ended_at, :description)
        end
end