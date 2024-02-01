class Employee < ApplicationRecord
  has_many :references
  has_many :experiences
end
