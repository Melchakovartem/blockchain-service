class DeployContractService
  class << self
    def call(profile_id, referrer_profile_id)
      client = EthereumClient.new(Settings.http_path)
      contract = Ethereum::Contract.create(file: "config/contracts/referral.sol", name: "ReferralContract", client: client, contract_index: 1)
      contract.sender = Settings.http_sender
      referrer = Owner.find_by_profile_id(profile_id)
      referral = Owner.find_by_profile_id(referrer_profile_id)
      if referrer.root
        contract.deploy_and_wait(Settings.http_token_address, referral.ethereum_wallet.address, referrer.ethereum_wallet.address)
        referral.update(referrer_id: referrer.id, contract_address: contract.address)
      else
        contract.deploy_and_wait(Settings.http_token_address, referral.ethereum_wallet.address, referrer.contract_address)
        referral.update(referrer_id: referrer.id, contract_address: contract.address)
      end
    end
  end
end