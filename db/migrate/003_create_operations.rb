class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|

      t.integer :issue_id


    end

  end
end
