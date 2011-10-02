class ChangeHealthyColumnDefault < ActiveRecord::Migration
  def up
    change_column_default(:checkups, :healthy, false)
  end

  def down
  end
end
