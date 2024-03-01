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
  
  ### AWS S3 Controller Methods ###
  
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

  # DELETE /api/v1/users/:user_id/farms/:id/delete_image
  def delete_image
    @farm = Farm.find_by(id: params[:id])
    unless @farm
      render json: { error: "Farm not found" }, status: :not_found
      return
    end

    if @farm.profile_image.attached?
      @farm.profile_image.purge  
      render json: { message: "Image deleted successfully" }, status: :ok
    else
      render json: { error: "No image attached to delete" }, status: :unprocessable_entity
    end
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

  # DELETE /api/v1/users/:user_id/farms/:id/gallery_photos/:photo_id
  def delete_gallery_photo
    @farm = Farm.find_by(id: params[:id])
    unless @farm
      render json: { error: "Farm not found" }, status: :not_found
      return
    end

    photo = @farm.gallery_photos.find_by(id: params[:photo_id])
    unless photo
      render json: { error: "Photo not found" }, status: :not_found
      return
    end

    photo.purge 

    render json: { message: "Photo deleted successfully" }, status: :ok
  end

  # PATCH /api/v1/users/:user_id/farms/:id/gallery_photos/:photo_id
  def update_gallery_photo
    @farm = Farm.find_by(id: params[:id])
    unless @farm
      render json: { error: "Farm not found" }, status: :not_found
      return
    end

    photo = @farm.gallery_photos.find_by(id: params[:photo_id])
    unless photo
      render json: { error: "Photo not found" }, status: :not_found
      return
    end

    if photo.update(photo_params)
      render json: { message: "Photo updated successfully" }, status: :ok
    else
      render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def get_user
    @user = User.find(params[:user_id])
  end

  def farm_params
    params.require(:farm).permit(:name, :city, :state, :zip_code, :bio)
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :tags)
  end
end
