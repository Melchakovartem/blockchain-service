class Block < ApplicationRecord
  validates :b_number, uniqueness: true
end
