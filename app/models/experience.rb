class Experience < ApplicationRecord
  belongs_to :employee
  validates :company_name, :started_at, :ended_at, :description, profanity: true
end
