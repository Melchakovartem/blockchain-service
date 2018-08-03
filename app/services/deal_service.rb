class DealService

  def initialize
    @client = EthereumClient.new(Settings.http_path)
    deal_contract = Contract.find_by_name("deal")
    @deal = @client.set_contract(deal_contract.name, deal_contract.address, deal_contract.abi)
    @deal.sender = Settings.owner   
  end

  def create_campaign(advertiser, id, token_amount)
    address = advertiser.ethereum_wallet.address
    @deal.transact.create_campaign(id.to_s, token_amount.to_i, address)
  end

  def check_status(id)
    status = @deal.call.check_status(id)
    address = @deal.call.get_address_creator_by_id(id)
    return "not created" if address == "0"*40
    case status
    when 0
      "created"
    when 1
      "destroyed"
    when 2
      "finished"
    end
  end

  def get_creator(id)
    @deal.call.get_address_creator_by_id(id)
  end

  def get_token_amount(id)
    @deal.call.get_token_amount_for_campaign(id)
  end

  def get_current_balance(id)
    @deal.call.get_current_balance_for_campaign(id)
  end

  def add_tokens(id, token_amount)
    @deal.transact.add_tokens_to_campaign(id, token_amount)
  end

  def destroy(id)
    @deal.transact.destroy_campaign(id)
  end

  def finish(id)
    @deal.transact.finish_campaign(id)
  end

  def send_coins(token_amount_hash, campaign_id)
    router_owner_ids = []
    token_amounts = []
    token_amount_hash.each do |key, value|
      router_owner_ids << key
      token_amounts << value.to_i
    end
    owner_addresses = []
    router_owner_ids.each do |id|
      owner = Owner.by_profile(id)
      address = owner.root ? owner.ethereum_wallet.address : owner.contract_address
      owner_addresses << address
    end
    @deal.transact.send_coin(owner_addresses, token_amounts, campaign_id)
  end
end