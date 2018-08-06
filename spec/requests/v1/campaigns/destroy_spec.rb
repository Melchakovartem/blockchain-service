require "rails_helper"

RSpec.describe "Destroy campaign" do
  let(:profile_id) { rand(1..10) }
  let(:profile_type) { "Advertiser" }
  let(:campaign_id) { FFaker::Lorem.word }
  let(:token_amount) { rand(100..1000) }
  let(:added_token_amount) { rand(100..1000) }

  context "campaign exst" do
    let(:advertiser) { WalletService.create(profile_id, profile_type) }
    let(:priv_key) { advertiser.ethereum_wallet.private_hex } 
    let!(:token_service) { TokenService.new(priv_key) }
    let!(:deal) { Contract.find_by_name("deal") }
    let(:deal_service) { DealService.new(campaign_id) }
    
    before do
      token_service.get_tokens(20000)
      token_service.approve(10**25)
      deal_service.create_campaign(advertiser, token_amount)
      delete v1_campaign_path(campaign_id), params: {  format: :json }
    end

    it "checks status" do
      expect(deal_service.check_status).to eq("destroyed")
    end

    it "returns status :no_content" do
      expect(response).to have_http_status(:no_content)
    end
  end

  context "campaign does not exst" do
    before do
      delete v1_campaign_path(campaign_id), params: {  format: :json }
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
  end
end
