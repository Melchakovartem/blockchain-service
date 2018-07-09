class WalletService
  class << self
    def create(user_id)
      key = Eth::Key.new
      EthereumWallet.create(private_hex: key.private_hex, public_hex: key.public_hex, address: key.address, user_id: user_id)
    end

    def update(wallet)
      key = Eth::Key.new
      wallet.update(private_hex: key.private_hex, public_hex: key.public_hex, address: key.address)
    end
  end
end