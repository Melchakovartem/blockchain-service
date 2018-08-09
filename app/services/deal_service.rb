class DealService

  def initialize(campaign_id)
    @client = EthereumClient.new(Settings.http_path)
    deal_contract = Contract.find_by_name("deal")
    @deal = @client.set_contract(deal_contract.name, deal_contract.address, deal_contract.abi)
    @deal.sender = Settings.owner
    @id = campaign_id   
  end

  def create_campaign(advertiser, token_amount)
    address = advertiser.ethereum_wallet.address
    @deal.transact.create_campaign(@id, token_amount.to_i, address)
  end

  def check_status
    status = @deal.call.check_status(@id)
    address = @deal.call.get_address_creator_by_id(@id)
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

  def get_creator
    @deal.call.get_address_creator_by_id(@id)
  end

  def get_token_amount
    @deal.call.get_token_amount_for_campaign(@id)
  end

  def get_current_balance
    @deal.call.get_current_balance_for_campaign(@id)
  end

  def add_tokens(token_amount)
    return ActiveRecord::RecordNotFound if check_status == "not created"
    @deal.transact.add_tokens_to_campaign(@id, token_amount.to_i)
  end

  def destroy
    @deal.transact.destroy_campaign(@id)
  end

  def finish
    @deal.transact.finish_campaign(@id)
  end

  def send_coins(token_amount_hash)
    router_owner_ids = token_amount_hash.keys
    token_amounts = token_amount_hash.values.map{|amount| amount.to_i }

    owner_addresses = router_owner_ids.map do |id|
      owner = Owner.find_by_profile_id!(id)
      owner.root ? owner.ethereum_wallet.address : owner.contract_address
    end

    @deal.transact.send_coin(owner_addresses, token_amounts, @id)
  end
end