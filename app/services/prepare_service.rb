class PrepareService
  class << self
    def call
      client = EthereumClient.new(Settings.http_path)
     
        Contract.destroy_all

        wetoken =  client.create_contract("config/contracts/wetoken.sol", "wetoken", 7)
        wetoken.deploy_and_wait(Settings.owner)
        contract_code_wt = File.open("config/contracts/wetoken.sol", "r")
        Contract.create(name: "wetoken", address: wetoken.address, abi: Settings.token_abi, code: contract_code_wt.read)

        deal = client.create_contract("config/contracts/deal.sol", "deal", 0)
        deal.deploy_and_wait(wetoken.address, Settings.owner, Settings.wwf)
        contract_code_deal = File.open("config/contracts/deal.sol", "r")
        Contract.create(name: "deal", address: deal.address, abi: Settings.deal_abi, code: contract_code_deal.read)
     
    end
  end
end