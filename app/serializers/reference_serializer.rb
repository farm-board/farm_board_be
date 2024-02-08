class ReferenceSerializer 
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :phone, :email, :relationship
end