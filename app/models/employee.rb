class Employee < ApplicationRecord
  belongs_to :user
  has_many :references
  has_many :experiences
end
