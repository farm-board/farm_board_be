class EmployeeSerializer
  include JSONAPI::Serializer
  attributes :first_name, :last_name, :phone, :email, :location, :skills, :bio, :age
end