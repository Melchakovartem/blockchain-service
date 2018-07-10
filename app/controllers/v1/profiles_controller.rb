class V1::ProfilesController < ApplicationController
  before_action :check_model

  def create
  	respond_with WalletService.create(profile_params), serializer: V1::ProfileSerializer, 
  				       location: v1_profiles_path
  end

  def update
  	respond_with WalletService.update(profile_params)
  end

  private

    def profile_params
      params.fetch(:profile).permit(:profile_id, :profile_type)
    end

    def check_model
      type = profile_params[:profile_type]
      return head :unprocessable_entity if type != "Owner" and type != "Advertiser"
    end
end
