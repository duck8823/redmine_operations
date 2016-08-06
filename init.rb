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
end
