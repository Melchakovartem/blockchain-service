class EthereumWallet < ApplicationRecord
  validates :userable_id, numericality: { only_integer: true }
  validates :userable_type, inclusion: { in: %w(Owner Advertiser), message: "not supported user type"  }

  belongs_to :userable, polymorphic: true
end
