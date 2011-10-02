class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.string :name
      t.string :url
      t.references :site

      t.timestamps
    end
    add_index :environments, :site_id
  end
end
