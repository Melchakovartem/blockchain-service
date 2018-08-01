require "rails_helper"

RSpec.describe WalletService do
  let!(:client) { EthereumClient.new(Settings.http_path) }
  let!(:token) { client.set_contract(Settings.token_name, Settings.token_address, Settings.token_abi) }

  describe "Advertiser" do
    let(:profile_id) { rand(1..10) }
    let(:profile_type) { "Advertiser" }
    let!(:spender) { Eth::Key.new.address }
    let(:amount) { rand(100.1000) }
    
    before do 
      WalletService.create(profile_id, profile_type)
    end

    context "method approve" do
      it 'approves tokens' do
        token_service = TokenService.new(profile_id, profile_type)
        token_service.approve(spender, amount)
        expect(token_service.get_allowance(spender)).to eq(amount)
      end
    end

    context "method get_tokens" do
      it 'gets tokens' do
        token_service = TokenService.new(profile_id, profile_type)
        token_service.get_tokens(amount)
        expect(token_service.get_balance).to eq(amount)
      end
    end
  end

  describe "Owner" do
    let(:profile_id) { rand(1..10) }
    let(:profile_type) { "Owner" }
    let!(:spender) { Eth::Key.new.address }
    let(:amount) { rand(100.1000) }
    let(:profile_params) { { root: true } }
    
    before do 
      WalletService.create(profile_id, profile_type, profile_params)
    end

    context "method approve" do
      it 'approves tokens' do
        token_service = TokenService.new(profile_id, profile_type)
        token_service.approve(spender, amount)
        expect(token_service.get_allowance(spender)).to eq(amount)
      end
    end

    context "method get_tokens" do
      it 'gets tokens' do
        token_service = TokenService.new(profile_id, profile_type)
        token_service.get_tokens(amount)
        expect(token_service.get_balance).to eq(amount)
      end
    end
  end
end
