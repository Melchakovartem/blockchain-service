class V1::ProfileSerializer < ActiveModel::Serializer
  attributes :id, :profile_id, :profile_type, :address

  delegate :address, to: :wallet

  def wallet
  	object.ethereum_wallet
  end

  def profile_type
  	wallet.userable_type
  end
end