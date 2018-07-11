Fabricator(:owner) do
  profile_id { rand(1..100) }
  contract_address { Eth::Key.new.address }
end