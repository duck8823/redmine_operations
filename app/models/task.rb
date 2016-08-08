class Task < ActiveRecord::Base
  unloadable

  belongs_to :operation
  belongs_to :task_master
end
