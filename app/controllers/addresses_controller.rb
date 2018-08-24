class AddressesController < ApplicationController

  def show
  	if /^0x[a-fA-F0-9]{40}$/ === params[:id]
  	  @address, @eth_balance, @wt_balance = AddressService.call(params[:id])
  	else
  	  render template: "layouts/_bad_request" 
  	end
  end

  private

    def check_params
      return unless /^0x[a-fA-F0-9]{40}$/ === params[:id] 
    end
end
