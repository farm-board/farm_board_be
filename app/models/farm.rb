class Farm < ApplicationRecord
  has_one :accommodation
  has_many :postings
  has_many :posting_employees, through: :postings

  validates :name, presence: true
  validates :location, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :image,
  validates :bio, presence: true

end
