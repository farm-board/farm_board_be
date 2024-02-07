require "rails_helper"

RSpec.describe "Farm API", type: :request do
  before do
    @farm_1 = Farm.create(name: "Farm 1", location: "Location 1", email: "Email 1", phone: "Phone 1", image: "Image 1", bio: "Bio 1")
    @farm_2 = Farm.create(name: "Farm 2", location: "Location 2", email: "Email 2", phone: "Phone 2", image: "Image 2", bio: "Bio 2")
    @farm_3 = Farm.create(name: "Farm 3", location: "Location 3", email: "Email 3", phone: "Phone 3", image: "Image 3", bio: "Bio 3")
  end

  describe "the farm index" do
    it "returns all farms" do
      get "/api/v1/farms"

      expect(response).to have_http_status(:success)
      farms = JSON.parse(response.body, symbolize_names: true)
      expect(farms[:data].count).to eq(3)
      expect(farms[:data][0][:attributes]).to have_key(:name)
      expect(farms[:data][0][:attributes]).to have_key(:location)
      expect(farms[:data][0][:attributes]).to have_key(:email)
      expect(farms[:data][0][:attributes]).to have_key(:phone)
      expect(farms[:data][0][:attributes]).to have_key(:image)
      expect(farms[:data][0][:attributes]).to have_key(:bio)
    end
  end

  describe 'the farms show' do
    context 'happy path' do
      it 'returns one farm' do
        get "/api/v1/farms/#{@farm_1.id}"

        expect(response).to be_successful
        farm = JSON.parse(response.body, symbolize_names: true)
        expect(farm[:data][:attributes][:name]).to eq(@farm_1.name)
        expect(farm[:data][:attributes][:location]).to eq(@farm_1.location)
        expect(farm[:data][:attributes][:email]).to eq(@farm_1.email)
        expect(farm[:data][:attributes][:phone]).to eq(@farm_1.phone)
        expect(farm[:data][:attributes][:image]).to eq(@farm_1.image)
        expect(farm[:data][:attributes][:bio]).to eq(@farm_1.bio)
      end
    end

    context 'sad path' do
      it 'returns a 404 if farm not found' do
        get '/api/v1/farms/notarealfarm'

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'the farm create' do
    context 'happy path' do
      it 'creates a farm and posts to the database' do
        farm_params = { name: "Dylan's Farm", location: "Colorado", email: "fake4@fake.com", phone: "1234566", image: "image here", bio: "bio here" }
        post '/api/v1/farms', params: farm_params

        expect(response).to be_successful
        expect(Farm.count).to eq(4)
      end
    end

    context 'sad path' do
      it 'returns a 422 if the farm is missing params' do
        farm_params = { location: "Colorado", email: "fake4@fake.com", phone: "12345667", image: "image here", bio: "bio here" }
        post '/api/v1/farms', params: farm_params

        expect(response.status).to eq(422)
      end

      it 'returns a 404 if the farm email/phone already exists' do
        farm_params = { name: "Dylan's Farm", location: "Colorado", email: @farm_1.email, phone: @farm_1.phone, image: "image here", bio: "bio here" }
        post '/api/v1/farms', params: farm_params

        expect(response.status).to eq(422)
      end
    end
  end

  describe 'the farm update' do
    context 'happy path' do
      it 'updates the farm with the given params' do
        farm_params = { name: "patched name", location: "patched location" }
        patch "/api/v1/farms/#{@farm_1.id}", params: farm_params

        expect(response).to be_successful
        farm = JSON.parse(response.body, symbolize_names: true)
        expect(farm[:data][:attributes][:name]).to eq(farm_params[:name])
        expect(farm[:data][:attributes][:location]).to eq(farm_params[:location])
      end
    end

    context 'sad path' do
      it 'returns a 404 if the email already exists' do
        farm_params = { email: @farm_2.email }
        patch "/api/v1/farms/#{@farm_1.id}", params: farm_params

        expect(response.status).to eq(422)
      end
    end
  end

  describe 'the farm destroy' do
    context 'happy path' do
      it 'can delete a farm' do
        delete "/api/v1/farms/#{@farm_1.id}"

        expect(response).to be_successful
        expect(Farm.count).to eq(2)
      end
    end

    context 'sad path' do
      it 'returns a 404 if farm not found' do
        delete "/api/v1/farms/notarealid"

        expect(response.status).to eq(404)
      end
    end
  end
end
