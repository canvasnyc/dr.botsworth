class CreateCheckups < ActiveRecord::Migration
  def change
    create_table :checkups do |t|
      t.boolean :healthy
      t.float :name_lookup_time
      t.float :start_transfer_time
      t.float :total_time
      t.integer :downloaded_bytes
      t.integer :retries_used
      t.references :environment

      t.timestamps
    end
    add_index :checkups, :environment_id
  end
end
