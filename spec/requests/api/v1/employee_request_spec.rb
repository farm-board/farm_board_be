require 'rails_helper'

RSpec.describe "Employee API", type: :request do
  before do
    @user_1 = User.create(email: "user1@example.com", password: "password1", password_confirmation: "password1", jti: SecureRandom.uuid, role_type: 2)
    @user_2 = User.create(email: "user2@example.com", password: "password2", password_confirmation: "password2", jti: SecureRandom.uuid, role_type: 2)
    @user_3 = User.create(email: "billy@gmail.com", password: "password3", password_confirmation: "password3", jti: SecureRandom.uuid, role_type: 2)

    @employee_1 = Employee.create(first_name: "First 1", last_name: "Last 1", city: "City 1", state: "State 1", zip_code: "80020", skills: ["skill1", "skill2"], bio: "Bio 1", age: "25", user: @user_1)
    @employee_2 = Employee.create(first_name: "First 2", last_name: "Last 2", city: "City 2", state: "State 2", zip_code: "80021", skills: ["skill1", "skill2"], bio: "Bio 2", age: "25", user: @user_2)
    @employee_3 = Employee.create(first_name: "First 3", last_name: "Last 3", city: "City 3", state: "State 3", zip_code: "80022", skills: ["skill1", "skill2"], bio: "Bio 3", age: "25", user: @user_3)
  end

  describe "the employee keys" do
    it "returns employees keys" do
      get "/api/v1/users/#{@user_1.id}/employees"

      expect(response).to have_http_status(:success)
      employees = JSON.parse(response.body, symbolize_names: true)
      expect(employees[:data][:attributes]).to have_key(:first_name)
      expect(employees[:data][:attributes]).to have_key(:last_name)
      expect(employees[:data][:attributes]).to have_key(:city)
      expect(employees[:data][:attributes]).to have_key(:state)
      expect(employees[:data][:attributes]).to have_key(:zip_code)
      expect(employees[:data][:attributes]).to have_key(:skills)
      expect(employees[:data][:attributes]).to have_key(:bio)
      expect(employees[:data][:attributes]).to have_key(:age)
    end

    it 'returns employee attributes' do
      get "/api/v1/users/#{@user_1.id}/employees"

      expect(response).to be_successful
      employee = JSON.parse(response.body, symbolize_names: true)
      expect(employee[:data][:attributes][:first_name]).to eq(@employee_1.first_name)
      expect(employee[:data][:attributes][:last_name]).to eq(@employee_1.last_name)
      expect(employee[:data][:attributes][:city]).to eq(@employee_1.city)
      expect(employee[:data][:attributes][:state]).to eq(@employee_1.state)
      expect(employee[:data][:attributes][:zip_code]).to eq(@employee_1.zip_code)
      expect(employee[:data][:attributes][:skills]).to eq(@employee_1.skills)
      expect(employee[:data][:attributes][:bio]).to eq(@employee_1.bio)
      expect(employee[:data][:attributes][:age]).to eq(@employee_1.age)
    end
  end

  describe 'the employee update' do
    context 'happy path' do
      it 'updates an employee' do
        employee_params = { first_name: "patched first", last_name: "patched last" }
        patch "/api/v1/users/#{@user_1.id}/employees", params: employee_params, as: :json

        expect(response).to be_successful

        @employee_1.reload

        expect(@employee_1.first_name).to eq("patched first")
        expect(@employee_1.last_name).to eq("patched last")
      end
    end
  end
end
