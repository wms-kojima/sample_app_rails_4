class CreateDailies < ActiveRecord::Migration
  def change
    create_table :dailies do |t|
      t.integer :planed_time
      t.integer :actual_time
      t.date :the_date
      t.references :task

      t.timestamps null: false
    end
  end
end
