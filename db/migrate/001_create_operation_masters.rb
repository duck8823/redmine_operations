class CreateOperationMasters < ActiveRecord::Migration
  def change
    create_table :operation_masters do |t|

      t.text :content


    end

  end
end
