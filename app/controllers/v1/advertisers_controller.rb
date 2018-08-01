class V1::AdvertisersController < ApplicationController
  include Tokenized

  def create_wallet
  	respond_with WalletService.create(params[:profile_id], "Advertiser"), serializer: V1::ProfileSerializer, 
  				       location: v1_advertisers_path
  end

  def update_wallet
  	respond_with WalletService.update(params[:profile_id], "Advertiser")
  end

  private

    def profile_params
      params.require(:profile_params).permit(:root, :referrer_profile_id)
    end

    def token_service
      TokenService.new(params[:profile_id], "Advertiser")
    end
end
