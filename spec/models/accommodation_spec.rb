require 'rails_helper'

RSpec.describe Accommodation, type: :model do
  describe "Relationships" do
    it { should belong_to :farm }
  end
end
