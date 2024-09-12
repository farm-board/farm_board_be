class MarketplaceFeedsSerializer
  include JSONAPI::Serializer
  attributes :title, :price, :description, :condition, :images, :created_at, :updated_at, :user_id
end