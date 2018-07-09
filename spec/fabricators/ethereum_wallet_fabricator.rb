Fabricator(:ethereum_wallet) do
  address { Eth::Key.new.address }
  user_id { rand(1..100)  }
end
