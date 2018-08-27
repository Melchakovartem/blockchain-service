class CreateContracts < ActiveRecord::Migration[5.0]
  def change
    create_table :contracts do |t|
      t.string :name
      t.string :address
      t.text :abi
      t.text :code

      t.timestamps
    end
  end
end
