class BlocksController < ApplicationController
  def index
  	@blocks = Block.paginate(:page => params[:page], :per_page => 30).order(b_number: :asc)
  end

  def show
  	@block = Block.find_by_b_number(params[:id])
  end
end
