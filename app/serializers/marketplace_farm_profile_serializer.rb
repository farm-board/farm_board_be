class MarketplaceFarmProfileSerializer
  include JSONAPI::Serializer

  def initialize(user_data)
    @user_data = user_data
  end

  def serializable_hash
    {
      attributes: {
        name: @user_data["name"],
        city: @user_data["city"],
        state: @user_data["state"],
        zip_code: @user_data["zip_code"],
        bio: @user_data["bio"],
        image_url: @user_data[:image_url],
        marketplace_phone: @user_data["marketplace_phone"],
        marketplace_email: @user_data["marketplace_email"],
        role_type: "farm"
      },
      marketplace_postings: @user_data[:marketplace_postings],
    }
  end
end