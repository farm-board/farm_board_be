class Api::V1::FarmsController < ApplicationController
  before_action :get_farm, only: [:show, :update, :destroy, :upload_image, :show_image, :delete_image, :gallery_photos, :upload_gallery_photo, :delete_gallery_photo, :update_gallery_photo]

  def profile_info
    farm = Farm.includes(:accommodation, :postings).find_by(id: params[:id])
    if farm.nil?
      render json: { error: "Farm not found" }, status: :not_found
      return
    end

    image_url = farm.profile_image.attached? ? url_for(farm.profile_image) : nil

    gallery_photos = if farm.gallery_photos.attached?
                       farm.gallery_photos.map do |photo|
                         { url: url_for(photo), id: photo.id }
                       end
                     else
                       []
                     end

    farm_data = farm.as_json(only: [:id, :name, :city, :state, :zip_code, :bio]).merge(
      image_url: image_url,
      accommodations: farm.accommodation,
      gallery_photos: gallery_photos,
      postings: farm.postings
    )

    render json: FarmProfileSerializer.new(farm_data).serializable_hash
  end

  # GET /api/v1/users/:user_id/farms
  def index
    farms = Farm.includes(:accommodation, :postings).all
    render json: FarmSerializer.new(farms)
  end

  # GET /api/v1/users/:user_id/farms/:id
  def show
    render json: FarmSerializer.new(@farm)
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

  # POST /api/v1/users/:user_id/farms/:id/upload_image
  def upload_image
    @farm.profile_image.attach(params[:image])
    render json: { message: "Image uploaded successfully" }, status: :ok
  end

  # GET /api/v1/users/:user_id/farms/:id/image
  def show_image
    if @farm.profile_image.attached?
      image_path = url_for(@farm.profile_image)
      image_url = "https://walrus-app-bfv5e.ondigitalocean.app/farm-board-be2#{URI(image_path).path}"
      render json: { image_url: image_url }, status: :ok
    else
      render json: { error: "Image not found" }, status: :not_found
    end
  end

  # DELETE /api/v1/users/:user_id/farms/:id/delete_image
  def delete_image
    if @farm.profile_image.attached?
      @farm.profile_image.purge
      render json: { message: "Image deleted successfully" }, status: :ok
    else
      render json: { error: "No image attached to delete" }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/users/:user_id/farms/:id/gallery_photos
  def gallery_photos
    gallery_photo_urls = @farm.gallery_photos.map do |photo|
      image_path = url_for(photo)
      image_url = "https://walrus-app-bfv5e.ondigitalocean.app/farm-board-be2#{URI(image_path).path}"
      { url: image_url, id: photo.id }
    end

    render json: { gallery_photos: gallery_photo_urls }, status: :ok
  end

  # POST /api/v1/users/:user_id/farms/:id/upload_gallery_photo
  def upload_gallery_photo
    if @farm.gallery_photos.count >= 6
      render json: { error: "Maximum number of photos reached" }, status: :unprocessable_entity
    else
      @farm.gallery_photos.attach(params[:gallery_photo])
      render json: { message: "Gallery photo uploaded successfully" }, status: :ok
    end
  end

  # DELETE /api/v1/users/:user_id/farms/:id/gallery_photos/:photo_id
  def delete_gallery_photo
    photo = @farm.gallery_photos.find_by(id: params[:photo_id])
    if photo
      photo.purge
      render json: { message: "Photo deleted successfully" }, status: :ok
    else
      render json: { error: "Photo not found" }, status: :not_found
    end
  end

  # PATCH /api/v1/users/:user_id/farms/:id/gallery_photos/:photo_id
  def update_gallery_photo
    photo = @farm.gallery_photos.find_by(id: params[:photo_id])
    if photo.update(photo_params)
      render json: { message: "Photo updated successfully" }, status: :ok
    else
      render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def get_farm
    @user = User.find(params[:user_id])
    @farm = @user.farm
  end

  def farm_params
    params.require(:farm).permit(:name, :city, :state, :zip_code, :bio, :setup_complete)
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :tags)
  end
end