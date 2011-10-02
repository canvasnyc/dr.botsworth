class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.integer :timeout
      t.integer :retries
      t.integer :between_retries_wait
      t.string :ip_relay_commands

      t.timestamps
    end
  end
end
