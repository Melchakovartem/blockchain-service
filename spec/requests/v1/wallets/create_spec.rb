require "rails_helper"

RSpec.describe "Wallet create" do
  let(:user_id) { rand(1..100) }
  let(:user_type) { %w(owner advertiser).sample }

  context "with valid id" do
    it "returns status :created" do
      post v1_wallets_path, params: produce_wallet_params(user_id, user_type)
      expect(response).to have_http_status(:created)
    end 

     it "creates new ethereum wallet" do
       expect do
         post v1_wallets_path, params: produce_wallet_params(user_id, user_type)
       end.to change { EthereumWallet.count }.by(1)
     end
  
    it "returns correct user_id" do
      post v1_wallets_path, params: produce_wallet_params(user_id, user_type)
      expect(response.body).to be_json_eql(user_id).at_path("user_id")
    end

    it "returns correct user_type" do
      post v1_wallets_path, params: produce_wallet_params(user_id, user_type)
      expect(response.body).to be_json_eql(user_type.to_json).at_path("user_type")
    end

    it "returns address" do
      post v1_wallets_path, params: produce_wallet_params(user_id, user_type)
      expect(response.body).to have_json_path("address")
    end
  end

  context "with taken id" do
    let!(:wallet) { Fabricate(:ethereum_wallet, user_id: user_id) }

    it "returns status :unprocessable_entity" do
      post v1_wallets_path, params: produce_wallet_params(user_id, user_type)
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "doesn't create new ethereum wallet" do
      expect do
        post v1_wallets_path, params: produce_wallet_params(user_id, user_type)
      end.to_not change(EthereumWallet, :count)
    end

    it "returns errors" do
      post v1_wallets_path, params: produce_wallet_params(user_id, user_type)
      expect(response.body).to have_json_path("errors")
    end
  end

  context "with invalid tyoe" do
    it "returns status :unprocessable_entity" do
      post v1_wallets_path, params: produce_wallet_params(user_id, "user")
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "doesn't create new ethereum wallet" do
      expect do
        post v1_wallets_path, params: produce_wallet_params(user_id, "user")
      end.to_not change(EthereumWallet, :count)
    end

    it "returns errors" do
      post v1_wallets_path, params: produce_wallet_params(user_id, "user")
      expect(response.body).to have_json_path("errors")
    end
  end

  def produce_wallet_params(user_id, user_type)
    { wallet: { user_id: user_id, user_type: user_type }, format: :json }
  end
end
