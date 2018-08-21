class SearchController < ApplicationController
  def index
  	@model, @result = SearchService.call(params[:q])
  end
end
