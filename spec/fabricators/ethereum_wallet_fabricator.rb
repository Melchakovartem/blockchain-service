Fabricator(:ethereum_wallet) do
  address { Eth::Key.new.address }
  user_id { rand(1..100)  }
  user_type { %w(owner advertiser).sample }
end
