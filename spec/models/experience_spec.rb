require 'rails_helper'

RSpec.describe Experience, type: :model do
  describe "Relationships" do
    it { should belong_to :employee }
  end
end
