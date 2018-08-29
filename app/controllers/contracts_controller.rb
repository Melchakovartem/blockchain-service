class ContractsController < ApplicationController
  def referral_contracts
  	referral_contract_addresses = Contract.where(name: "referral").pluck(:address)
  	@owners = Owner.where(contract_address: referral_contract_addresses)
  end

  def wetoken
  	contract = Contract.find_by_name("wetoken")
  	redirect_to address_url(contract.address)
  end

  def deal
  	contract = Contract.find_by_name("deal")
  	redirect_to address_url(contract.address)
  end
end