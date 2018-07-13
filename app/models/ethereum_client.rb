class EthereumClient < Ethereum::HttpClient

  WEI_IN_ETHER = 10**18

  DEFAULT_GAS_LIMIT = 3_000_000

  DEFAULT_GAS_PRICE = 100_000_000_000

  def initialize(path)
    super(path)
    @gas_price = DEFAULT_GAS_PRICE
    @gas_limit = DEFAULT_GAS_LIMIT
  end

  def get_balance(address)
  	super(address).to_f / WEI_IN_ETHER
  end

  def transfer(key, address, amount)
    Eth.configure { |c| c.chain_id = net_version["result"].to_i }
    args = { 
      from: key.address,
      to: address,
      value: amount,
      data: "",
      nonce: get_nonce(key.address),
      gas_limit: gas_limit,
      gas_price: gas_price
    }
    tx = Eth::Tx.new(args)
    tx.sign key
    eth_send_raw_transaction(tx.hex)["result"]
  end

  def send_eth_to(private_hex, to, amount_eth)
  	begin
  	  key =Eth::Key.new(priv: private_hex)
  	  amount = (amount_eth * WEI_IN_ETHER).to_i
      pp to
  	  transfer_and_wait(key, to, amount)
  	rescue
  	  puts "Transaction failed"
  	end
  end

  def set_contract(name, address, abi)
    Ethereum::Contract.create(name: name, address: address, abi: abi, client: self)
  end

  def create_contract(file, name, index)
    Ethereum::Contract.create(file: file, name: name, contract_index: index, client: self)
  end
end