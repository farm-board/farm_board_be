class EmployeeProfileSerializer
  include JSONAPI::Serializer
  set_type :employee

  def initialize(employee_data)
    @employee_data = employee_data
  end

  def serializable_hash
    {
      attributes: {
        first_name: @employee_data["first_name"],
        last_name: @employee_data["last_name"],
        city: @employee_data["city"],
        state: @employee_data["state"],
        zip_code: @employee_data["zip_code"],
        skills: @employee_data["skills"],
        bio: @employee_data["bio"],
        created_at: @employee_data["created_at"],
        updated_at: @employee_data["updated_at"],
        age: @employee_data["age"],
        image_url: @employee_data[:image_url]
      },
      experiences: @employee_data[:experiences],
      references: @employee_data[:references]
    }
  end
end