class Posting < ApplicationRecord
  belongs_to :farm
  has_many :posting_employees
end
