class Employee < ApplicationRecord
  belongs_to :user
  has_many :references, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_one_attached :main_image, dependent: :destroy
  validates :first_name, :last_name, :city, :zip_code, :phone, :email, :bio, :marketplace_email, :marketplace_phone,  profanity: true
end
