class V1::CampaignsController < ApplicationController
  before_action :advertiser, only: [:create]

  def create
    DealService.new(params[:campaign_id]).create_campaign(advertiser, params[:token_amount])
  end

  def show
    respond_with DealService.new(params[:campaign_id]), serializer: V1::CampaignSerializer
  end

  private
    def advertiser
      Advertiser.find_by_profile_id!(params[:profile_id])
    end
end
