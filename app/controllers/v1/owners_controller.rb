class V1::OwnersController < ApplicationController
  include Tokenized

  def create_wallet
  	respond_with WalletService.create(params[:owner_id], "Owner", profile_params), serializer: V1::ProfileSerializer, 
  				       location: v1_owners_path
  end

  def update_wallet
  	respond_with WalletService.update(params[:owner_id], "Owner")
  end

  def show
    profile = Owner.find_by_profile_id!(params[:owner_id] || params[:id])
    respond_with profile, serializer: V1::OwnerSerializer,
                 location: v1_owner_path
  end

  private

  	def profile_params
  	  params.require(:profile_params).permit(:root, :referrer_profile_id)
  	end

    def token_service
      id = params[:owner_id] || params[:id]
      priv_key = Owner.find_by_profile_id!(id).ethereum_wallet.private_hex
      TokenService.new(priv_key)
    end
end
