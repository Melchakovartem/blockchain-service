require "rails_helper"

RSpec.describe "Wallet update" do
  context "owner" do
    let!(:profile_id) { rand(1..100) }
    let!(:profile_type) { "Owner" }
    let!(:owner) { Fabricate(:owner, profile_id: profile_id) }
    let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: owner.id, userable_type: "Owner") }

    context "with exist profile id" do
      before do
        patch v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
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
      let!(:profile_type) { "Owner" }
      let!(:owner) { Fabricate(:owner, profile_id: profile_id) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: owner.id, userable_type: "Owner") }


      before do
        patch v1_profiles_path, params: produce_wallet_params(rand(101..200), profile_type)
      end

      it "returns status :no_content" do
        expect(response).to have_http_status(:not_found)
      end 

      it "empty body" do
        expect(response.body).to be_empty
      end   
   end
  end

  context "advertiser" do
    let!(:profile_id) { rand(1..100) }
    let!(:profile_type) { "Advertiser" }
    let!(:advertiser) { Fabricate(:advertiser, profile_id: profile_id) }
    let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: advertiser.id, userable_type: "Advertiser") }

    context "with exist profile id" do
      before do
        patch v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
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
      let!(:profile_type) { "Advertiser" }
      let!(:advertiser) { Fabricate(:advertiser, profile_id: profile_id) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: advertiser.id, userable_type: "Advertiser") }


      before do
        patch v1_profiles_path, params: produce_wallet_params(rand(101..200), profile_type)
      end

      it "returns status :no_content" do
        expect(response).to have_http_status(:not_found)
      end 

      it "empty body" do
        expect(response.body).to be_empty
      end   
   end
  end

  def produce_wallet_params(profile_id, profile_type)
    { profile: { profile_id: profile_id, profile_type: profile_type }, format: :json }
  end
end
