class Advertiser < ApplicationRecord
  validates :profile_id, uniqueness: true, numericality: { only_integer: true }

  has_one :ethereum_wallet, as: :userable

  def self.by_profile(id)
  	find_by_profile_id(id)
  end
end
