class Employee < ApplicationRecord
  belongs_to :user
  has_many :references, dependent: :destroy
  has_many :experiences, dependent: :destroy
  has_one_attached :main_image, dependent: :destroy
end
