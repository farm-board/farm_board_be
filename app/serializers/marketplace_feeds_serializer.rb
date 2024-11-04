class MarketplaceFeedsSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :description, :condition, :images, :created_at, :updated_at, :user_id, :user_name, :user_city, :user_state, :user_bio, :user_image
end