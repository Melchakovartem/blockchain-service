class CreateOwners < ActiveRecord::Migration[5.0]
  def change
    create_table :owners do |t|

      t.integer :profile_id, index: true, unique: true
      t.integer :referrer_id, index: true, unique: true
      t.string :contract_address
      t.boolean :root

      t.timestamps
    end
  end
end
