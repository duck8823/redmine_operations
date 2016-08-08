class Operation < ActiveRecord::Base
  unloadable

  belongs_to :operation_master
  belongs_to :time_entry
  has_many :task
end
