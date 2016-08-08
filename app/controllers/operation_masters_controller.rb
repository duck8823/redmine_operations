class OperationMastersController < ApplicationController
	unloadable
	menu_item :redmine_operations
	before_filter :find_project, :authorize

	def index
		@operation_masters = OperationMaster.where(project_id: @project)
		@operation_config = OperationConfig.where(project_id: @project)[0]
		@trackers = Tracker.all
		@activities = Enumeration.where(type: 'TimeEntryActivity')
		@issue_statuses = IssueStatus.all

		@date = []
		@operation_masters.each do |operation_master|
			operations = Operation.where(operation_master_id: operation_master.id)
			date = []
			operations.each do |operation|
				begin
					date.push(Issue.find(operation.issue_id).due_date.to_s)
				rescue ActiveRecord::RecordNotFound
					# ignored
				end
			end
			@date[operation_master.id] = date
		end
	end

	def show
	end

	def create
	end

	def edit
	end

	def update
		task_masters = []
		operation_master = OperationMaster.find(params[:operation_master]['id'])
		operation_master.content = params[:operation_master]['content']
		operation_master.estimated_hours = params[:operation_master]['estimated_hours']

		operation_master.task_master.each do |task_master|
			param_task_master = params[:task_master].present? ? params[:task_master][task_master.id.to_s] : nil
			if param_task_master.nil?
				task_master.editable = 0
			else
				task_master.content = param_task_master['content']
				task_master.editable = 1
			end
			task_master.save
			task_masters.push(task_master)
		end
		operation_master.save

		operation = Operation.where(operation_master_id: operation_master.id)
		operation.each do |op|
			op.delete
		end
		due_date = params[:operation_date].split(',')
		if due_date[0].present?
			issues = Issue.where("due_date NOT IN (#{due_date.to_s.gsub(/"/, "'").gsub(/^\[|\]$/, '')})")
			issue_ids = []
			issues.each do |issue|
				issue_ids.push(issue.id)
				issue.delete
			end
			delete_ops = Operation.where("issue_id NOT IN (#{issue_ids.to_s.gsub(/^\[|\]$/, '')})")
			delete_ops.each do |op|
				op.delete
			end

			due_date.each do |date|
				issue = Issue.where({
																project_id: @project,
																start_date: date,
																due_date: date
														})[0]
				if issue.nil?
					issue = Issue.create!({
																		project_id: @project,
																		subject: operation_master.content,
																		tracker_id: OperationConfig.where(project_id: @project)[0].tracker_id,
																		author_id: User.current.id,
																		start_date: date,
																		due_date: date
																})
				else
					issue.subject = operation_master.content
				end

				issue.save

				operation = Operation.create!({
																					issue_id: issue.id,
																					operation_master_id: operation_master.id
																			})
				operation.save

				task_masters.each do |task_master|
					if task_master.editable == 1
						task = Task.create!({
																		task_master_id: task_master.id,
																		operation_id: operation.id
																})
						task.save
					end
				end
			end
		end


		redirect_to action: 'index'
	end

	def delete
		operation_master = OperationMaster.find(params[:operation_master_id])
		operation_master.editable = 0
		operation_master.save

		redirect_to action: 'index'
	end

	def add_task
		task_master = TaskMaster.create!({
																				 operation_master_id: params[:operation_master]['id'],
																				 editable: 0
																		 })
		render :json => task_master
	end

	def update_config
		operation_config = OperationConfig.where(project_id: @project)[0]
		if operation_config.nil?
			operation_config = OperationConfig.create!(project_id: @project.id)
		end
		operation_config.tracker_id = params[:tracker_id]
		operation_config.activity_id = params[:activity_id]
		operation_config.progress_status_id = params[:progress_status_id]
		operation_config.done_status_id = params[:done_status_id]
		operation_config.save

		redirect_to action: 'index'
	end

	def add
		puts params
		OperationMaster.create!({
																project_id: params[:project_id],
																editable: 1
														})

		redirect_to action: 'index'
	end

	def destroy
	end

	private
	def find_project
		@project = Project.find(params[:project_id])
	rescue ActiveRecord::RecordNotFound
		render_404
	end

end