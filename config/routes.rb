# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
	resources :issues do
		post 'operations/' => 'operations#update'
	end
	resources :projects do
		get 'operations/' => 'operation_masters#index'
		post 'operations/update' => 'operation_masters#update'
		post 'operations/config/update' => 'operation_masters#update_config'
		post 'operations/task/add' => 'operation_masters#add_task'
		get 'operations/add' => 'operation_masters#add'
		get 'operations/delete' => 'operation_masters#delete'
	end
end