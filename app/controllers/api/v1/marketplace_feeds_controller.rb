class Api::V1::MarketplaceFeedsController < ApplicationController
  def show
    @marketplace_postings = MarketplacePosting
      .left_joins(:user => [:farm, :employee])
      .select(
        'marketplace_postings.*',
        'COALESCE(farms.name, CONCAT(employees.first_name, \' \', employees.last_name)) AS user_name',
        'COALESCE(farms.city, employees.city) AS user_city',
        'COALESCE(farms.state, employees.state) AS user_state',
        'COALESCE(farms.bio, employees.bio) AS user_bio',
        'COALESCE(farms.marketplace_email, employees.marketplace_email) AS user_email',
        'COALESCE(farms.marketplace_phone, employees.marketplace_phone) AS user_phone',
        'COALESCE(farms.image, employees.image) AS user_image'
      )
      .page(params[:page])
      .per(8)
    
    render json: MarketplaceFeedsSerializer.new(@marketplace_postings)
  end
end
