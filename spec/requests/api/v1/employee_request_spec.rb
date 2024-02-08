require 'rails_helper'

RSpec.describe "Employee API", type: :request do
    before do
        @employee_1 = Employee.create(first_name: "John", last_name: "Doe", phone: "1234567890", email: "john1@gmail.com", location: "Location 1", skills: ["skill1", "skill2"], bio: "Bio 1", age: "25")
        @employee_2 = Employee.create(first_name: "Jane", last_name: "Doe", phone: "1234567891", email: "jane1@gmail.com", location: "Location 2", skills: ["skill1", "skill2"], bio: "Bio 2", age: "25")
        @employee_3 = Employee.create(first_name: "John", last_name: "Smith", phone: "1234567892", email: "john2@gmail.com", location: "Location 3", skills: ["skill1", "skill2"], bio: "Bio 3", age: "25")
    end

    describe "the employee index" do
        it "returns all employees" do
            get "/api/v1/employees"

            expect(response).to have_http_status(:success)
            employees = JSON.parse(response.body, symbolize_names: true)
            expect(employees[:data].count).to eq(3)
            expect(employees[:data][0][:attributes]).to have_key(:first_name)
            expect(employees[:data][0][:attributes]).to have_key(:last_name)
            expect(employees[:data][0][:attributes]).to have_key(:phone)
            expect(employees[:data][0][:attributes]).to have_key(:email)
            expect(employees[:data][0][:attributes]).to have_key(:location)
            expect(employees[:data][0][:attributes]).to have_key(:skills)
            expect(employees[:data][0][:attributes]).to have_key(:bio)
            expect(employees[:data][0][:attributes]).to have_key(:age)
        end
    end

    describe 'the employees show' do
        context 'happy path' do
            it 'returns one employee' do
                get "/api/v1/employees/#{@employee_1.id}"

                expect(response).to be_successful
                employee = JSON.parse(response.body, symbolize_names: true)
                expect(employee[:data][:attributes][:first_name]).to eq(@employee_1.first_name)
                expect(employee[:data][:attributes][:last_name]).to eq(@employee_1.last_name)
                expect(employee[:data][:attributes][:phone]).to eq(@employee_1.phone)
                expect(employee[:data][:attributes][:email]).to eq(@employee_1.email)
                expect(employee[:data][:attributes][:location]).to eq(@employee_1.location)
                expect(employee[:data][:attributes][:skills]).to eq(@employee_1.skills)
                expect(employee[:data][:attributes][:bio]).to eq(@employee_1.bio)
                expect(employee[:data][:attributes][:age]).to eq(@employee_1.age)
            end
        end

        context 'sad path' do
            it 'returns a 404 if employee not found' do
                get '/api/v1/employees/notarealemployee'

                expect(response.status).to eq(404)
            end
        end
    end

    describe 'the employee create' do 
        context 'happy path' do
            it 'creates an employee and posts to the database' do
                employee_params = { first_name: "John", last_name: "Doe", phone: "1234567896", email: "john3@gmail.com", location: "Location 4", skills: ["skill1", "skill2"], bio: "Bio 4", age: "25" }
                post '/api/v1/employees', params: employee_params

                expect(response).to be_successful
                expect(Employee.count).to eq(4)
            end
        end

        context 'sad path' do
            it 'returns a 422 if the employee is missing params' do
                employee_params = { last_name: "Doe", phone: "1234567896", email: "john30@gmail.com", location: "Location 4", skills: ["skill1", "skill2"], bio: "Bio 4" }
                post '/api/v1/employees', params: employee_params
                
                expect(response.status).to eq(422)
            end

            it 'returns a 422 if the employee email/phone already exists' do
                employee_params = { first_name: "John", last_name: "Doe", phone: @employee_1.phone, email: @employee_1.email, location: "Location 4", skills: ["skill1", "skill2"], bio: "Bio 4", age: "25" }
                post '/api/v1/employees', params: employee_params

                expect(response.status).to eq(422)
            end
        end

    end

    describe 'the employee update' do
        context 'happy path' do
            it 'updates an employee' do
                employee_params = { first_name: "patched first", last_name: "patched last" }
                patch "/api/v1/employees/#{@employee_1.id}", params: employee_params

                expect(response).to be_successful
                employee = JSON.parse(response.body, symbolize_names: true)
                expect(employee[:data][:attributes][:first_name]).to eq(employee_params[:first_name])
                expect(employee[:data][:attributes][:last_name]).to eq(employee_params[:last_name])
            end
        end
    end

    describe 'the employee destroy' do
        it 'deletes an employee' do
            delete "/api/v1/employees/#{@employee_1.id}"

            expect(response).to be_successful
            expect(Employee.count).to eq(2)
        end

        it 'returns a 404 if employee not found' do
            delete '/api/v1/employees/notarealemployee'

            expect(response.status).to eq(404)
        end
    end
end