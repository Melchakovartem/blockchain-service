require "rails_helper"

RSpec.describe WalletService do
  describe "create" do
    context "owner profile and wallet" do
      let(:profile_id) { rand(1..100) }
      let(:profile_type) { "Owner" }

      it "saves owner profile to database" do
        expect do
          WalletService.create(wallet_params)
        end.to change(Owner, :count)
      end

      it "saves new etherem wallet to database" do
        expect do
          WalletService.create(wallet_params)
        end.to change(EthereumWallet, :count)
      end
    end

    context "advertiser profile and wallet" do
      let(:profile_id) { rand(1..100) }
      let(:profile_type) { "Advertiser" }

      it "saves owner profile to database" do
        expect do
          WalletService.create(wallet_params)
        end.to change(Advertiser, :count)
      end

      it "saves new etherem wallet to database" do
        expect do
          WalletService.create(wallet_params)
        end.to change(EthereumWallet, :count)
      end
    end
  end

  describe "update" do
    context "owner profile and wallet" do
      let!(:profile_id) { rand(1..100) }
      let!(:profile_type) { "Owner" }
      let!(:owner) { Fabricate(:owner, profile_id: profile_id) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: owner.id, userable_type: "Owner") }

      it "updates etherem wallet for owner" do
        WalletService.update(wallet_params)
        expect(ethereum_wallet.address).to_not eq(ethereum_wallet.reload.address)
      end
    end

    context "advertiser profile and wallet" do
     let!(:profile_id) { rand(1..100) }
      let!(:profile_type) { "Advertiser" }
      let!(:advertiser) { Fabricate(:advertiser, profile_id: profile_id) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: advertiser.id, userable_type: "Advertiser") }

      it "updates etherem wallet for advertiser" do
        WalletService.update(wallet_params)
        expect(ethereum_wallet.address).to_not eq(ethereum_wallet.reload.address)
      end
    end
  end

  def wallet_params
    { profile_id: profile_id, profile_type: profile_type }
  end
end
