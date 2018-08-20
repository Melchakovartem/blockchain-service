class BlocksController < ApplicationController
  def index
  	@blocks = Block.all
  end

  def show
  	@block = Block.find_by_b_number(params[:id])
  end
end
