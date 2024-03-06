class FeedsSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :salary, :offers_lodging, :images, :skill_requirements, :duration, :age_requirement, :payment_type, :farm_name, :farm_city, :farm_state
end
