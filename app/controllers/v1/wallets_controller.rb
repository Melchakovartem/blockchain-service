class V1::WalletsController < ApplicationController
  before_action :load_wallet, only: [:update]

  def create
  	respond_with WalletService.create(params[:user_id]), serializer: V1::WalletSerializer, 
  				 location: v1_wallets_path
  end

  def update
  	respond_with WalletService.update(@wallet)
  end

  private

  	def load_wallet
  	  @wallet = EthereumWallet.find_by_user_id!(params[:user_id])
  	end
end
