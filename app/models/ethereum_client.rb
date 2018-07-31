class EthereumClient < Ethereum::HttpClient

  WEI_IN_ETHER = 10**18

  DEFAULT_GAS_LIMIT = 3_800_000

  DEFAULT_GAS_PRICE = 1_000_000_000

  def initialize(path)
    super(path)
    @gas_price = DEFAULT_GAS_PRICE
    @gas_limit = DEFAULT_GAS_LIMIT
  end

  def get_balance(address)
  	super(address).to_f / WEI_IN_ETHER
  end

  def set_contract(name, address, abi)
    Ethereum::Contract.create(name: name, address: address, abi: abi, client: self)
  end

  def create_contract(file, name, index)
    Ethereum::Contract.create(file: file, name: name, contract_index: index, client: self)
  end
end