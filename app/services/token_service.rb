class TokenService

  def initialize(profile_id, profile_type)
    @client = EthereumClient.new(Settings.http_path)
    model = profile_type.capitalize.constantize
    @profile = model.find_by_profile_id!(profile_id)
    @contract = @client.set_contract(Settings.token_name, Settings.token_address, Settings.token_abi)   
  end
    
  def approve(spender, amount)
    private_hex = @profile.ethereum_wallet.private_hex
    key = Eth::Key.new(priv: private_hex)
    spender = spender[2..42]
    data = perform_data('approve(address,uint256)', spender, amount)
    args = perform_args(key, data)    
    tx = Eth::Tx.new(args)
    tx.sign key
    @client.eth_send_raw_transaction(tx.hex)["result"]
  end

  def get_tokens(amount)
    address = @profile.ethereum_wallet.address
    @contract.transact.transfer(address, amount)
  end

  def get_balance
    address = @profile.ethereum_wallet.address
    @contract.call.balance_of(address)
  end

  def get_allowance(spender)
    address = @profile.ethereum_wallet.address
    @contract.call.allowance(address, spender)
  end

  private

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