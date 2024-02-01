require 'rails_helper'

RSpec.describe PostingEmployee, type: :model do
  describe "Relationships" do
    it { should belong_to :employee }
    it { should belong_to :posting }
  end
end
