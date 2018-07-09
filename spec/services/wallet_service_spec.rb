require "rails_helper"

RSpec.describe WalletService do
  describe "create" do
    let(:user_id) { rand(1..100) }

    it "saves new etherem wallet to database" do
      expect do
        WalletService.create(user_id)
      end.to change(EthereumWallet, :count)
    end
  end

  describe "update" do
    let(:user_id) { rand(1..100) }
    let(:wallet) { Fabricate(:ethereum_wallet, user_id: user_id) }

    it "changes address" do
      expect(WalletService.update(wallet)).to be_truthy
    end
  end
end
