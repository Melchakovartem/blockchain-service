class CreateAddressService
  class << self
    def call
      key = Eth::Key.new
      EthereumWallet.create(private_hex: key.private_hex, public_hex: key.public_hex, address: key.address)
      return key.address
    end
  end
end