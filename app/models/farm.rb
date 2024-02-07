class Farm < ApplicationRecord
  has_one :accommodation
  has_many :postings
  has_many :posting_employees, through: :postings
end
