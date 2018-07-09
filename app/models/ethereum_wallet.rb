class EthereumWallet < ApplicationRecord
  validates :user_id, uniqueness: true, numericality: { only_integer: true }
end
