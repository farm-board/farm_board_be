class FarmSerializer
  include JSONAPI::Serializer
  attributes :name, :location, :email, :phone, :image, :bio
end
