class PostingEmployee < ApplicationRecord
  belongs_to :posting
  belongs_to :employee
end
