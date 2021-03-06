class AddressService
  class << self
    def call(params)
      params.downcase!
      client = EthereumClient.new(Settings.http_path)

      address = Transaction.where('t_from=? OR t_to=?', params, params)
      eth_balance = client.get_balance(params)
      contract_db = Contract.find_by_address(params)

      wetoken = Contract.find_by_name("wetoken")
      contract = client.set_contract(wetoken.name, wetoken.address, wetoken.abi)
      wt_balance = contract.call.balance_of(params)
      return address, eth_balance, wt_balance, contract_db
    end
  end
end