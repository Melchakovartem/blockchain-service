class V1::CampaignSerializer < ActiveModel::Serializer
  attributes :profile_id, :status, :creator, :token_amount, :current_balance

  def status
  	object.check_status
  end

  def creator
  	"0x" + object.get_creator
  end

  def profile_id
  	address = "0x" + object.get_creator
  	wallet = EthereumWallet.find_by_address!(address)
  	Advertiser.find_by_id!(wallet.userable_id).profile_id
  end

  def token_amount
  	object.get_token_amount
  end 

  def current_balance
  	object.get_current_balance
  end
end