require "rails_helper"

RSpec.describe Api::V1::FarmsController, type: :controller do
    describe "POST #upload_image" do
      let(:user) { User.create(email: 'test@example.com', password: 'password') }
      let(:farm) { Farm.create(name: 'Test Farm', user: user) }
      let(:image_path) { Rails.root.join('spec', 'fixtures', 'test_image.jpg') }
      let(:image_file) { Rack::Test::UploadedFile.new(image_path, 'image/jpeg') }
  
      it "uploads an image to the farm" do
        # No need to sign in user as we are not using authentication in this test
  
        # Stub the current_user method to return the user
        allow(controller).to receive(:current_user).and_return(user)
  
        # POST request to upload the image
        post :upload_image, params: { user_id: user.id, farm_id: farm.id, image: image_file }
  
        expect(response).to have_http_status(:ok)
        expect(farm.reload.profile_image.attached?).to be_truthy
        expect(farm.profile_image).to be_attached
      end
    end
  end