require "rails_helper"

RSpec.describe "Postings requests", type: :request do
  before do
    @farm = Farm.create(name: "Farm 1", location: "Location 1", email: "Email 1", phone: "Phone 1", image: "Image 1", bio: "Bio 1")

    @posting_1 = @farm.postings.create!(title: "Job Title", description: "This is what you'll be doing", salary: "$70,000", offers_lodging: true, images: "image.link", skill_requirements: ["skill 1", "skill 2", "skill 3"], duration: "3 years", age_requirement: 21, payment_type: "salary")

    @posting_2 = @farm.postings.create!(title: "Job Title 2", description: "This is what you'll also be doing", salary: "$25.50", offers_lodging: false, images: "image.link", skill_requirements: ["skill 4", "skill 5", "skill 6"], duration: "3 months", age_requirement: 16, payment_type: "hourly")

    @posting_3 = @farm.postings.create!(title: "Job Title 3", description: "This is what you'll be doing all over again", salary: "$6,000", offers_lodging: true, images: "image.link", skill_requirements: ["skill 7", "skill 8", "skill 9"], duration: "6 months", age_requirement: 18, payment_type: "contract")
  end

  describe "the posting index" do
    it "returns all postings" do
      get "/api/v1/farms/#{@farm.id}/postings"

      expect(response).to have_http_status(:success)
      postings = JSON.parse(response.body, symbolize_names: true)
      expect(postings[:data].count).to eq(3)
      expect(postings[:data][0][:attributes]).to have_key(:title)
      expect(postings[:data][0][:attributes]).to have_key(:description)
      expect(postings[:data][0][:attributes]).to have_key(:salary)
      expect(postings[:data][0][:attributes]).to have_key(:offers_lodging)
      expect(postings[:data][0][:attributes]).to have_key(:images)
      expect(postings[:data][0][:attributes]).to have_key(:skill_requirements)
      expect(postings[:data][0][:attributes]).to have_key(:duration)
      expect(postings[:data][0][:attributes]).to have_key(:age_requirement)
      expect(postings[:data][0][:attributes]).to have_key(:payment_type)
    end
  end

  describe 'the postings show' do
    context 'happy path' do
      it 'returns one posting' do
        get "/api/v1/farms/#{@farm.id}/postings/#{@posting_1.id}"

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
        get "/api/v1/farms/#{@farm.id}/postings/notarealposting"

        expect(response.status).to eq(404)
      end
    end
  end

  describe 'the posting create' do
    context 'happy path' do
      it 'creates a job posting and posts to the database' do
        expect(@farm.postings.count).to eq(3)

        posting_params = { title: "Job Title4", description: "This is what you'll be doing forever", salary: "$600,000", offers_lodging: false, images: "image.
        link", skill_requirements: ["skill 10", "skill 11", "skill 12"], duration: "100 years", age_requirement: 21, payment_type: "salary" }

        post "/api/v1/farms/#{@farm.id}/postings", params: posting_params

        expect(response).to be_successful
        expect(@farm.postings.count).to eq(4)
      end
    end

    context 'sad path' do
      it 'returns a 422 if the farm is missing params' do
        expect(@farm.postings.count).to eq(3)

        posting_params = { description: "This is what you'll be doing forever", salary: "$600,000", offers_lodging: false, images: "image.
        link", skill_requirements: ["skill 10", "skill 11", "skill 12"], duration: "100 years", age_requirement: 21, payment_type: "salary" }

        post "/api/v1/farms/#{@farm.id}/postings", params: posting_params

        expect(response.status).to eq(422)
        expect(@farm.postings.count).to eq(3)
      end
    end
  end

  describe 'the posting update' do
    context 'happy path' do
      it 'updates the posting with the given params' do
        posting_params = { title: "patched title", age_requirement: 16, skill_requirements: ["patched skill 1", "patched skill 2", "patched skill 3"] }

        patch "/api/v1/farms/#{@farm.id}/postings/#{@posting_1.id}", params: posting_params

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
        expect(@farm.postings.count).to eq(3)

        delete "/api/v1/farms/#{@farm.id}/postings/#{@posting_1.id}"

        expect(response).to be_successful
        expect(@farm.postings.count).to eq(2)
      end
    end

    context 'sad path' do
      it 'returns a 404 if posting not found' do
        delete "/api/v1/farms/#{@farm.id}/postings/notarealposting"

        expect(response.status).to eq(404)
        expect(@farm.postings.count).to eq(3)
      end
    end
  end
end
