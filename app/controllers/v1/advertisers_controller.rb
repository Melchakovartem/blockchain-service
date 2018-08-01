class V1::AdvertisersController < ApplicationController
  def create_wallet
  	respond_with WalletService.create(params[:profile_id], "Advertiser"), serializer: V1::ProfileSerializer, 
  				       location: v1_advertisers_path
  end

  def update_wallet
  	respond_with WalletService.update(params[:profile_id], "Advertiser")
  end

  def get_balance
    respond_with TokenService.new(params[:profile_id], "Advertiser").get_balance
  end
end
