require "rails_helper"

RSpec.describe "Create campaign" do
  let(:profile_id) { rand(1..10) }
  let(:profile_type) { "Advertiser" }
  let(:campaign_id) { FFaker::Lorem.word }
  let(:amount) { rand(100..1000) }

  context "prfile exst" do
    let(:advertiser) { WalletService.create(profile_id, profile_type) }
    let(:priv_key) { advertiser.ethereum_wallet.private_hex } 
    let!(:token_service) { TokenService.new(priv_key) }
    let!(:deal) { Contract.find_by_name("deal") }
    let(:deal_service) { DealService.new(campaign_id) }


    before do
      token_service.get_tokens(10000)
      token_service.approve(deal.address, 10**25)
      post v1_campaigns_path, params: { profile_id: profile_id, campaign_id: campaign_id, 
                                                         token_amount: amount}
    end

    it "checks token amount of campaign" do
      expect(deal_service.get_token_amount).to eq(amount)
    end

    it "returns status :no_content" do
      expect(response).to have_http_status(:no_content)
    end
  end

  context "prfile does not exst" do
    before do
      post v1_campaigns_path, params: { profile_id: profile_id, campaign_id: campaign_id, 
                                                         token_amount: amount}
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
  end
end
