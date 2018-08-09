require "rails_helper"

RSpec.describe "Send coins" do
  let!(:profile_id) { rand(1..10) }
  let!(:profile_type) { "Advertiser" }
  let!(:advertiser) { WalletService.create(profile_id, profile_type) }
  let!(:priv_key) { advertiser.ethereum_wallet.private_hex }
  let!(:token_service) { TokenService.new(priv_key) }
  let!(:token_amount) { rand(20000..100000) }
  let!(:campaign_id) { FFaker::Lorem.word }
  let!(:deal) { Contract.find_by_name("deal") }
    

  let!(:root_owner_profile_id) { rand(1..10) }
  let!(:owner_profile_type) { "Owner" }
  let!(:root_profile_params) { {root: "true" } }
  let!(:root_owner) { WalletService.create(root_owner_profile_id, owner_profile_type, root_profile_params) }
       
  let!(:referral_owner_profile_id) { rand(11..20) }
  let!(:referral_profile_params) { { root: "false", referrer_profile_id: root_owner_profile_id } }
  let!(:referral_owner) { WalletService.create(referral_owner_profile_id, owner_profile_type, referral_profile_params) }

  let!(:deal_service) { DealService.new(campaign_id) }

  
  
  context "owner profiles exists" do
    let!(:token_amount_hash) { {"#{root_owner_profile_id}"  => "10000", "#{referral_owner_profile_id}" => "10000"} }

    before do
      token_service.get_tokens(10**10)
      token_service.approve(10**25)
      deal_service.create_campaign(advertiser, token_amount)
      post v1_campaign_send_coins_path(campaign_id), params: { token_distribution:  token_amount_hash }
    end

    it "returns status :no_content" do
      pp v1_campaign_send_coins_path(campaign_id), params: { token_distribution:  token_amount_hash }
      expect(response).to have_http_status(:no_content)
    end

    it "checks token amount of root_owner " do
      priv_key = Owner.by_profile(root_owner_profile_id).ethereum_wallet.private_hex
      token_service_root = TokenService.new(priv_key)
      expect(token_service_root.get_balance).to eq(11875)
    end

    it "checks token amount of non_root_owner " do
      priv_key = Owner.by_profile(referral_owner_profile_id).ethereum_wallet.private_hex
      token_service = TokenService.new(priv_key)
      expect(token_service.get_balance).to eq(7125)
    end

    it "checks current balance of campaign" do
      expect(deal_service.get_current_balance).to eq(token_amount - (20000))
    end
  end

  context "owner profiles not exists" do
    let(:not_exist_referral_owner_profile_id) { rand(21..30) }
    let!(:token_amount_hash) { {"#{root_owner_profile_id}"  => "10000", "#{not_exist_referral_owner_profile_id}" => "10000"} }
    
    before do
      token_service.get_tokens(10**10)
      token_service.approve(10**25)
      deal_service.create_campaign(advertiser, token_amount)
      post v1_campaign_send_coins_path(campaign_id), params: { token_distribution:  token_amount_hash }
    end

    it "returns status :not_found" do
      expect(response).to have_http_status(:not_found)
    end
  end
end
