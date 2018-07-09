class V1::WalletSerializer < ActiveModel::Serializer
  attributes :user_id, :user_type, :address
end