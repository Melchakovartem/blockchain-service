require "rails_helper"

RSpec.describe "Show owner profile" do
  context "exist profile" do
    context "root" do
      let(:profile_id) { rand(1..100) }
      let(:profile_type) { "Owner" }
      let(:profile_params) { { root: true } }

      before do
        WalletService.create(profile_id, profile_type, profile_params)
        get v1_owner_path(profile_id), params: { format: :json }
      end

      it "returns status :ok" do
        expect(response).to have_http_status(:ok)
      end

      %w(address eth_balance token_balance 
        contract_address referrer_id root).each do |value|
        it "returns #{value}" do
          expect(response.body).to have_json_path(value)
        end
      end
    end

    context "non root" do
      let(:referrer_profile_id) { rand(1..10) }
      let(:referrer_profile_params) { { root: true } }
      let(:profile_id) { rand(11..100) }
      let(:profile_type) { "Owner" }
      let(:profile_params) { { root: "false", referrer_profile_id: referrer_profile_id } }


      before do
        WalletService.create(referrer_profile_id, profile_type, referrer_profile_params)
        WalletService.create(profile_id, profile_type, profile_params)
        get v1_owner_path(profile_id), params: { format: :json }
      end

      it "returns status :ok" do
        expect(response).to have_http_status(:ok)
      end

      %w(address eth_balance token_balance 
        contract_address referrer_id root).each do |value|
        it "returns #{value}" do
          expect(response.body).to have_json_path(value)
        end
      end
    end
  end

  context "not exist profile" do
    let(:profile_id) { rand(1..100) }
    let(:profile_type) { "Owner" }
    let(:profile_params) { { root: true } }

    before do
      get v1_owner_path(profile_id), params: { format: :json }
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
    
    it "returns empty body" do
      expect(response.body).to be_empty
    end
  end
end
