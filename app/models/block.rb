class Block < ApplicationRecord
  validates :b_number, uniqueness: true
  serialize :b_transactions
end
