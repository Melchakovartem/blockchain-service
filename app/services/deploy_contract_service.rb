class DeployContractService
  class << self
    def call(profile_id, referrer_profile_id)
      prepare_to_deploy
      deploy_contract(profile_id, referrer_profile_id)
    end

    private

    def deploy_contract(profile_id, referrer_profile_id)
      referrer = Owner.by_profile(profile_id)
      referral = Owner.by_profile(referrer_profile_id)
      referrer_address = referrer.root ? referrer.ethereum_wallet.address : referrer.contract_address
      @contract.deploy_and_wait(Settings.http_token_address, referral.ethereum_wallet.address, referrer_address)
      referral.update(referrer_id: referrer.id, contract_address: @contract.address)
    end


    def prepare_to_deploy
      client = EthereumClient.new(Settings.http_path)
      @contract = client.create_contract("config/contracts/referral.sol", "ReferralContract", 1)
      @contract.sender = Settings.http_sender
    end
  end
end