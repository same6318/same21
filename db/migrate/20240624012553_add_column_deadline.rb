class AddColumnDeadline < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :deadline_on, :date, null: false
    add_column :tasks, :priority, :integer, default: "", null: false
    add_column :tasks, :status, :integer, default: "", null: false
  end
end
