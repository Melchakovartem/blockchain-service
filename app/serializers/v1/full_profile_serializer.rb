class V1::FullProfileSerializer < ActiveModel::Serializer
  attributes :address, :eth_balance, :token_balance

  delegate :address, to: :wallet

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