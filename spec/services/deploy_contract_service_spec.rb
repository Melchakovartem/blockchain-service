require "rails_helper"

RSpec.describe DeployContractService do
  describe "call" do
    let!(:referrer_profile_id) { rand(1..10) }
    let!(:referral_profile_id) { rand(11..20) }
    let!(:referrer_ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: referrer.id, userable_type: "Owner") }
    let!(:referral_ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: referral.id, userable_type: "Owner") }

    let!(:client) { EthereumClient.new(Settings.http_path) }

    before do
      DeployContractService.call(referrer_profile_id, referral_profile_id)
    end

    context "referrer is root" do
      let!(:referral) { Fabricate(:owner, profile_id: referral_profile_id) }
      let!(:referrer) { Fabricate(:owner, profile_id: referrer_profile_id, root: true) }

      it "creates contract with referral address" do
        contract = client.set_contract("ref", referral.reload.contract_address, Settings.referral_abi)
        expect("0x"+contract.call.referral).to eq(referral.ethereum_wallet.address.downcase)
      end

      it "creates contract with referrer address" do
        contract = client.set_contract("ref", referral.reload.contract_address, Settings.referral_abi)
        expect("0x"+contract.call.referrer).to eq(referrer.ethereum_wallet.address.downcase)
      end
    end

    context "referrer isn't root" do
      let!(:referral) { Fabricate(:owner, profile_id: referral_profile_id) }
      let!(:referrer) { Fabricate(:owner, profile_id: referrer_profile_id, root: false, contract_address: Eth::Key.new.address) }

      it "creates contract with referral address" do
        contract = client.set_contract("ref", referral.reload.contract_address, Settings.referral_abi)
        expect("0x"+contract.call.referral).to eq(referral.ethereum_wallet.address.downcase)
      end

      it "creates contract with referrer address" do
        contract = client.set_contract("ref", referral.reload.contract_address, Settings.referral_abi)
        expect("0x"+contract.call.referrer).to eq(referrer.contract_address.downcase)
      end
    end
  end
end
