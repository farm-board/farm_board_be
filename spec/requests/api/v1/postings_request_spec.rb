require "rails_helper"

RSpec.describe "Postings requests", type: :request do
  before do
    @user_1 = User.create(email: "user1@example.com", password: "password1", password_confirmation: "password1", jti: SecureRandom.uuid, role_type: 1)
    @user_2 = User.create(email: "user2@example.com", password: "password2", password_confirmation: "password2", jti: SecureRandom.uuid, role_type: 1)
    @user_3 = User.create(email: "billy@gmail.com", password: "password3", password_confirmation: "password3", jti: SecureRandom.uuid, role_type: 1)

    @farm_1 = Farm.create(name: "Farm 1", city: "City 1", state: "State 1", zip_code: "80020", image: "Image 1", bio: "Bio 1", user: @user_1)
    @farm_2 = Farm.create(name: "Farm 2", city: "City 2", state: "State 2", zip_code: "80021", image: "Image 2", bio: "Bio 2", user: @user_2)

    @posting_1 = Posting.create(title: "Job Title1", description: "This is what you'll be doing", salary: "$100,000", offers_lodging: true, images: "image.link", skill_requirements: ["skill 1", "skill 2", "skill 3"], duration: "1 year", age_requirement: 18, payment_type: "hourly", farm: @farm_1)
    @posting_2 = Posting.create(title: "Job Title2", description: "This is what you'll be doing", salary: "$200,000", offers_lodging: true, images: "image.link", skill_requirements: ["skill 4", "skill 5", "skill 6"], duration: "2 years", age_requirement: 19, payment_type: "hourly", farm: @farm_1)
  end

  describe "the posting index" do
    it "returns all postings" do
      get "/api/v1/users/#{@user_1.id}/farms/postings"

      expect(response).to have_http_status(:success)

      postings = JSON.parse(response.body, symbolize_names: true)

      postings[:data].each do |posting|
        expect(posting[:attributes]).to have_key(:title)
        expect(posting[:attributes]).to have_key(:description)
        expect(posting[:attributes]).to have_key(:salary)
        expect(posting[:attributes]).to have_key(:offers_lodging)
        expect(posting[:attributes]).to have_key(:images)
        expect(posting[:attributes]).to have_key(:skill_requirements)
        expect(posting[:attributes]).to have_key(:duration)
        expect(posting[:attributes]).to have_key(:age_requirement)
        expect(posting[:attributes]).to have_key(:payment_type)
      end
    end
  end

  describe 'the postings show' do
    context 'happy path' do
      it 'returns one posting' do
        get "/api/v1/users/#{@user_1.id}/farms/postings/#{@posting_1.id}"

        expect(response).to be_successful
        posting = JSON.parse(response.body, symbolize_names: true)
        expect(posting[:data][:attributes][:title]).to eq(@posting_1.title)
        expect(posting[:data][:attributes][:description]).to eq(@posting_1.description)
        expect(posting[:data][:attributes][:salary]).to eq(@posting_1.salary)
        expect(posting[:data][:attributes][:offers_lodging]).to eq(@posting_1.offers_lodging)
        expect(posting[:data][:attributes][:images]).to eq(@posting_1.images)
        expect(posting[:data][:attributes][:skill_requirements]).to eq(@posting_1.skill_requirements)
        expect(posting[:data][:attributes][:duration]).to eq(@posting_1.duration)
        expect(posting[:data][:attributes][:age_requirement]).to eq(@posting_1.age_requirement)
        expect(posting[:data][:attributes][:payment_type]).to eq(@posting_1.payment_type)
      end
    end

    context 'sad path' do
      it 'returns a 404 if farm not found' do
        get "/api/v1/users/#{@user_1.id}/farms/postings/999"

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'the posting create' do
    context 'happy path' do
      it 'creates a job posting and posts to the database' do

        posting_params = { title: "Job Title4", description: "This is what you'll be doing forever", salary: "$600,000", offers_lodging: false, images: "image.
        link", skill_requirements: ["skill 10", "skill 11", "skill 12"], duration: "100 years", age_requirement: 21, payment_type: "salary" }

        post "/api/v1/users/#{@user_1.id}/farms/postings", params: posting_params, as: :json

        expect(response).to be_successful
      end
    end

    context 'sad path' do
      it 'returns a 422 if the farm is missing params' do

        posting_params = { description: "This is what you'll be doing forever", salary: "$600,000", offers_lodging: false, images: "image.
        link", skill_requirements: ["skill 10", "skill 11", "skill 12"], duration: "100 years", age_requirement: 21, payment_type: "salary" }

        post "/api/v1/users/#{@user_1.id}/farms/postings", params: posting_params, as: :json

        expect(response.status).to eq(422)
      end
    end
  end

  describe 'the posting update' do
    context 'happy path' do
      it 'updates the posting with the given params' do
        posting_params = { title: "patched title", age_requirement: 16, skill_requirements: ["patched skill 1", "patched skill 2", "patched skill 3"] }

        patch "/api/v1/users/#{@user_1.id}/farms/postings/#{@posting_1.id}", params: posting_params, as: :json

        expect(response).to be_successful
        posting = JSON.parse(response.body, symbolize_names: true)
        expect(posting[:data][:attributes][:title]).to eq(posting_params[:title])
        expect(posting[:data][:attributes][:age_requirement]).to eq(posting_params[:age_requirement])
        expect(posting[:data][:attributes][:skill_requirements]).to eq(posting_params[:skill_requirements])
        expect(posting[:data][:attributes][:skill_requirements].count).to eq(3)
      end
    end
  end

  describe 'the posting destroy' do
    context 'happy path' do
      it 'can delete a posting' do
        expect(@user_1.farm.postings.count).to eq(2)

        delete "/api/v1/users/#{@user_1.id}/farms/postings/#{@posting_1.id}"

        expect(response).to be_successful
        expect(@user_1.farm.postings.count).to eq(1)
      end
    end

    context 'sad path' do
      it 'returns a 404 if posting not found' do
        delete "/api/v1/users/#{@user_1.id}/farms/postings/#999"

        expect(response.status).to eq(404)
        expect(@user_1.farm.postings.count).to eq(2)
      end
    end
  end
end
