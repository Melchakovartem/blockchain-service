require "rails_helper"

RSpec.describe "Approve tokens for wallet" do
  let(:profile_id) { rand(1..10) }
  let(:profile_type) { "Advertiser" }
  let(:amount) { rand(100..1000) }
  

  context "profile exist" do
    let!(:advertiser) { WalletService.create(profile_id, profile_type) }
    let(:priv_key) { advertiser.ethereum_wallet.private_hex }
    let(:token_service) { TokenService.new(priv_key) }
    
    before do 
      post v1_advertiser_approve_tokens_path(profile_id), params: { token_amount: amount }
    end

    it "recieves tokens to wallet" do
      allowance = token_service.get_allowance
      expect(allowance).to eq(amount)
    end 

    it "returns status :no_content" do
      expect(response).to have_http_status(:no_content)
    end
  end

  context "profile does not exist" do
    before do 
      post v1_advertiser_approve_tokens_path(profile_id), params: { token_amount: amount }
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
  end 
end
