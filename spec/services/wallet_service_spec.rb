require "rails_helper"

RSpec.describe WalletService do
  describe "create" do
    context "root invite" do
      context "create owner profile and wallet" do
        let(:profile_id) { rand(1..10) }
        let(:profile_type) { "Owner" }
        let(:profile_params) { { root: "true" } }

        it "saves owner profile to database" do
          expect do
            WalletService.create(profile_id, profile_type, profile_params)
          end.to change(Owner, :count)
        end

        it "saves new etherem wallet to database" do
          expect do
            WalletService.create(profile_id, profile_type, profile_params)
          end.to change(EthereumWallet, :count)
        end
      end
    end

    context "non root invite" do
      context "create owner profile and wallet" do
        let!(:referrer_profile_id) { rand(1..10) }
        let!(:referral_profile_id) { rand(11..20) }
        let(:profile_type) { "Owner" }
        let!(:referrer) { Fabricate(:owner, profile_id: referrer_profile_id, root: true) }
        let!(:referrer_ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: referrer.id, userable_type: "Owner") }
        let(:profile_params) { { root: "false", referrer_profile_id: referrer_profile_id } }

        it "saves owner profile to database" do
          expect do
            WalletService.create(referral_profile_id, profile_type, profile_params)
          end.to change(Owner, :count)
        end

        it "saves new etherem wallet to database" do
          expect do
            WalletService.create(referral_profile_id, profile_type, profile_params)
          end.to change(EthereumWallet, :count)
        end
      end
    end

    context "advertiser profile and wallet" do
      let(:profile_id) { rand(1..100) }
      let(:profile_type) { "Advertiser" }

      it "saves owner profile to database" do
        expect do
          WalletService.create(profile_id, profile_type)
        end.to change(Advertiser, :count)
      end

      it "saves new etherem wallet to database" do
        expect do
          WalletService.create(profile_id, profile_type)
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
        WalletService.update(profile_id, profile_type)
        expect(ethereum_wallet.address).to_not eq(ethereum_wallet.reload.address)
      end
    end

    context "advertiser profile and wallet" do
     let!(:profile_id) { rand(1..100) }
      let!(:profile_type) { "Advertiser" }
      let!(:advertiser) { Fabricate(:advertiser, profile_id: profile_id) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: advertiser.id, userable_type: "Advertiser") }

      it "updates etherem wallet for advertiser" do
        WalletService.update(profile_id, profile_type)
        expect(ethereum_wallet.address).to_not eq(ethereum_wallet.reload.address)
      end
    end
  end
end
