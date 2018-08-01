class V1::AdvertisersController < ApplicationController
  before_action :token_service, except: [:create_wallet, :update_wallet]
  
  def create_wallet
  	respond_with WalletService.create(params[:profile_id], "Advertiser"), serializer: V1::ProfileSerializer, 
  				       location: v1_advertisers_path
  end

  def update_wallet
  	respond_with WalletService.update(params[:profile_id], "Advertiser")
  end

  def get_balance
    respond_with token_service.get_balance
  end

  def get_tokens
    token_service.get_tokens(params[:token_amount])
  end

  private

    def profile_params
      params.require(:profile_params).permit(:root, :referrer_profile_id)
    end

    def token_service
      TokenService.new(params[:profile_id], "Advertiser")
    end
end
