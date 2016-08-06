class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|

      t.integer :task_master_id

      t.integer :operation_id

      t.boolean :done


    end

  end
end
