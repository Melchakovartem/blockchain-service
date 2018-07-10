class CreateAdvertisers < ActiveRecord::Migration[5.0]
  def change
    create_table :advertisers do |t|

      t.integer :profile_id, index: true, unique: true
      t.timestamps
    end
  end
end
