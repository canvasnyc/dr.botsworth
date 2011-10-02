class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.string :name
      t.string :url
      t.integer :timeout
      t.integer :retries
      t.integer :between_retries_wait
      t.string :ip_relay_commands
      t.references :site

      t.timestamps
    end
    add_index :environments, :site_id
  end
end
