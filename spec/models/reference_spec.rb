require 'rails_helper'

RSpec.describe Reference, type: :model do
  describe "Relationships" do
    it { should belong_to :employee }
  end
end
