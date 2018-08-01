require "rails_helper"

RSpec.describe "Get balance of wallet" do
  let(:profile_id) { rand(1..10) }
  let(:profile_type) { "Owner" }
  let(:amount) { rand(100..1000) }
  let(:profile_params) { { root: true } }

  context "profile exist" do
    before do 
      WalletService.create(profile_id, profile_type, profile_params)
      TokenService.new(profile_id, profile_type).get_tokens(amount)
      get get_balance_v1_owners_path, params: { profile_id: profile_id }
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
      get get_balance_v1_owners_path, params: { profile_id: profile_id }
    end

    it "returns balance" do
      expect(response.body).to be_empty
    end 

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
  end 
end
