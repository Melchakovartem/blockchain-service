class EthereumWallet < ApplicationRecord
  belongs_to :userable, polymorphic: true
end
