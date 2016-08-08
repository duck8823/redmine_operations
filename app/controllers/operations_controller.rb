require 'bigdecimal'

class OperationsController < ApplicationController
	unloadable


	def update
		task = Task.find(params[:task_id].to_i)
		task.done = params[:checked]
		task.save

		checked_num = 0
		task.operation.task.each do |op_task|
			if op_task.done?
				checked_num = checked_num + 1
			end
		end

		issue = Issue.find(task.operation.issue_id)
		issue.done_ratio = (BigDecimal(checked_num.to_s) / BigDecimal(task.operation.task.length.to_s)) * 100
		if issue.done_ratio >= 100
			issue.status = IssueStatus.find(OperationConfig.where(project_id: issue.project.id)[0].done_status_id)
		elsif issue.done_ratio < 100 && issue.done_ratio > 0
			issue.status = IssueStatus.find(OperationConfig.where(project_id: issue.project.id)[0].in_progress_status_id)
		end
		issue.save

		task.operation.time_entry.hours = (BigDecimal(issue.done_ratio.to_s) * BigDecimal(task.operation.operation_master.estimated_hours.to_s)) / 100
		task.operation.time_entry.save

		render :nothing => true, :status => 200

	end

end
