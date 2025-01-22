class EmployeeSerializer
  include JSONAPI::Serializer
  set_id :id
  attributes :first_name, :last_name, :city, :state, :zip_code, :skills, :bio, :age, :phone, :email, :main_image, :marketplace_phone, :marketplace_email, :setup_complete
end
