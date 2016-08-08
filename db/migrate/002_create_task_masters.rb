class CreateTaskMasters < ActiveRecord::Migration
  def change
    create_table :task_masters do |t|

      t.belongs_to :operation_master

      t.text :content

      t.integer :editable


    end

    add_index :task_masters, :operation_master_id

  end
end
