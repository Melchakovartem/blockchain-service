class CreateWalletService
  class << self
    def call(user_id)
      key = Eth::Key.new
      wallet = EthereumWallet.create(private_hex: key.private_hex, public_hex: key.public_hex, address: key.address, user_id: user_id)
    end
  end
end