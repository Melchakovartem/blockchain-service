class V1::AdvertisersController < ApplicationController
  def create
  	respond_with WalletService.create(params[:profile_id], "Advertiser"), serializer: V1::ProfileSerializer, 
  				       location: v1_advertisers_path
  end

  def update
  	respond_with WalletService.update(params[:profile_id], "Advertiser")
  end
end
