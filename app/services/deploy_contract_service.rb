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
      wetoken = Contract.find_by_name("wetoken")

      ActiveRecord::Base.transaction do
        @contract.deploy(wetoken.address, referral.ethereum_wallet.address, referrer_address)
        referral.update(referrer_id: profile_id, contract_address: @contract.address, root: false)
      end
    end


    def prepare_to_deploy
      client = EthereumClient.new(Settings.http_path)
      
      @contract = client.create_contract("config/contracts/referral.sol", "ReferralContract", 1)
    end
  end
end