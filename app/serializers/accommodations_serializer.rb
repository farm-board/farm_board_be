class AccommodationsSerializer
  include JSONAPI::Serializer
  attributes :housing, :transportation, :meals, :images
end
