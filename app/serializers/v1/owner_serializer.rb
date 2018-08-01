class V1::OwnerSerializer < ActiveModel::Serializer
  attributes :address, :eth_balance, :token_balance, :contract_address, :referrer_id, :root

  delegate :address, to: :wallet

  def root
    object.root
  end

  def wallet
  	object.ethereum_wallet
  end

  def client
  	client = EthereumClient.new(Settings.http_path)
  end

  def eth_balance
  	client.get_balance(address)
  end

  def token_balance
  	token = client.set_contract(Settings.token_name, Settings.token_address, Settings.token_abi)
  	token.call.balance_of(address)
  end
end