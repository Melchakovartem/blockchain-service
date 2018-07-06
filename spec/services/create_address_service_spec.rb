require "rails_helper"

RSpec.describe CreateAddressService do
  describe "create" do

    it "returns new ethereum address" do 
      expect(CreateAddressService.call).to match(/^0x[a-fA-F0-9]{40}$/)
    end

    it "saves etherem address to database" do
      expect do
        CreateAddressService.call
      end.to change(EthereumWallet, :count)
    end
  end
end
