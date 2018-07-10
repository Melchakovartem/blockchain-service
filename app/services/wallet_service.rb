class WalletService
  class << self
    def create(params)
      model = params[:profile_type].capitalize.constantize
      profile = model.create(profile_id: params[:profile_id])
      profile.create_ethereum_wallet(private_hex: key.private_hex, public_hex: key.public_hex, 
                            address: key.address)
      return profile
    end

    def update(params)
      model = params[:profile_type].capitalize.constantize
      profile = model.find_by_profile_id!(params[:profile_id])
      profile.ethereum_wallet.update(private_hex: key.private_hex, public_hex: key.public_hex, address: key.address)
    end

    private

      def key
        Eth::Key.new
      end
  end
end