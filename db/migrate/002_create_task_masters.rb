class CreateTaskMasters < ActiveRecord::Migration
  def change
    create_table :task_masters do |t|

      t.integer :operation_master_id

      t.text :content


    end

  end
end
