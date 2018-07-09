require "rails_helper"

RSpec.describe "Wallet update" do
  let(:user_id) { rand(1..100) }
  let!(:wallet) { Fabricate(:ethereum_wallet, user_id: user_id) }

  context "with exist id" do
    before do
      patch v1_wallets_path, params: { user_id: user_id }
    end

    it "returns status :no_content" do
      expect(response).to have_http_status(:no_content)
    end 

    it "empty body" do
      expect(response.body).to be_empty
    end
  end

  context "with not exist id" do
    let(:wallet) { Fabricate(:ethereum_wallet) }

    before do
      patch v1_wallets_path, params: { user_id: user_id }
    end

    it "returns status :no_content" do
      expect(response).to have_http_status(:not_found)
    end 

    it "empty body" do
      expect(response.body).to be_empty
    end
     
  end
end
