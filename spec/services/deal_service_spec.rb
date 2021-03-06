require "rails_helper"

RSpec.describe DealService do
  before(:all) do
    profile_id = rand(1..10)
    profile_type = "Advertiser"
    @advertiser = WalletService.create(profile_id, profile_type)
    priv_key = @advertiser.ethereum_wallet.private_hex
    @token_service = TokenService.new(priv_key)
    @token_amount = rand(20000..100000)
    @campaign_id = FFaker::Lorem.word
    @deal = Contract.find_by_name("deal")
    @token_service.get_tokens(10**10)
    @token_service.approve(10**25)
  end

  describe "Creates campaign" do
    before(:all) do
      @deal_service = DealService.new(@campaign_id)
      @deal_service.create_campaign(@advertiser, @token_amount) 
    end

    it "checks status" do
      expect(@deal_service.check_status).to eq("created")
    end

    it "checks creator campaign" do
      expect(@deal_service.get_creator).to eq(@advertiser.ethereum_wallet.address[2..42].downcase)
    end

    it "checks token amount" do
      expect(@deal_service.get_token_amount).to eq(@token_amount)
    end

    it "checks current balance of campaign" do
      expect(@deal_service.get_current_balance).to eq(@token_amount)
    end
  end

  describe "Add tokens to campaign" do
    before(:all) do
      @added_token_amount = rand(100..1000)
      @campaign_id = FFaker::Lorem.word 
      @deal_service = DealService.new(@campaign_id)
      @deal_service.create_campaign(@advertiser, @token_amount) 
      @deal_service.add_tokens(@added_token_amount)
    end

    it "checks token amount" do
      expect(@deal_service.get_token_amount).to eq(@token_amount + @added_token_amount)
    end

    it "checks current balance of campaign" do
      expect(@deal_service.get_current_balance).to eq(@token_amount + @added_token_amount)
    end
  end


  describe "Destroy campaign" do
    before(:all) do
      @campaign_id = FFaker::Lorem.word
      @deal_service = DealService.new(@campaign_id)
      @deal_service.create_campaign(@advertiser, @token_amount)
      @deal_service.destroy
    end

    it "checks token amount" do
      expect(@deal_service.get_token_amount).to be_zero
    end

    it "checks current balance of campaign" do
      expect(@deal_service.get_current_balance).to be_zero
    end

    it "checks status" do
      expect(@deal_service.check_status).to eq("destroyed")
    end
  end

  describe "Send coins" do
    before(:all) do
      @campaign_id = FFaker::Lorem.word

      @root_owner_profile_id = rand(1..10)
      @owner_profile_type = "Owner"
      root_profile_params = { root: "true" }
      @root_owner = WalletService.create(@root_owner_profile_id, @owner_profile_type, root_profile_params)
       
      @referral_owner_profile_id = rand(11..20)
      @referral_profile_params = { root: "false", referrer_profile_id: @root_owner_profile_id }
      @referral_owner = WalletService.create(@referral_owner_profile_id, @owner_profile_type, @referral_profile_params)

      @deal_service = DealService.new(@campaign_id)
      @deal_service.create_campaign(@advertiser, @token_amount)
      @token_amount_hash = {"#{@root_owner_profile_id}"  => "10000", "#{@referral_owner_profile_id}" => "10000"}
      @deal_service.send_coins(@token_amount_hash)

    end

    it "checks token amount of root_owner " do
      priv_key = Owner.by_profile(@root_owner_profile_id).ethereum_wallet.private_hex
      token_service_root = TokenService.new(priv_key)
      expect(token_service_root.get_balance).to eq(11875)
    end

    it "checks token amount of non_root_owner " do
      priv_key = Owner.by_profile(@referral_owner_profile_id).ethereum_wallet.private_hex
      token_service = TokenService.new(priv_key)
      expect(token_service.get_balance).to eq(7125)
    end

    it  "checks token amount of wwf" do
      token_service_wwf = TokenService.new(Settings.wwf_priv_hex)
      expect(token_service_wwf.get_balance).to eq(1000)
    end

    it "checks current balance of campaign" do
      expect(@deal_service.get_current_balance).to eq(@token_amount - (20000))
    end
  end
end
