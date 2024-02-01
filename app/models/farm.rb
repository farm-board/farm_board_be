class Farm < ApplicationRecord
  has_many :postings
  has_many :posting_employees, through: :postings
end
