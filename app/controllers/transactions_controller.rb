class TransactionsController < ApplicationController
  def show
  	pp params[:id]
  	@transaction = Transaction.find_by_t_hash(params[:id])
  end

  def index
  	@block = Block.find_by_b_number(params[:block_id])
  	pp @block.b_transactions
  	@transactions = Transaction.where(t_hash: @block.b_transactions)
  end
end
