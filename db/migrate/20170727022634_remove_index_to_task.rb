class RemoveIndexToTask < ActiveRecord::Migration
  def change
    remove_index :tasks, ["user_id", "created_at"]
  end
end
