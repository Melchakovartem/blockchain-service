class CreateTokenTransfers < ActiveRecord::Migration[5.0]
  def change
    create_table :token_transfers do |t|
      t.string :from
      t.string :to
      t.string :amount
      t.string :tr_hash

      t.timestamps
    end
  end
end
