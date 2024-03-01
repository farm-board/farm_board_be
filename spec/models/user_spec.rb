require 'rails_helper'

RSpec.describe User, type: :model do
  describe "Relationships" do
    it { should have_one :employee }
    it { should have_one :farm }
  end

  describe "Validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
    it { should validate_confirmation_of :password }
  end
end
