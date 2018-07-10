Fabricator(:ethereum_wallet) do
  address { Eth::Key.new.address }
  userable_id { rand(1..100)  }
  userable_type { %w(Owner Advertiser).sample }
end
