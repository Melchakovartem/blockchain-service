class WalletService
  class << self
    TOKEN_FOR_APPROVE = 10**25

    def create(profile_id, profile_type, *params)
      @client = EthereumClient.new(Settings.http_path) 
      @profile = create_model_and_wallet(profile_id, profile_type)
      send_ether
      approve_tokens(Settings.owner)

      if profile_type == "Owner" and params.first[:root] == "false" 
        DeployContractService.call(params.first[:referrer_profile_id], profile_id)
      end

      return @profile
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

      def create_model_and_wallet(profile_id, profile_type)
        model = profile_type.capitalize.constantize   
        profile = model.create(profile_id: profile_id)
        key = Eth::Key.new
        profile.create_ethereum_wallet(private_hex: key.private_hex, 
                                       public_hex: key.public_hex, address: key.address)
        return profile
      end

      def send_ether
        key = Eth::Key.new(priv: Settings.priv_hex)
        address = @profile.ethereum_wallet.address
        @client.eth_send_transaction({from: key.address, to: address, value: 0.01 * EthereumClient::WEI_IN_ETHER })
      end

      def approve_tokens(spender)
        private_hex = @profile.ethereum_wallet.private_hex
        key = Eth::Key.new(priv: private_hex)
        owner = spender[2..42]
        data = perform_data('approve(address,uint256)', owner, TOKEN_FOR_APPROVE)
        args = perform_args(key, data)    
        tx = Eth::Tx.new(args)
        tx.sign key
        @client.eth_send_raw_transaction(tx.hex)["result"]
      end

      def perform_data(name_method, spender, amount)
        hex =  Digest::SHA3.new(256).digest(name_method)
        method_id = hex.unpack('H*')[0][0..7]
        hex_amount = (amount).to_s.to_i(10).to_s(16)
        zero_amount = 64 - hex_amount.size
        method_id + "0" * 24 + spender + "0" * zero_amount + hex_amount
      end

      def perform_args(key, data)
        chain_id = @client.net_version["result"].to_i
        args = { 
          nonce: @client.get_nonce(key.address), 
          gas_price: @client.gas_price, 
          gas_limit: @client.gas_limit,  
          to: Settings.token_address, 
          value: 0, 
          data: data, 
          chainId: chain_id
          }
      end
  end
end