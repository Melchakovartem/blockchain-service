require "rails_helper"

RSpec.describe "Show advertiser profile" do
  context "exist profile" do
    let(:profile_id) { rand(1..100) }
    let(:profile_type) { "Advertiser" }

    before do
      WalletService.create(profile_id, profile_type)
      get v1_advertiser_path(profile_id), params: { format: :json }
    end

    it "returns status :ok" do
      expect(response).to have_http_status(:ok)
    end

    %w(address eth_balance token_balance).each do |value|
      it "returns #{value}" do
        expect(response.body).to have_json_path(value)
      end
    end
  end

  context "not exist profile" do
    let(:profile_id) { rand(1..100) }
    let(:profile_type) { "Advertiser" }

    before do
      get v1_advertiser_path(profile_id), params: { format: :json }
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
    
    it "returns empty body" do
      expect(response.body).to be_empty
    end
  end
end
