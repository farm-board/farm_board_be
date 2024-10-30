class Api::V1::MarketplacePostingsController < ApplicationController
  before_action :get_user

  def profile_info
    user = User.includes(:marketplace_postings).find_by(id: params[:id])
    if user.farm?

    end
  end

  def delete_all_postings
    MarketplacePostings.destroy_all
    head :no_content
  end

  def index
    marketplace_postings = @user.marketplace_postings
    render json: MarketplacePostingsSerializer.new(marketplace_postings)
  end

  def show
    marketplace_posting = @user.marketplace_postings.find(params[:id])
    render json: MarketplacePostingsSerializer.new(marketplace_posting)
  end

  def create
    marketplace_posting_attributes = marketplace_posting_params
    marketplace_posting = @user.marketplace_postings.create!(marketplace_posting_attributes)
    render json: MarketplacePostingsSerializer.new(marketplace_posting), status: :created
  end

  def update
    marketplace_posting = @user.marketplace_postings.find(params[:id])
    marketplace_posting.update!(marketplace_posting_params)
    render json: MarketplacePostingsSerializer.new(marketplace_posting), status: :accepted
  end

  def destroy
    marketplace_posting = @user.marketplace_postings.find(params[:id])
    
    marketplace_posting.gallery_photos.each do |photo|
      photo.purge 
    end
    
    marketplace_posting.destroy
    
    head :no_content
  end

  def gallery_photos
    gallery_photo_urls = @user.marketplace_postings.find_by(id: params[:id]).gallery_photos.map do |photo|
      image_path = url_for(photo)
      image_url = "https://walrus-app-bfv5e.ondigitalocean.app/farm-board-be2#{URI(image_path).path}"
      { url: image_url, id: photo.id }
    end

    render json: { gallery_photos: gallery_photo_urls }, status: :ok
  end

  def cover_photo
    photo = @user.marketplace_postings.find_by(id: params[:id]).gallery_photos.first
    image_path = url_for(photo)
    image_url = "https://walrus-app-bfv5e.ondigitalocean.app/farm-board-be2#{URI(image_path).path}"
    render json: { cover_photo: image_url }, status: :ok
  end

  def upload_gallery_photo
    marketplace_posting = @user.marketplace_postings.find_by(id: params[:marketplace_posting_id])
  
    if marketplace_posting.gallery_photos.count >= 6
      render json: { error: "Maximum number of photos reached" }, status: :unprocessable_entity
    else
      marketplace_posting.gallery_photos.attach(params[:gallery_photo])
      
      if marketplace_posting.images.nil?
        first_image_path = url_for(marketplace_posting.gallery_photos.first)
        first_image_url = "https://walrus-app-bfv5e.ondigitalocean.app/farm-board-be2#{URI(first_image_path).path}"
        marketplace_posting.update(images: first_image_url)
      end
  
      render json: { message: "Gallery photo uploaded successfully" }, status: :ok
    end
  end

  def delete_gallery_photo
    photo = @user.marketplace_postings.find_by(id: params[:marketplace_posting_id]).gallery_photos.find_by(id: params[:photo_id])
    if photo
      photo.purge
      render json: { message: "Photo deleted successfully" }, status: :ok
    else
      render json: { error: "Photo not found" }, status: :not_found
    end
  end

  def update_gallery_photo
    photo = @user.marketplace_postings.find_by(id: params[:marketplace_posting_id]).gallery_photos.find_by(id: params[:photo_id])
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

  def marketplace_posting_params
    params.require(:marketplace_posting).permit(:title, :price, :description, :condition)
  end

  def photo_params
    params.require(:photo).permit(:title, :description, :tags)
  end
end
