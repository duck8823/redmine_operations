class OperationMaster < ActiveRecord::Base
  unloadable

  has_many :task_master
end
