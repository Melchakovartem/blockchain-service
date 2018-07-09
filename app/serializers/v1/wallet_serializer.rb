class V1::WalletSerializer < ActiveModel::Serializer
  attributes :user_id, :address
end