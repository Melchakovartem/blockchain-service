require "rails_helper"

RSpec.describe "Wallet create" do
  let(:user_id) { rand(1..100) }

  context "with valid id" do
    it "returns status :created" do
      post v1_wallets_path, params: {  user_id: user_id }
      expect(response).to have_http_status(:created)
    end 

     it "creates new ethereum wallet" do
       expect do
         post v1_wallets_path, params: {  user_id: user_id }
       end.to change { EthereumWallet.count }.by(1)
     end
  
    it "returns correct user_id" do
      post v1_wallets_path, params: {  user_id: user_id }
      expect(response.body).to be_json_eql(user_id).at_path("user_id")
    end

    it "returns address" do
      post v1_wallets_path, params: {  user_id: user_id }
      expect(response.body).to have_json_path("address")
    end
  end

  context "with taken id" do
    it "returns status :unprocessable_entity" do
      WalletService.create(user_id)
      post v1_wallets_path, params: {  user_id: user_id }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "doesn't create new ethereum wallet" do
      WalletService.create(user_id)
      expect do
        post v1_wallets_path, params: {  user_id: user_id }
      end.to_not change(EthereumWallet, :count)
    end

    it "returns errors" do
      WalletService.create(user_id)
      post v1_wallets_path, params: {  user_id: user_id }
      expect(response.body).to have_json_path("errors")
    end
  end
end
