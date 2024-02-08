require 'rails_helper'

RSpec.describe 'Api::V1::References', type: :request do
    let!(:employee) { Employee.create(first_name: 'John', last_name: 'Doe', email: 'john@example.com', phone: '1234567890') }
    let!(:reference) { employee.references.create(first_name: 'Jane', last_name: 'Doe', email: 'jane1@gmail.com', phone: '1234567890', relationship: 'Friend') }

    describe 'GET /api/v1/employees/:employee_id/references' do
        it 'returns all references of an employee' do
            get "/api/v1/employees/#{employee.id}/references"

            expect(response).to have_http_status(:success)
            references = JSON.parse(response.body, symbolize_names: true)
            expect(references[:data].count).to eq(1)
        end
    end

    describe 'GET /api/v1/employees/:employee_id/references/:id' do
        it 'returns a specific reference of an employee' do
            get "/api/v1/employees/#{employee.id}/references/#{reference.id}"

            expect(response).to have_http_status(:success)
            returned_reference = JSON.parse(response.body, symbolize_names: true)
            expect(returned_reference[:data][:attributes][:first_name]).to eq('Jane')
        end

        it 'returns a 404 status if reference not found' do
            get "/api/v1/employees/#{employee.id}/references/999"

            expect(response.status).to eq(404)
        end
    end

    describe 'POST /api/v1/employees/:employee_id/references' do 
        it 'creates a new reference' do
            reference_params = {
                first_name: 'bill',
                last_name: 'Koe',
                phone: '1234569990',
                email: 'john115@gmail.com',
                relationship: 'Friend'
            }
            post "/api/v1/employees/#{employee.id}/references", params: reference_params
            expect(response).to have_http_status(:created)
            new_reference = JSON.parse(response.body, symbolize_names: true)
            expect(new_reference[:data][:attributes][:first_name]).to eq('bill')
        end

        it 'returns a 422 status if creation fails' do
            invalid_params = { last_name: 'Doe', email: 'jane111@gmail.com', phone: '1234567890', relationship: 'Friend' }
            post "/api/v1/employees/#{employee.id}/references", params: invalid_params
            expect(response.status).to eq(422)
        end
    end

    describe 'PATCH /api/v1/employees/:employee_id/references/:id' do
        it 'updates an existing reference' do
            patch "/api/v1/employees/#{employee.id}/references/#{reference.id}", params: { email: 'updated@gmail.com' }

            expect(response).to have_http_status(:accepted)
            updated_reference = JSON.parse(response.body, symbolize_names: true)
            expect(updated_reference[:data][:attributes][:email]).to eq('updated@gmail.com')
        end

        it 'returns a 404 status if reference not found' do
            patch "/api/v1/employees/#{employee.id}/references/999", params: { email: 'updated1@gmail.com' }

            expect(response.status).to eq(404)
        end
    end

    describe 'DELETE /api/v1/employees/:employee_id/references/:id' do
        it 'deletes a reference' do
            delete "/api/v1/employees/#{employee.id}/references/#{reference.id}"

            expect(response).to have_http_status(:no_content)
            expect(Reference.count).to eq(0)
        end

        it 'returns a 404 status if reference not found' do
            delete "/api/v1/employees/#{employee.id}/references/999"

            expect(response.status).to eq(404)
        end
    end
end