class SearchController < ApplicationController
  def index
  	@model, @result = SearchService.call(params[:q])
  	render template: "layouts/_bad_request" unless @result
  end
end
