require 'rails_helper'

RSpec.describe Farm, type: :model do
  describe "Relationships" do
    it { should have_many :postings }
    it { should have_many(:posting_employees).through(:postings) }
  end
end
