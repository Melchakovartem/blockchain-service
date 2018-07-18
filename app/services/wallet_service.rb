class WalletService
  class << self
    def create(profile_id, profile_type, *params)
      profile = model_create(profile_id, profile_type)
      key = Eth::Key.new
      profile.create_ethereum_wallet(private_hex: key.private_hex, public_hex: key.public_hex, 
                            address: key.address)
      
      send_ether(profile.ethereum_wallet.address)

      approve_tokens(profile.ethereum_wallet)

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

    

      def key
        Eth::Key.new
      end

      def model_create(profile_id, profile_type)
        model = profile_type.capitalize.constantize   
        profile = model.create(profile_id: profile_id)
      end

      def send_ether(address)
        client = EthereumClient.new(Settings.http_path)
        key = Eth::Key.new(priv: Settings.priv_hex)
        client.eth_send_transaction({from: key.address, to: address, value: 0.01 * EthereumClient::WEI_IN_ETHER })
      end

      def approve_tokens(wallet)
        client = EthereumClient.new(Settings.http_path)
        key = Eth::Key.new(priv: wallet.private_hex)

        chain_id = client.net_version["result"].to_i
        owner = Settings.owner[2..42]

        args = { nonce: client.get_nonce(key.address), 
          gas_price: client.gas_price, 
          gas_limit: client.gas_limit,  
          to: Settings.token_address, 
          value: 0, 
          data: "0x095ea7b3000000000000000000000000" + owner + "00000000000000000000000000000000000000000000d3c21bcecceda1000000", chainId: chain_id }
        tx = Eth::Tx.new(args)
        tx.sign key
        client.eth_send_raw_transaction(tx.hex)["result"]
      end
  end
end