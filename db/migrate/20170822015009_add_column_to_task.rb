class AddColumnToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :planed_time, :integer
    add_column :tasks, :actual_time, :integer
  end
end