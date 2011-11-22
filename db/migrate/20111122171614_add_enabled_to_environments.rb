class AddEnabledToEnvironments < ActiveRecord::Migration
  def up
    change_table :environments do |t|
      t.boolean :enabled, :default => true
    end
  end
 
  def down
    remove_column :environments, :enabled
  end
end
