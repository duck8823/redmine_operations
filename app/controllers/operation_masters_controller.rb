class OperationMastersController < ApplicationController
	unloadable
	menu_item :operations
	before_filter :find_project, :authorize

	def index
		@operation_masters = OperationMaster.where(project_id: @project)
		@operation_config = OperationConfig.where(project_id: @project)[0]
		@activities = Enumeration.where(type: 'TimeEntryActivity')
		@issue_statuses = IssueStatus.all
	end

	def show
	end

	def create
	end

	def edit
	end

	def update
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
		end

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