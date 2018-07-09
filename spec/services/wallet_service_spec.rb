require "rails_helper"

RSpec.describe WalletService do
  describe "create" do
    let(:user_id) { rand(1..100) }
    let(:user_type) { %w(owner advertiser).sample }

    it "saves new etherem wallet to database" do
      expect do
        WalletService.create(wallet_params)
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

  def wallet_params
    { user_id: user_id, user_type: user_type }
  end
end
