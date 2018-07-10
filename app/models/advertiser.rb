class Advertiser < ApplicationRecord
  validates :profile_id, uniqueness: true, numericality: { only_integer: true }

  has_one :ethereum_wallet, as: :userable
end
