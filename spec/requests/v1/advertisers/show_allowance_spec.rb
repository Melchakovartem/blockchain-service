require "rails_helper"

RSpec.describe "Show allowance" do
  let(:profile_id) { rand(1..10) }
  let(:profile_type) { "Advertiser" }
  let(:amount) { rand(100..1000) }

  context "profile exist" do
    let!(:advertiser) { WalletService.create(profile_id, profile_type) }
    let(:priv_key) { advertiser.ethereum_wallet.private_hex }
    let(:token_service) { TokenService.new(priv_key) }

    before do 
      token_service.approve(amount)
      get  v1_advertiser_show_allowance_path(profile_id), params: { format: :json }
    end

    it "returns allowance" do
      expect(response.body).to eq(amount.to_s)
    end 

    it "returns status :ok" do
      expect(response).to have_http_status(:ok)
    end
  end

  context "profile does not exist" do
    before do
      get v1_advertiser_show_allowance_path(profile_id), params: { format: :json }
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
  end 
end
