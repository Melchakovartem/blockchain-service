class CreateBlocks < ActiveRecord::Migration[5.0]
  def change
    create_table :blocks do |t|
      t.text :b_difficulty
      t.text :b_extraData
      t.text :b_gasLimit
      t.text :b_gasUsed
      t.text :b_hash, index: true
      t.text :b_logsBloom
      t.text :b_miner
      t.text :b_mixHash
      t.text :b_nonce
      t.integer :b_number, index: true, unique: true
      t.text :b_parentHash
      t.text :b_receiptsRoot
      t.text :b_sha3Uncles
      t.text :b_size
      t.text :b_stateRoot
      t.text :b_timestamp
      t.text :b_totalDifficulty
      t.text :b_transactionsRoot
      t.text :b_uncles
      t.integer :b_txns

      t.timestamps
    end
  end
end
