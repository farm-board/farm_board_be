class FarmProfileSerializer
    include JSONAPI::Serializer
    set_type :farm
  
    def initialize(farm_data)
      @farm_data = farm_data
    end
  
    def serializable_hash
      {
        attributes: {
          name: @farm_data["name"],
          city: @farm_data["city"],
          state: @farm_data["state"],
          zip_code: @farm_data["zip_code"],
          bio: @farm_data["bio"],
          image_url: @farm_data[:image_url] 
        },
        accommodations: @farm_data[:accommodations],
        postings: @farm_data[:postings],
        gallery_photos: @farm_data[:gallery_photos]
      }
    end
  end