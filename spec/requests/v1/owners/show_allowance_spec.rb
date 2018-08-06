require "rails_helper"

RSpec.describe "Show allowance" do
  let(:profile_id) { rand(1..10) }
  let(:profile_type) { "Owner" }
  let!(:spender) { Eth::Key.new.address }
  let(:amount) { rand(100..1000) }
  let(:profile_params) { { root: true } }

  context "profile exist" do
    let!(:owner) { WalletService.create(profile_id, profile_type, profile_params) }
    let(:priv_key) { owner.ethereum_wallet.private_hex }
    let(:token_service) { TokenService.new(priv_key) }

    before do 
      token_service.approve(amount)
      get v1_owner_show_allowance_path(profile_id), params: { format: :json }
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
      get v1_owner_show_allowance_path(profile_id), params: { format: :json }
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
  end 
end
