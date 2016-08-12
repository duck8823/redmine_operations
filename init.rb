require 'redmine'
require_dependency 'operations/hooks'

Rails.configuration.to_prepare do
	require_dependency 'issues_controller'
	unless IssuesController.included_modules.include? Operations::IssuesControllerPatch
		IssuesController.send(:include, Operations::IssuesControllerPatch)
	end
end

Redmine::Plugin.register :redmine_operations do
	name 'Redmine Operations plugin'
	author 'duck8823@gmail.com'
	description 'this is plugin for easily daily/weekly/monthly operations'
	version '0.0.1'
	url 'https://github.com/duck8823/redmine_operations'
	author_url 'http://www.duck8823.com/'

	project_module :redmine_operations do
		permission :manage_operation_masters, :operation_masters => [:index, :update, :delete, :add_task, :update_config, :add]
	end
	menu :project_menu, :operations, { :controller => 'operation_masters', :action => 'index'}, :param => :project_id
end
