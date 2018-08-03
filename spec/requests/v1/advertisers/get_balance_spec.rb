require "rails_helper"

RSpec.describe "Get balance of wallet" do
  let(:profile_id) { rand(1..10) }
  let(:profile_type) { "Advertiser" }
  let!(:spender) { Eth::Key.new.address }
  let(:amount) { rand(100..1000) }

  context "profile exist" do
    let!(:advertiser) { WalletService.create(profile_id, profile_type) }
    let(:priv_key) { advertiser.ethereum_wallet.private_hex }
    let(:token_service) { TokenService.new(priv_key) }

    before do 
      token_service.get_tokens(amount)
      get get_balance_v1_advertisers_path, params: { profile_id: profile_id }
    end

    it "returns balance" do
      expect(response.body).to eq(amount.to_s)
    end 

    it "returns status :ok" do
      expect(response).to have_http_status(:ok)
    end
  end

  context "profile does not exist" do
    before do
      get get_balance_v1_advertisers_path, params: { profile_id: profile_id }
    end

    it "returns balance" do
      expect(response.body).to be_empty
    end 

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
  end 
end
