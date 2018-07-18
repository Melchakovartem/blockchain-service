require "rails_helper"

RSpec.describe "Wallet create" do
  context "Root invite" do
    let(:profile_id) { rand(1..100) }
    let!(:client) { EthereumClient.new(Settings.http_path) }

    context "with valid id" do
      it "returns status :created" do
        post v1_owners_path, params: { profile_id: profile_id, profile_params: { root: true } }
        expect(response).to have_http_status(:created)
      end 

       it "creates new ethereum wallet" do
         expect do
           post v1_owners_path, params: { profile_id: profile_id, profile_params: { root: true } }
         end.to change { EthereumWallet.count }.by(1)
       end
  
      it "returns correct profile_id" do
        post v1_owners_path, params: { profile_id: profile_id, profile_params: { root: true } }
        expect(response.body).to be_json_eql(profile_id).at_path("profile_id")
      end

      it "returns address" do
        post v1_owners_path, params: { profile_id: profile_id, profile_params: { root: true } }
        expect(response.body).to have_json_path("address")
      end

      it "doesn't create referral contract" do
        post v1_owners_path, params: { profile_id: profile_id, profile_params: { root: true } }
        expect(Owner.by_profile(profile_id).contract_address).to be_nil
      end

      it "sends ether to new ethereum wallet" do
        post v1_owners_path, params: { profile_id: profile_id, profile_params: { root: true } }
        wallet = Owner.by_profile(profile_id).ethereum_wallet.address
        expect(client.get_balance(wallet)).to eq(0.009953824)
      end
    end

    context "with taken id" do
      let!(:profile_id) { rand(1..100) }
      let!(:owner) { Fabricate(:owner, profile_id: profile_id) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: owner.id, userable_type: "Owner") }

      it "returns status :unprocessable_entity" do
        post v1_owners_path, params: { profile_id: profile_id, profile_params: { root: true } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't create new ethereum wallet" do
        expect do
          post v1_owners_path, params: { profile_id: profile_id, profile_params: { root: true } }
        end.to_not change(EthereumWallet, :count)
      end
  
      it "returns errors" do
        post v1_owners_path, params: { profile_id: profile_id, profile_params: { root: true } }
        expect(response.body).to have_json_path("errors")
      end
    end
  end

  context "Non root invite" do
    let!(:referrer_profile_id) { rand(1..10) }
    let!(:referral_profile_id) { rand(11..20) }
    let!(:referrer) { Fabricate(:owner, profile_id: referrer_profile_id, root: true) }
    let!(:referrer_ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: referrer.id, userable_type: "Owner") }
    let!(:client) { EthereumClient.new(Settings.http_path) }

    context "with valid id" do
      it "returns status :created" do
        post v1_owners_path, params: { profile_id: referral_profile_id, profile_params: { root: false, referrer_profile_id: referrer_profile_id } }
        expect(response).to have_http_status(:created)
      end 

       it "creates new ethereum wallet" do
         expect do
           post v1_owners_path, params: { profile_id: referral_profile_id, profile_params: { root: false, referrer_profile_id: referrer_profile_id } }
         end.to change { EthereumWallet.count }.by(1)
       end
  
      it "returns correct profile_id" do
        post v1_owners_path, params: { profile_id: referral_profile_id, profile_params: { root: false, referrer_profile_id: referrer_profile_id } }
        expect(response.body).to be_json_eql(referral_profile_id).at_path("profile_id")
      end

      it "returns address" do
        post v1_owners_path, params: { profile_id: referral_profile_id, profile_params: { root: false, referrer_profile_id: referrer_profile_id } }
        expect(response.body).to have_json_path("address")
      end

      it "creates referral contract" do
        post v1_owners_path, params: { profile_id: referral_profile_id, profile_params: { root: false, referrer_profile_id: referrer_profile_id } }
        referral = Owner.by_profile(referral_profile_id)
        contract = client.set_contract("ref", referral.reload.contract_address, Settings.referral_abi)
        expect("0x"+contract.call.referral).to eq(referral.ethereum_wallet.address.downcase)
      end

      it "sends ether to new ethereum wallet" do
        post v1_owners_path, params: { profile_id: referral_profile_id, profile_params: { root: false, referrer_profile_id: referrer_profile_id } }
        wallet = Owner.by_profile(referral_profile_id).ethereum_wallet.address
        expect(client.get_balance(wallet)).to eq(0.009953824)
      end
    end

    context "with taken id" do
      let!(:referrer_profile_id) { rand(1..10) }
      let!(:referral_profile_id) { rand(11..20) }
      let!(:referrer) { Fabricate(:owner, profile_id: referrer_profile_id, root: true) }
      let!(:referral) { Fabricate(:owner, profile_id: referral_profile_id, referrer_id: referrer_profile_id) }
      let!(:referrer_ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: referrer.id, userable_type: "Owner") }
      let!(:referral_ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: referral.id, userable_type: "Owner") }
      let!(:client) { EthereumClient.new(Settings.http_path) }

      it "returns status :unprocessable_entity" do
        post v1_owners_path, params: { profile_id: referral_profile_id, profile_params: { root: false, referrer_profile_id: referrer_profile_id } }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't create new ethereum wallet" do
        expect do
          post v1_owners_path, params: { profile_id: referral_profile_id, profile_params: { root: false, referrer_profile_id: referrer_profile_id } }
        end.to_not change(EthereumWallet, :count)
      end
  
      it "returns errors" do
        post v1_owners_path, params: { profile_id: referral_profile_id, profile_params: { root: false, referrer_profile_id: referrer_profile_id } }
        expect(response.body).to have_json_path("errors")
      end
    end
  end
end
