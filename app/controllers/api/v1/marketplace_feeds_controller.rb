class Api::V1::MarketplaceFeedsController < ApplicationController
  def show
    @marketplace_postings = MarketplacePosting.select('marketplace_postings.*').page(params[:page]).per(8)
    render json: MarketplaceFeedsSerializer.new(@marketplace_postings)
  end
end
