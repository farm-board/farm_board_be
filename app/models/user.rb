class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_one :farm
  has_one :employee
  enum role_type: { no_role: 0, farm: 1, employee: 2 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

end
