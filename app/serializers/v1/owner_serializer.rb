class V1::OwnerSerializer < V1::FullProfileSerializer
  attributes :contract_address, :referrer_id, :root

  def root
    object.root
  end
end