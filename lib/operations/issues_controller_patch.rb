module Operations
	module IssuesControllerPatch
		def self.included(base)
			base.send(:include, InstanceMethods)

			base.class_eval do
				unloadable

				alias_method_chain :show, :operation
			end
		end

		module InstanceMethods
			def show_with_operation
				operations = Operation.where(issue_id: @issue.id)
				if operations.length == 1
					@operation = operations[0]
					if @operation.time_entry.nil?
						time_entry = TimeEntry.create!(
																			project: @issue.project,
																			issue: @issue,
																			user: User.current,
																			spent_on: User.current.today,
																			hours: 0,
																			activity: Enumeration.find(OperationConfig.where(project_id: @issue.project.id)[0].activity_id)
						)
						@operation.time_entry = time_entry
						@operation.save
					end
				end
				return show_without_operation # show_with_hogehoge に対して show_without_hogehoge
			end
		end
	end
end