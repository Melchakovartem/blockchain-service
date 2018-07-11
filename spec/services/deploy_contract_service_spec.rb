require "rails_helper"

RSpec.describe DeployContractService do
  describe "call" do
    context "root invite" do
      let!(:profile_id) { rand(1..10) }
      let!(:profile_type) { "Owner" }
      let!(:owner) { Fabricate(:owner, profile_id: profile_id, root: true) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: owner.id, userable_type: "Owner") }

      let!(:ref_profile_id) { rand(11..20) }
      let!(:ref_profile_type) { "Owner" }
      let!(:ref_owner) { Fabricate(:owner, profile_id: ref_profile_id) }
      let!(:ref_ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: ref_owner.id, userable_type: "Owner") }

      it "creates contract with referral address" do
        client = EthereumClient.new(Settings.http_path)
        DeployContractService.call(profile_id, ref_profile_id)
        referrer = Owner.find_by_profile_id(profile_id)
        referral = Owner.find_by_profile_id(ref_profile_id)
        contract = client.set_contract("ref", referral.contract_address, Settings.referral_abi)
        expect("0x"+contract.call.referral).to eq(referral.ethereum_wallet.address.downcase)
      end

      it "creates contract with referrer address" do
        client = EthereumClient.new(Settings.http_path)
        DeployContractService.call(profile_id, ref_profile_id)
        referrer = Owner.find_by_profile_id(profile_id)
        referral = Owner.find_by_profile_id(ref_profile_id)
        contract = client.set_contract("ref", referral.contract_address, Settings.referral_abi)
        expect("0x"+contract.call.referrer).to eq(referrer.ethereum_wallet.address.downcase)
      end
    end

    context "non root invite" do
      let!(:profile_id) { rand(1..10) }
      let!(:profile_type) { "Owner" }
      let!(:owner) { Fabricate(:owner, profile_id: profile_id, root: false) }
      let!(:ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: owner.id, userable_type: "Owner") }

      let!(:ref_profile_id) { rand(11..20) }
      let!(:ref_profile_type) { "Owner" }
      let!(:ref_owner) { Fabricate(:owner, profile_id: ref_profile_id) }
      let!(:ref_ethereum_wallet) { Fabricate(:ethereum_wallet, userable_id: ref_owner.id, userable_type: "Owner") }

      it "creates contract with referral address" do
        client = EthereumClient.new(Settings.http_path)
        DeployContractService.call(profile_id, ref_profile_id)
        referrer = Owner.find_by_profile_id(profile_id)
        referral = Owner.find_by_profile_id(ref_profile_id)
        contract = client.set_contract("ref", referral.contract_address, Settings.referral_abi)
        expect("0x"+contract.call.referral).to eq(referral.ethereum_wallet.address.downcase)
      end

      it "creates contract with referrer address" do
        client = EthereumClient.new(Settings.http_path)
        DeployContractService.call(profile_id, ref_profile_id)
        referrer = Owner.find_by_profile_id(profile_id)
        referral = Owner.find_by_profile_id(ref_profile_id)
        contract = client.set_contract("ref", referral.contract_address, Settings.referral_abi)
        expect("0x"+contract.call.referrer).to eq(referrer.contract_address.downcase)
      end
    end
  end
end
