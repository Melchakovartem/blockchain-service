class TransactionsController < ApplicationController
  def show
  	@transaction = Transaction.find_by_t_hash!(params[:id])
  end

  def index
  	@block = Block.find_by_b_number!(params[:block_id])
  	@transactions = Transaction.where(t_hash: @block.b_transactions)
  end

  def all
  	@transactions = Transaction.paginate(:page => params[:page], :per_page => 30).order(created_at: :desc)
  end
end
