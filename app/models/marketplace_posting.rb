class MarketplacePosting < ApplicationRecord
  belongs_to :user
  has_many_attached :gallery_photos, dependent: :destroy
  validates :title, :price, :description, :condition, profanity: true
end
