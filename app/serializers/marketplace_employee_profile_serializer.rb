class MarketplaceEmployeeProfileSerializer
  include JSONAPI::Serializer

  def initialize(user_data)
    @user_data = user_data
  end

  def serializable_hash
    {
      attributes: {
        first_name: @user_data["first_name"],
        last_name: @user_data["last_name"],
        city: @user_data["city"],
        state: @user_data["state"],
        zip_code: @user_data["zip_code"],
        bio: @user_data["bio"],
        created_at: @user_data["created_at"],
        updated_at: @user_data["updated_at"],
        image_url: @user_data[:image_url],
        phone: @user_data["phone"],
        email: @user_data["email"],
        marketplace_phone: @user_data["marketplace_phone"],
        marketplace_email: @user_data["marketplace_email"],
        role_type: "employee"
      },
      marketplace_postings: @user_data[:marketplace_postings]
    }
  end
end