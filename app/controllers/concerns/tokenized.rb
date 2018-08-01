module Tokenized
  extend ActiveSupport::Concern

  included do
    before_action :token_service, except: [:create_wallet, :update_wallet]
  end

  def get_balance
    respond_with token_service.get_balance
  end

  def get_tokens
    token_service.get_tokens(params[:token_amount])
  end

  def approve_tokens
  	token_service.approve(params[:spender], params[:token_amount])
  end
end