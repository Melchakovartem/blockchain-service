require "rails_helper"

RSpec.describe WalletService do
  describe "Advertiser" do
    let(:profile_id) { rand(1..10) }
    let(:profile_type) { "Advertiser" }
    let!(:spender) { Eth::Key.new.address }
    let(:amount) { rand(100..1000) }
    let(:advertiser) {  WalletService.create(profile_id, profile_type) }
    let(:priv_key) { advertiser.ethereum_wallet.private_hex }
    let(:token_service) { TokenService.new(priv_key) }

    context "method approve" do
      it 'approves tokens' do
        token_service.approve(spender, amount)
        expect(token_service.get_allowance(spender)).to eq(amount)
      end
    end

    context "method get_tokens" do
      it 'gets tokens' do
        token_service.get_tokens(amount)
        expect(token_service.get_balance).to eq(amount)
      end
    end
  end

  describe "Owner" do
    let(:profile_id) { rand(1..10) }
    let(:profile_type) { "Owner" }
    let!(:spender) { Eth::Key.new.address }
    let(:amount) { rand(100..1000) }
    let(:profile_params) { { root: true } }
    let(:owner) {  WalletService.create(profile_id, profile_type, profile_params) }
    let(:priv_key) { owner.ethereum_wallet.private_hex }
    let(:token_service) { TokenService.new(priv_key) }

    context "method approve" do
      it 'approves tokens' do
        token_service.approve(spender, amount)
        expect(token_service.get_allowance(spender)).to eq(amount)
      end
    end

    context "method get_tokens" do
      it 'gets tokens' do
        token_service.get_tokens(amount)
        expect(token_service.get_balance).to eq(amount)
      end
    end
  end
end
