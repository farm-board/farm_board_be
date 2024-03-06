require 'rails_helper'

RSpec.describe 'Api::V1::Experiences', type: :request do
  before do
    @user_1 = User.create(email: "user1@example.com", password: "password1", password_confirmation: "password1", jti: SecureRandom.uuid, role_type: 2)
    @user_2 = User.create(email: "user2@example.com", password: "password2", password_confirmation: "password2", jti: SecureRandom.uuid, role_type: 2)
    @user_3 = User.create(email: "billy@gmail.com", password: "password3", password_confirmation: "password3", jti: SecureRandom.uuid, role_type: 2)

    @employee_1 = Employee.create(first_name: "First 1", last_name: "Last 1", city: "City 1", state: "State 1", zip_code: "80020", skills: ["skill1", "skill2"], bio: "Bio 1", age: "25", user: @user_1)
    @employee_2 = Employee.create(first_name: "First 2", last_name: "Last 2", city: "City 2", state: "State 2", zip_code: "80021", skills: ["skill1", "skill2"], bio: "Bio 2", age: "25", user: @user_2)
    @employee_3 = Employee.create(first_name: "First 3", last_name: "Last 3", city: "City 3", state: "State 3", zip_code: "80022", skills: ["skill1", "skill2"], bio: "Bio 3", age: "25", user: @user_3)

    @experience_1 = Experience.create(company_name: 'Test Company', started_at: '2022-01-01', ended_at: '2022-02-01', description: 'Test description', employee: @employee_1)
    @experience_2 = Experience.create(company_name: 'Test Company 2', started_at: '2022-01-01', ended_at: '2022-02-01', description: 'Test description 2', employee: @employee_2)
  end

  describe 'GET /api/v1/users/:user_id/employees/experiences' do
    it 'returns all experiences of an employee' do
      get "/api/v1/users/#{@user_1.id}/employees/experiences"

      expect(response).to have_http_status(:success)
      experiences = JSON.parse(response.body, symbolize_names: true)
      expect(experiences[:data].count).to eq(1)
    end
  end

  describe 'GET /api/v1/users/:user_id/employees/experiences/:id' do
    it 'returns a specific experience of an employee' do
      get "/api/v1/users/#{@user_1.id}/employees/experiences/#{@experience_1.id}"

      expect(response).to have_http_status(:success)
      returned_experience = JSON.parse(response.body, symbolize_names: true)
      expect(returned_experience[:data][:attributes][:company_name]).to eq('Test Company')
    end

    it 'returns a 404 status if experience not found' do
      get "//api/v1/users/#{@user_1.id}/employees/experiences/999"

      expect(response.status).to eq(404)
    end
  end

  describe 'POST /api/v1/users/:user_id/employees/experiences' do
    it 'creates a new experience' do
      experience_params = {
        company_name: 'New Company',
        started_at: '2023-01-01',
        ended_at: '2023-02-01',
        description: 'New description'
      }
      post "/api/v1/users/#{@user_1.id}/employees/experiences", params: experience_params, as: :json

      expect(response).to have_http_status(:created)
      new_experience = JSON.parse(response.body, symbolize_names: true)
      expect(new_experience[:data][:attributes][:company_name]).to eq('New Company')
    end

    it 'returns a 422 status if creation fails' do
      invalid_params = { started_at: '2023-01-01', ended_at: '2023-02-01', description: 'New description' }
      post "/api/v1/users/#{@user_1.id}/employees/experiences", params: invalid_params, as: :json

      expect(response.status).to eq(422)
    end
  end

  describe 'PATCH /api/v1/users/:user_id/employees/experience/:id' do
    it 'updates an existing experience' do
      experience_params = { description: 'Updated description' }
      patch "/api/v1/users/#{@user_1.id}/employees/experiences/#{@experience_1.id}", params: experience_params, as: :json

      expect(response).to have_http_status(:accepted)
      updated_experience = JSON.parse(response.body, symbolize_names: true)
      expect(updated_experience[:data][:attributes][:description]).to eq('Updated description')
    end

    it 'returns a 404 status if experience not found' do
      patch "/api/v1/users/#{@user_1.id}/employees/experience/999", params: { description: 'Updated description' }

      expect(response.status).to eq(404)
    end
  end

  describe 'DELETE /api/v1/users/:user_id/employees/experiences/:id' do
    it 'deletes an existing experience' do
      delete "/api/v1/users/#{@user_1.id}/employees/experiences/#{@experience_1.id}"

      expect(response).to have_http_status(:no_content)
      expect(@employee_1.experiences.count).to eq(0)
    end

    it 'returns a 404 status if experience not found' do
      delete "/api/v1/users/#{@user_1.id}/employees/experiences/999"

      expect(response.status).to eq(404)
    end
  end
end
