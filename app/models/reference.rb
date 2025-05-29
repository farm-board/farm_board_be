class Reference < ApplicationRecord
  belongs_to :employee
  validates :first_name, :last_name, :phone, :email, :relationship, profanity: true
end
