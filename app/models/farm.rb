class Farm < ApplicationRecord
  belongs_to :user
  has_one :accommodation
  has_many :postings
  has_many :posting_employees, through: :postings
end
