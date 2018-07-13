class WalletService
  class << self
    def create(profile_id, profile_type, *params)
      profile = model_create(profile_id, profile_type)
      profile.create_ethereum_wallet(private_hex: key.private_hex, public_hex: key.public_hex, 
                            address: key.address)
      
      send_ether(profile.ethereum_wallet.address)

      if profile_type == "Owner" and params.first[:root] == "false" 
        DeployContractService.call(params.first[:referrer_profile_id], profile_id)
      end

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

      def model_create(profile_id, profile_type)
        model = profile_type.capitalize.constantize   
        profile = model.create(profile_id: profile_id)
      end

      def send_ether(address)
        client = EthereumClient.new(Settings.http_path)
        key = Eth::Key.new(priv: Rails.application.secrets.priv_hex)
        client.eth_send_transaction({from: key.address, to: address, value: 0.01 * EthereumClient::WEI_IN_ETHER })
      end
  end
end