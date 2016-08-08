require 'redmine'
require_dependency 'operations/hooks'

Rails.configuration.to_prepare do
	require_dependency 'issues_controller'
	unless IssuesController.included_modules.include? Operations::IssuesControllerPatch
		IssuesController.send(:include, Operations::IssuesControllerPatch)
	end
end

Redmine::Plugin.register :operations do
	name 'Operations plugin'
	author 'duck8823@gmail.com'
	description 'this is plugin for easily daily/weekly/monthly operations'
	version '0.0.1'
	url 'https://github.com/duck8823/redmine_operations'
	author_url 'http://www.duck8823.com/'

	project_module :operations do
		permission :view_operation_masters, :operation_masters => [:index, :show]
		permission :manage_operation_masters, :operation_masters => [:create, :edit, :destroy, :update, :add_task, :update_config, :add]
	end
	menu :project_menu, :operations, { :controller => 'operation_masters', :action => 'index'}, :param => :project_id
end
