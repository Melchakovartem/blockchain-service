require "rails_helper"

RSpec.describe "Show campaign" do
  let(:profile_id) { rand(1..10) }
    let(:profile_type) { "Advertiser" }
    let(:campaign_id) { FFaker::Lorem.word }
    let(:amount) { rand(100..1000) }
    let(:advertiser) { WalletService.create(profile_id, profile_type) }
    let(:priv_key) { advertiser.ethereum_wallet.private_hex }
    let(:token_service) { TokenService.new(priv_key) }
    let(:token_amount) { rand(20000..100000) }
    let(:deal) { Contract.find_by_name("deal") }
    let(:deal_service) { DealService.new(campaign_id) }
  context "exist campaign" do
    before do
      token_service.get_tokens(10**10)
      token_service.approve(deal.address, 10**25)
      deal_service.create_campaign(advertiser, token_amount)
      get v1_campaign_path(campaign_id), params: { format: :json }
    end

    it "returns status :ok" do
      expect(response).to have_http_status(:ok)
    end

    %w(profile_id status creator token_amount current_balance).each do |value|
      it "returns #{value}" do
        expect(response.body).to have_json_path(value)
      end
    end
  end

  context "not exist profile" do
    before do
      get v1_campaign_path(campaign_id), params: { format: :json }
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
    
    it "returns empty body" do
      expect(response.body).to be_empty
    end
  end
end
