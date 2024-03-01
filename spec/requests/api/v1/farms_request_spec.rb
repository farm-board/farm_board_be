require "rails_helper"

RSpec.describe "Farm API", type: :request do
  before do
    @user_1 = User.create(email: "user1@example.com", password: "password1", password_confirmation: "password1", jti: SecureRandom.uuid, role_type: 1)
    @user_2 = User.create(email: "user2@example.com", password: "password2", password_confirmation: "password2", jti: SecureRandom.uuid, role_type: 1)
    @user_3 = User.create(email: "billy@gmail.com", password: "password3", password_confirmation: "password3", jti: SecureRandom.uuid, role_type: 1)

    @farm_1 = Farm.create(name: "Farm 1", city: "City 1", state: "State 1", zip_code: "80020", image: "Image 1", bio: "Bio 1", user: @user_1)
    @farm_2 = Farm.create(name: "Farm 2", city: "City 2", state: "State 2", zip_code: "80021", image: "Image 2", bio: "Bio 2", user: @user_2)
  end

  describe "the farm keys" do
    it "returns all farm keys" do
      get "/api/v1/users/#{@user_1.id}/farms"

      expect(response).to have_http_status(:success)
      farms = JSON.parse(response.body, symbolize_names: true)
      expect(farms[:data][:attributes]).to have_key(:name)
      expect(farms[:data][:attributes]).to have_key(:city)
      expect(farms[:data][:attributes]).to have_key(:state)
      expect(farms[:data][:attributes]).to have_key(:zip_code)
      expect(farms[:data][:attributes]).to have_key(:image)
      expect(farms[:data][:attributes]).to have_key(:bio)
    end

    it 'returns farm attributes' do
      get "/api/v1/users/#{@user_1.id}/farms"

      expect(response).to be_successful
      farm = JSON.parse(response.body, symbolize_names: true)
      expect(farm[:data][:attributes][:name]).to eq(@farm_1.name)
      expect(farm[:data][:attributes][:city]).to eq(@farm_1.city)
      expect(farm[:data][:attributes][:state]).to eq(@farm_1.state)
      expect(farm[:data][:attributes][:zip_code]).to eq(@farm_1.zip_code)
      expect(farm[:data][:attributes][:image]).to eq(@farm_1.image)
      expect(farm[:data][:attributes][:bio]).to eq(@farm_1.bio)
    end
  end

  describe 'the farm update' do
    it 'updates the farm with the given params' do
      farm_params = { name: "Updated Farm Name" }
  
      patch "/api/v1/users/#{@user_1.id}/farms", params: farm_params, as: :json
  
      expect(response).to be_successful
  
      @farm_1.reload
  
      expect(@farm_1.name).to eq("Updated Farm Name")
    end
  
    it 'returns a 404 if the farm is not found' do
      invalid_user_id = 999
      patch "/api/v1/users/#{invalid_user_id}/farms", params: { name: "Updated Farm Name" }, as: :json
  
      expect(response.status).to eq(404)
    end
  end

  describe 'the farm destroy' do
    it 'can delete a farm' do
      delete "/api/v1/users/#{@user_1.id}/farms"

      expect(response).to be_successful
      expect(Farm.count).to eq(1)
    end

    it 'returns a 404 if farm not found' do
      delete "/api/v1/farms/notarealid"

      expect(response.status).to eq(404)
    end
  end
end
