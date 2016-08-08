class CreateOperationConfigs < ActiveRecord::Migration
  def change
    create_table :operation_configs do |t|

      t.integer :activity_id

      t.integer :done_status_id

      t.integer :progress_status_id

      t.integer :project_id


    end

  end
end
