class Farm < ApplicationRecord
  belongs_to :user
  has_one :accommodation, dependent: :destroy
  has_many :postings, dependent: :destroy
  has_many :posting_employees, through: :postings, dependent: :destroy
  has_one_attached :profile_image, dependent: :destroy
  has_many_attached :gallery_photos, dependent: :destroy
end
