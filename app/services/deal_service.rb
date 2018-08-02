class DealService

  def initialize
    @client = EthereumClient.new(Settings.http_path)
    @deal = @client.set_contract(Settings.deal_name, Settings.deal_address, Settings.deal_abi)
    @deal.sender = Settings.owner   
  end

  def create_campaign(advertiser, id, token_amount)
    address = advertiser.ethereum_wallet.address
    pp id
    pp token_amount
    pp address
    pp @deal.transact.create_campaign(id.to_s, token_amount.to_i, address)
  end
end