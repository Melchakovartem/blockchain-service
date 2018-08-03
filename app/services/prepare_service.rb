class PrepareService
  class << self
    def call
      client = EthereumClient.new(Settings.http_path)
      Contract.destroy_all

      wetoken =  client.create_contract("config/contracts/wetoken.sol", "wetoken", 7)
      wetoken.deploy_and_wait(Settings.owner)
      Contract.create(name: "wetoken", address: wetoken.address, abi: Settings.token_abi)

      deal = client.create_contract("config/contracts/deal.sol", "deal", 0)
      deal.deploy_and_wait(wetoken.address, Settings.owner, Settings.wwf)
      Contract.create(name: "deal", address: deal.address, abi: Settings.deal_abi)
    end
  end
end