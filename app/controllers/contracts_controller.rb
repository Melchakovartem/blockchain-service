class ContractsController < ApplicationController
  def referral_contracts
  	@referral_contracts = Contract.where(name: "referral")
  end

  def wetoken
  end

  def deal
  end
end
