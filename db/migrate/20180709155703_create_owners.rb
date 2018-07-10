class CreateOwners < ActiveRecord::Migration[5.0]
  def change
    create_table :owners do |t|

      t.integer :profile_id, index: true, unique: true
      t.string :referrer_address
      t.string :contract_address

      t.timestamps
    end
  end
end
