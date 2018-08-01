class V1::OwnersController < ApplicationController
  def create_wallet
  	respond_with WalletService.create(params[:profile_id], "Owner", profile_params), serializer: V1::ProfileSerializer, 
  				       location: v1_advertisers_path
  end

  def update_wallet
  	respond_with WalletService.update(params[:profile_id], "Owner")
  end

  def get_balance
    respond_with TokenService.new(params[:profile_id], "Owner").get_balance
  end

  private

  	def profile_params
  	  params.require(:profile_params).permit(:root, :referrer_profile_id)
  	end
end
