class CreateTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :transactions do |t|
      t.text :t_blockHash
      t.text :t_blockNumber
      t.text :t_from, index: true
      t.text :t_gas
      t.text :t_gasPrice
      t.text :t_hash, index: true, unique: true
      t.text :t_input
      t.text :t_nonce
      t.text :t_to
      t.text :t_transactionIndex
      t.text :t_value

      t.timestamps
    end
  end
end
