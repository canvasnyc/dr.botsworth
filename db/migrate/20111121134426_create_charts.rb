class CreateCharts < ActiveRecord::Migration
  def change
    create_table :charts do |t|
      t.references :environment
      t.datetime :starts_at
      t.datetime :ends_at
      t.string :series
      t.text :data

      t.timestamps
    end
    add_index :charts, :environment_id
  end
end
