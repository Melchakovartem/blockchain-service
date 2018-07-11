require "rails_helper"

RSpec.describe "Wallet update" do
  context "advertiser" do
    let!(:profile_id) { rand(1..100) }
    let!(:owner) { Fabricate(:owner, profile_id: profile_id) }
    let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: owner.id, userable_type: "Owner") }

    context "with exist profile id" do
      before do
        patch v1_owners_path, params: { profile_id: profile_id }
      end

      it "returns status :no_content" do
        expect(response).to have_http_status(:no_content)
      end 

      it "empty body" do
        expect(response.body).to be_empty
      end
    end

    context "with not exist profile id" do
      let!(:profile_id) { rand(1..100) }
      let!(:owner) { Fabricate(:owner, profile_id: profile_id) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: owner.id, userable_type: "Owner") }


      before do
        patch v1_owners_path, params: { profile_id: rand(101..200) }
      end

      it "returns status :no_content" do
        expect(response).to have_http_status(:not_found)
      end 

      it "empty body" do
        expect(response.body).to be_empty
      end   
   end
  end
end
