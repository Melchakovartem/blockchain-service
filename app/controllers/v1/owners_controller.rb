class V1::OwnersController < ApplicationController
  def create
  	respond_with WalletService.create(params[:profile_id], "Owner", params[:profile_params]), serializer: V1::ProfileSerializer, 
  				       location: v1_advertisers_path
  end

  def update
  	respond_with WalletService.update(params[:profile_id], "Owner")
  end
end
