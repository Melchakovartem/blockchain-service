require "rails_helper"

RSpec.describe CreateWalletService do
  describe "create" do
    let(:user_id) { rand(1..100) }

    it "saves new etherem wallet to database" do
      expect do
        CreateWalletService.call(user_id)
      end.to change(EthereumWallet, :count)
    end
  end
end
