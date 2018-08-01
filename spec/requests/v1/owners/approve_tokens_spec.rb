require "rails_helper"

RSpec.describe "Get tokens to wallet" do
  let(:profile_id) { rand(1..10) }
  let(:profile_type) { "Owner" }
  let(:amount) { rand(100..1000) }
  let!(:spender) { Eth::Key.new.address }
  let(:profile_params) { { root: true } }

  context "profile exist" do
    before do 
      WalletService.create(profile_id, profile_type, profile_params)
      post approve_tokens_v1_owners_path, params: { profile_id: profile_id, token_amount: amount, spender: spender }
    end

    it "recieves tokens to wallet" do
      allowance = TokenService.new(profile_id, profile_type).get_allowance(spender)
      expect(allowance).to eq(amount)
    end 

    it "returns status :no_content" do
      expect(response).to have_http_status(:no_content)
    end
  end

  context "profile does not exist" do
    before do 
      post approve_tokens_v1_owners_path, params: { profile_id: profile_id, token_amount: amount, spender: spender }
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
  end 
end
