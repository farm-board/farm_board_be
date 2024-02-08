require 'rails_helper'

RSpec.describe 'Api::V1::Experiences', type: :request do
  let!(:employee) { Employee.create(first_name: 'John', last_name: 'Doe', email: 'john@example.com', phone: '1234567890') }
  let!(:experience) { employee.experiences.create(company_name: 'Test Company', started_at: '2022-01-01', ended_at: '2022-02-01', description: 'Test description') }

  describe 'GET /api/v1/employees/:employee_id/experiences' do
    it 'returns all experiences of an employee' do
      get "/api/v1/employees/#{employee.id}/experiences"

      expect(response).to have_http_status(:success)
      experiences = JSON.parse(response.body, symbolize_names: true)
      expect(experiences[:data].count).to eq(1)
    end
  end

  describe 'GET /api/v1/employees/:employee_id/experiences/:id' do
    it 'returns a specific experience of an employee' do
      get "/api/v1/employees/#{employee.id}/experiences/#{experience.id}"

      expect(response).to have_http_status(:success)
      returned_experience = JSON.parse(response.body, symbolize_names: true)
      expect(returned_experience[:data][:attributes][:company_name]).to eq('Test Company')
    end

    it 'returns a 404 status if experience not found' do
      get "/api/v1/employees/#{employee.id}/experiences/999"

      expect(response.status).to eq(404)
    end
  end

  describe 'POST /api/v1/employees/:employee_id/experiences' do
    it 'creates a new experience' do
      experience_params = {
        company_name: 'New Company',
        started_at: '2023-01-01',
        ended_at: '2023-02-01',
        description: 'New description'
      }
      post "/api/v1/employees/#{employee.id}/experiences", params: experience_params

      expect(response).to have_http_status(:created)
      new_experience = JSON.parse(response.body, symbolize_names: true)
      expect(new_experience[:data][:attributes][:company_name]).to eq('New Company')
    end

    it 'returns a 422 status if creation fails' do
      invalid_params = { company_name: '', started_at: '2023-01-01', ended_at: '2023-02-01', description: 'New description' }
      post "/api/v1/employees/#{employee.id}/experiences", params: invalid_params

      expect(response.status).to eq(422)
    end
  end

  describe 'PATCH /api/v1/employees/:employee_id/experiences/:id' do
    it 'updates an existing experience' do
      patch "/api/v1/employees/#{employee.id}/experiences/#{experience.id}", params: { description: 'Updated description' }

      expect(response).to have_http_status(:accepted)
      updated_experience = JSON.parse(response.body, symbolize_names: true)
      expect(updated_experience[:data][:attributes][:description]).to eq('Updated description')
    end

    it 'returns a 404 status if experience not found' do
      patch "/api/v1/employees/#{employee.id}/experiences/999", params: { description: 'Updated description' }

      expect(response.status).to eq(404)
    end
  end

  describe 'DELETE /api/v1/employees/:employee_id/experiences/:id' do
    it 'deletes an existing experience' do
      delete "/api/v1/employees/#{employee.id}/experiences/#{experience.id}"

      expect(response).to have_http_status(:no_content)
      expect(employee.experiences.count).to eq(0)
    end

    it 'returns a 404 status if experience not found' do
      delete "/api/v1/employees/#{employee.id}/experiences/999"

      expect(response.status).to eq(404)
    end
  end
end
