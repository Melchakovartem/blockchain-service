require "rails_helper"

RSpec.describe "Wallet create" do
  context "owner" do
    let(:profile_id) { rand(1..100) }
    let(:profile_type) { "Owner" }

    context "with valid id" do
      it "returns status :created" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response).to have_http_status(:created)
      end 

       it "creates new ethereum wallet" do
         expect do
           post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
         end.to change { EthereumWallet.count }.by(1)
       end
  
      it "returns correct profile_id" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response.body).to be_json_eql(profile_id).at_path("profile_id")
      end

      it "returns correct profile_type" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response.body).to be_json_eql(profile_type.to_json).at_path("profile_type")
      end

      it "returns address" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response.body).to have_json_path("address")
      end
    end

    context "with taken id" do
      let!(:profile_id) { rand(1..100) }
      let!(:profile_type) { "Owner" }
      let!(:owner) { Fabricate(:owner, profile_id: profile_id) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: owner.id, userable_type: "Owner") }

      it "returns status :unprocessable_entity" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't create new ethereum wallet" do
        expect do
          post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        end.to_not change(EthereumWallet, :count)
      end
  
      it "returns errors" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response.body).to have_json_path("errors")
      end
    end
  end

  context "Advertiser" do
    let(:profile_id) { rand(1..100) }
    let(:profile_type) { "Advertiser" }

    context "with valid id" do
      it "returns status :created" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response).to have_http_status(:created)
      end 

       it "creates new ethereum wallet" do
         expect do
           post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
         end.to change { EthereumWallet.count }.by(1)
       end
  
      it "returns correct profile_id" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response.body).to be_json_eql(profile_id).at_path("profile_id")
      end

      it "returns correct profile_type" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response.body).to be_json_eql(profile_type.to_json).at_path("profile_type")
      end

      it "returns address" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response.body).to have_json_path("address")
      end
    end

    context "with taken id" do
      let!(:profile_id) { rand(1..100) }
      let!(:profile_type) { "Advertiser" }
      let!(:advertiser) { Fabricate(:advertiser, profile_id: profile_id) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: advertiser.id, userable_type: "Advertiser") }

      it "returns status :unprocessable_entity" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "doesn't create new ethereum wallet" do
        expect do
          post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        end.to_not change(EthereumWallet, :count)
      end
  
      it "returns errors" do
        post v1_profiles_path, params: produce_wallet_params(profile_id, profile_type)
        expect(response.body).to have_json_path("errors")
      end
    end
  end

  context "with invalid type" do
    let(:profile_id) { rand(1..100) }
    let(:profile_type) { "user" }

    it "returns status :unprocessable_entity" do
      post v1_profiles_path, params: produce_wallet_params(profile_id, "user")
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "doesn't create new ethereum wallet" do
      expect do
        post v1_profiles_path, params: produce_wallet_params(profile_id, "user")
      end.to_not change(EthereumWallet, :count)
    end
  end
  

  def produce_wallet_params(profile_id, profile_type)
    { profile: { profile_id: profile_id, profile_type: profile_type }, format: :json }
  end
end
