class Employee < ApplicationRecord
  belongs_to :user
  has_many :references
  has_many :experiences
  has_one_attached :main_image
end
