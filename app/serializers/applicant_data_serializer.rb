class ApplicantDataSerializer
  include JSONAPI::Serializer
  set_type :employee
  attributes :first_name, :last_name, :city, :state, :image_url, :created_at

  def initialize(employee_data)
    @employee_data = employee_data
  end

  def serializable_hash
    @employee_data
  end
end