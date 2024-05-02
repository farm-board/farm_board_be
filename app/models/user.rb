class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_one :farm
  has_one :employee
  enum role_type: { no_role: 0, farm: 1, employee: 2 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
        :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  def employee_destruction
    employee.references.destroy_all if employee&.references
    employee.experiences.destroy_all if employee&.experiences
    employee.destroy if employee
  end

  def farm_destruction
    farm.accommodation.destroy if farm&.accommodation
    farm.postings.destroy_all if farm&.postings
    farm.destroy if farm
  end

end
