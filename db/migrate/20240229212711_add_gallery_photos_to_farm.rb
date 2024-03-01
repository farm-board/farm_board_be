class AddGalleryPhotosToFarm < ActiveRecord::Migration[7.1]
  def change
    add_column :farms, :gallery_photos, :json
  end
end
