class PostingsSerializer
  include JSONAPI::Serializer
  attributes :title, :description, :salary, :offers_lodging, :images, :skill_requirements, :duration, :age_requirement, :payment_type
end
