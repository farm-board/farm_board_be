class MarketplacePosting < ApplicationRecord
  belongs_to :user
  has_many_attached :gallery_photos
end
