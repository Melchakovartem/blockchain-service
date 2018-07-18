require "rails_helper"

RSpec.describe "Wallet create" do
  context "Advertiser" do
    let(:profile_id) { rand(1..100) }
    let!(:client) { EthereumClient.new(Settings.http_path) }

    context "with valid id" do
      it "returns status :created" do
        post v1_advertisers_path, params: { profile_id: profile_id }
        expect(response).to have_http_status(:created)
      end 

       it "creates new ethereum wallet" do
         expect do
           post v1_advertisers_path, params: { profile_id: profile_id }
         end.to change { EthereumWallet.count }.by(1)
       end
  
      it "returns correct profile_id" do
        post v1_advertisers_path, params: { profile_id: profile_id }
        expect(response.body).to be_json_eql(profile_id).at_path("profile_id")
      end

      it "returns address" do
        post v1_advertisers_path, params: { profile_id: profile_id }
        expect(response.body).to have_json_path("address")
      end

      it "sends ether to new ethereum wallet" do
        post v1_advertisers_path, params: { profile_id: profile_id }
        wallet = Advertiser.by_profile(profile_id).ethereum_wallet.address
        expect(client.get_balance(wallet)).to be > 0.009
      end

      it "approvs tokens for ethereum wallet" do
        post v1_advertisers_path, params: { profile_id: profile_id }
        wallet = Advertiser.by_profile(profile_id).ethereum_wallet.address
        contract = client.set_contract("Wetoken", Settings.token_address, Settings.token_abi)
        expect(contract.call.allowance(wallet, Settings.owner)).to eq(10**25)
      end
    end

    context "with taken id" do
      let!(:profile_id) { rand(1..100) }
      let!(:profile_type) { "Advertiser" }
      let!(:advertiser) { Fabricate(:advertiser, profile_id: profile_id) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: advertiser.id, userable_type: "Advertiser") }

      it "returns status :unprocessable_entity" do
        post v1_advertisers_path, params: { profile_id: profile_id }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't create new ethereum wallet" do
        expect do
          post v1_advertisers_path, params: { profile_id: profile_id }
        end.to_not change(EthereumWallet, :count)
      end
  
      it "returns errors" do
        post v1_advertisers_path, params: { profile_id: profile_id }
        expect(response.body).to have_json_path("errors")
      end
    end
  end
end
