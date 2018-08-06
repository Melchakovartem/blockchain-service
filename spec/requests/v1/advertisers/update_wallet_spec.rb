require "rails_helper"

RSpec.describe "Wallet update" do
  context "advertiser" do
    let!(:profile_id) { rand(1..100) }
    let!(:advertiser) { Fabricate(:advertiser, profile_id: profile_id) }
    let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: advertiser.id, userable_type: "Advertiser") }

    context "with exist profile id" do
      before do
        patch v1_advertiser_update_wallet_path(profile_id)
      end

      it "returns status :no_content" do
        expect(response).to have_http_status(:no_content)
      end 

      it "empty body" do
        expect(response.body).to be_empty
      end
    end

    context "with not exist profile id" do
      let!(:new_profile_id) { rand(1..100) }

      before do
        patch v1_advertiser_update_wallet_path(new_profile_id)
      end

      it "returns status :not_found" do
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
