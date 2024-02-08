require "rails_helper"

RSpec.describe "Accommodation API", type: :request do
  before do
    @farm_1 = Farm.create(name: "Farm 1", location: "Location 1", email: "Email 1", phone: "Phone 1", image: "Image 1", bio: "Bio 1")
    @farm_2 = Farm.create(name: "Farm 2", location: "Location 2", email: "Email 2", phone: "Phone 2", image: "Image 2", bio: "Bio 2")
    @accommodation = @farm_1.build_accommodation(housing: true, transportation: false, meals: true, images: "Images.link")
    @accommodation.save
  end

  describe "the accommodation show" do
    context 'happy path' do
      it "returns the accommodation" do
        get "/api/v1/farms/#{@farm_1.id}/accommodation"

        expect(response).to have_http_status(:success)
        accommodation = JSON.parse(response.body, symbolize_names: true)
        expect(accommodation.count).to eq(1)
        expect(accommodation[:data][:attributes]).to have_key(:housing)
        expect(accommodation[:data][:attributes]).to have_key(:transportation)
        expect(accommodation[:data][:attributes]).to have_key(:meals)
        expect(accommodation[:data][:attributes]).to have_key(:images)
      end
    end

    context 'sad path' do
      it 'returns a 404 if accommodation not found' do
        get '/api/v1/farms/notarealfarm/accommodation'

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'the accommodation create' do
    context 'happy path' do
      it 'creates an accommodation and posts to the database' do
        accommodation_params = { housing: true, transportation: false, meals: true, images: "Images.link" }
        post "/api/v1/farms/#{@farm_2.id}/accommodation", params: accommodation_params

        expect(response).to be_successful
      end
    end
  end

  describe 'the accmmodation update' do
    context 'happy path' do
      it 'updates the accommodation with the given params' do
        get "/api/v1/farms/#{@farm_1.id}/accommodation"

        expect(response).to have_http_status(:success)
        accommodation_before_update = JSON.parse(response.body, symbolize_names: true)

        expect(accommodation_before_update[:data][:attributes][:housing]).to eq(true)
        expect(accommodation_before_update[:data][:attributes][:transportation]).to eq(false)

        accommodation_params = { housing: false, transportation: true }
        patch "/api/v1/farms/#{@farm_1.id}/accommodation", params: accommodation_params

        expect(response).to be_successful

        accommodation_after_update = JSON.parse(response.body, symbolize_names: true)
        expect(accommodation_after_update[:data][:attributes][:housing]).to eq(false)
        expect(accommodation_after_update[:data][:attributes][:transportation]).to eq(true)
      end
    end
  end

  describe 'the farm destroy' do
    context 'happy path' do
      it 'can delete an accommodation' do
        expect(Accommodation.count).to eq(1)

        delete "/api/v1/farms/#{@farm_1.id}/accommodation"

        expect(response).to be_successful
        expect(Accommodation.count).to eq(0)
      end
    end
  end
end
