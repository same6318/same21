class RemoveColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :tasks, :label_id, :bigint
    remove_column :labels, :task_id, :bigint
  end
end
