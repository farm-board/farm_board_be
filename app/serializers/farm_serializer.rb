class FarmSerializer
  include JSONAPI::Serializer
  set_id :id
  attributes :name, :city, :state, :zip_code, :image, :bio, :id, :marketplace_phone, :marketplace_email, :setup_complete
end
