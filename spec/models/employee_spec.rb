require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe "Relationships" do
    it { should have_many :references }
    it { should have_many :experiences }
  end
end
