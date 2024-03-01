require 'rails_helper'

RSpec.describe 'Api::V1::References', type: :request do
    before do
        @user_1 = User.create(email: "user1@example.com", password: "password1", password_confirmation: "password1", jti: SecureRandom.uuid, role_type: 2)
        @user_2 = User.create(email: "user2@example.com", password: "password2", password_confirmation: "password2", jti: SecureRandom.uuid, role_type: 2)
        @user_3 = User.create(email: "billy@gmail.com", password: "password3", password_confirmation: "password3", jti: SecureRandom.uuid, role_type: 2)
    
        @employee_1 = Employee.create(first_name: "First 1", last_name: "Last 1", city: "City 1", state: "State 1", zip_code: "80020", skills: ["skill1", "skill2"], bio: "Bio 1", age: "25", user: @user_1)
        @employee_2 = Employee.create(first_name: "First 2", last_name: "Last 2", city: "City 2", state: "State 2", zip_code: "80021", skills: ["skill1", "skill2"], bio: "Bio 2", age: "25", user: @user_2)
        @employee_3 = Employee.create(first_name: "First 3", last_name: "Last 3", city: "City 3", state: "State 3", zip_code: "80022", skills: ["skill1", "skill2"], bio: "Bio 3", age: "25", user: @user_3)
    
        @reference_1 = Reference.create(first_name: 'Jane', last_name: 'Doe', phone: '1234567890', email: 'fake@fake.com', relationship: 'Friend', employee: @employee_1)
        @reference_2 = Reference.create(first_name: 'John', last_name: 'Doe', phone: '1234567890', email: 'fake2@fake.com', relationship: 'Friend', employee: @employee_2)
    end

    describe 'GET /api/v1/users/:user_id/employees/references' do
        it 'returns all references of an employee' do
            get "/api/v1/users/#{@user_1.id}/employees/references"

            expect(response).to have_http_status(:success)
            references = JSON.parse(response.body, symbolize_names: true)
            expect(references[:data].count).to eq(1)
        end
    end

    describe 'GET /api/v1/users/:user_id/employees/references/:id' do
        it 'returns a specific reference of an employee' do
            get "/api/v1/users/#{@user_1.id}/employees/references/#{@reference_1.id}"

            expect(response).to have_http_status(:success)
            returned_reference = JSON.parse(response.body, symbolize_names: true)
            expect(returned_reference[:data][:attributes][:first_name]).to eq('Jane')
        end

        it 'returns a 404 status if reference not found' do
            get "/api/v1/users/#{@user_1.id}/employees/references/999"

            expect(response.status).to eq(404)
        end
    end

    describe 'POST /api/v1/users/:user_id/employees/references' do 
        it 'creates a new reference' do
            reference_params = {
                first_name: 'bill',
                last_name: 'Koe',
                phone: '1234569990',
                email: 'john115@gmail.com',
                relationship: 'Friend'
            }
            post "/api/v1/users/#{@user_1.id}/employees/references", params: reference_params, as: :json
            expect(response).to have_http_status(:created)
            new_reference = JSON.parse(response.body, symbolize_names: true)
            expect(new_reference[:data][:attributes][:first_name]).to eq('bill')
        end

        it 'returns a 422 status if creation fails' do
            invalid_params = { last_name: 'Doe', email: 'jane111@gmail.com', phone: '1234567890', relationship: 'Friend' }
            post "/api/v1/users/#{@user_1.id}/employees/references", params: invalid_params, as: :json
            expect(response.status).to eq(422)
        end
    end

    describe 'PATCH /api/v1/users/:user_id/employees/references/:id' do
        it 'updates an existing reference' do
            reference_params = { last_name: 'Update' }
            patch "/api/v1/users/#{@user_1.id}/employees/references/#{@reference_1.id}", params: reference_params, as: :json

            expect(response).to have_http_status(:accepted)
            updated_reference = JSON.parse(response.body, symbolize_names: true)
            expect(updated_reference[:data][:attributes][:last_name]).to eq('Update')
        end

        it 'returns a 404 status if reference not found' do
            patch "/api/v1/users/#{@user_1.id}/employees/references/999"

            expect(response.status).to eq(404)
        end
    end

    describe 'DELETE /api/v1/users/:user_id/employees/references/:id' do
        it 'deletes a reference' do
            delete "/api/v1/users/#{@user_1.id}/employees/references/#{@reference_1.id}"

            expect(response).to have_http_status(:no_content)
            expect(Reference.count).to eq(1)
        end

        it 'returns a 404 status if reference not found' do
            delete "/api/v1/users/#{@user_1.id}/employees/references/9999"

            expect(response.status).to eq(404)
        end
    end
end