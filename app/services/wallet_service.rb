class WalletService
  class << self
    def create(profile_id, profile_type, *params)
      profile = model_create(profile_id, profile_type, *params)
      profile.create_ethereum_wallet(private_hex: key.private_hex, public_hex: key.public_hex, 
                            address: key.address)
      return profile
    end

    def update(profile_id, profile_type, *params)
      model = profile_type.capitalize.constantize
      profile = model.find_by_profile_id!(profile_id)
      profile.ethereum_wallet.update(private_hex: key.private_hex, public_hex: key.public_hex, address: key.address)
    end

    private

      def key
        Eth::Key.new
      end

      def model_create(profile_id, profile_type, *params)
        model = profile_type.capitalize.constantize   
        profile = model.create(profile_id: profile_id)
      end
  end
end