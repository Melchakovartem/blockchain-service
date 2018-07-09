class WalletService
  class << self
    def create(params)
      EthereumWallet.create(private_hex: key.private_hex, public_hex: key.public_hex, 
                            address: key.address, user_id: params[:user_id], user_type: params[:user_type])
    end

    def update(wallet)
      wallet.update(private_hex: key.private_hex, public_hex: key.public_hex, address: key.address)
    end

    private

      def key
        Eth::Key.new
      end
  end
end