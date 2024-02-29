class Api::V1::FarmsController < ApplicationController
  before_action :get_user
 

  # GET /api/v1/users/:user_id/farms
  def index
    render json: FarmSerializer.new(Farm.all)
  end

  # GET /api/v1/users/:user_id/farms/:id
  def show
    render json: FarmSerializer.new(@user.farm)
  end

  # POST /api/v1/users/:user_id/farms/:id/upload_image
  def upload_image
    @farm = Farm.find_by(id: params[:farm_id])
    unless @farm
      render json: { error: "Farm not found" }, status: :not_found
      return
    end

    @farm.profile_image.attach(params[:image])

    render json: { message: "Image uploaded successfully" }, status: :ok
  end

  # GET /api/v1/users/:user_id/farms/:id/image
  def show_image
    @farm = Farm.find_by(id: params[:id])
    unless @farm && @farm.profile_image.attached?
      render json: { error: "Image not found" }, status: :not_found
      return
    end

    image_url = url_for(@farm.profile_image)

    render json: { image_url: image_url }, status: :ok
  end

  # GET /api/v1/users/:user_id/farms/:id/gallery_photos
  def gallery_photos
    @farm = Farm.find_by(id: params[:id])
    unless @farm
      render json: { error: "Farm not found" }, status: :not_found
      return
    end

    gallery_photo_urls = @farm.gallery_photos.map do |photo|
      url_for(photo)
    end

    render json: { gallery_photos: gallery_photo_urls }, status: :ok
  end

  # POST /api/v1/users/:user_id/farms/:id/upload_gallery_photo
  def upload_gallery_photo
    @farm = Farm.find_by(id: params[:farm_id])
    unless @farm
      render json: { error: "Farm not found" }, status: :not_found
      return
    end

    if @farm.gallery_photos.count >= 6
      render json: { error: "Maximum number of photos reached" }, status: :unprocessable_entity
      return
    end

    @farm.gallery_photos.attach(params[:gallery_photo])

    render json: { message: "Gallery photo uploaded successfully" }, status: :ok
  end

  # PATCH/PUT /api/v1/users/:user_id/farms/:id
  def update
    if @farm.update(farm_params)
      render json: FarmSerializer.new(@farm), status: :accepted
    else
      render json: { errors: @farm.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/users/:user_id/farms/:id
  def destroy
    @farm.destroy
    head :no_content
  end

  private

  def get_user
    @user = User.find(params[:user_id])
  end

  def farm_params
    params.require(:farm).permit(:name, :city, :state, :zip_code, :bio)
  end
end
