class Farm < ApplicationRecord
  belongs_to :user
  has_one :accommodation
  has_many :postings
  has_many :posting_employees, through: :postings
  has_one_attached :profile_image
  has_many_attached :gallery_photos
end
