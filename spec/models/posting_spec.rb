require 'rails_helper'

RSpec.describe Posting, type: :model do
  describe "Relationships" do
    it { should belong_to :farm }
    it { should have_many :posting_employees }
  end
end
