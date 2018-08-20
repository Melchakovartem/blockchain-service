class Transaction < ApplicationRecord
  validates :t_hash, uniqueness: true
end
