class CreateOperationMasters < ActiveRecord::Migration
  def change
    create_table :operation_masters do |t|

      t.text :content

      t.float :estimated_hours

      t.integer :project_id

      t.integer :editable


    end

  end
end
