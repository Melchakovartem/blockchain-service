class EthereumWallet < ApplicationRecord
  validates :user_id, uniqueness: true, numericality: { only_integer: true }
  validates :user_type, inclusion: { in: %w(owner advertiser), message: "not supported user type"  }
end
