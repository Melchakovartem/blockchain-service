class TokenService

  def initialize(priv_key)
    @client = EthereumClient.new(Settings.http_path)
    @private_key = priv_key
    @address = Eth::Key.new(priv: @private_key).address
    @wetoken = Contract.find_by_name("wetoken")
    @deal = Contract.find_by_name("deal")
    @contract = @client.set_contract(@wetoken.name, @wetoken.address, @wetoken.abi)
    @contract.sender = Settings.owner 
  end

  def get_tokens(amount)
    @contract.transact.transfer(@address, amount.to_i)
  end

  def get_balance
    @contract.call.balance_of(@address)
  end

  def get_allowance
    @contract.call.allowance(@address, @deal.address)
  end
    
  def approve(amount)
    key = Eth::Key.new(priv: @private_key)

    spender = @deal.address

    data = perform_data('approve(address,uint256)', spender[2..42], amount)

    args = perform_args(key, data) 

    tx = Eth::Tx.new(args)
    tx.sign key

    @client.eth_send_raw_transaction(tx.hex)["result"]
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
          to: @wetoken.address, 
          value: 0, 
          data: data, 
          chainId: chain_id
          }
      end

end