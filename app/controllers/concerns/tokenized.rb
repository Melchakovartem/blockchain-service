module Tokenized
  extend ActiveSupport::Concern

  included do
    before_action :token_service, only: [:get_balance, :get_tokens, :approve_tokens, :get_allowance]
  end

  def get_balance
    respond_with token_service.get_balance
  end

  def get_tokens
    token_service.get_tokens(params[:token_amount])
  end

  def approve_tokens
  	token_service.approve(params[:token_amount])
  end

  def show_allowance
  	respond_with token_service.get_allowance
  end
end