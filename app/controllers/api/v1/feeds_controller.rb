class Api::V1::FeedsController < ApplicationController
  def show
    @postings = Posting.joins(:farm).select('postings.*, farms.name as farm_name, farms.city as farm_city, farms.state as farm_state').all
    render json: FeedsSerializer.new(@postings)
  end
end
