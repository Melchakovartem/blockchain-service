class V1::WalletsController < ApplicationController
  def create
  	respond_with CreateWalletService.call(params[:user_id]), serializer: V1::WalletSerializer, 
  				 location: v1_wallets_path
  end
end
