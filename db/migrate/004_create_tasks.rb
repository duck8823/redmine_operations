class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|

      t.belongs_to :task_master

      t.belongs_to :operation

      t.integer :done


    end

    add_index :tasks, :task_master_id

    add_index :tasks, :operation_id

  end
end
