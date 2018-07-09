class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  respond_to :json

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def record_not_found
    head :not_found
  end
end
