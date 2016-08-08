class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|

      t.belongs_to :issue

      t.belongs_to :operation_master

      t.belongs_to :time_entry


    end

    add_index :operations, :issue_id

    add_index :operations, :operation_master_id

    add_index :operations, :time_entry_id

  end
end
