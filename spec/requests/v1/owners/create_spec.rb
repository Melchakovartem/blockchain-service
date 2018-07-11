require "rails_helper"

RSpec.describe "Wallet create" do
  context "Root invite" do
    let(:profile_id) { rand(1..100) }

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
end
