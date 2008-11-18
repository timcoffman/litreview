ActionController::Routing::Routes.draw do |map|
  map.resources :tags
  
  map.resources :users do |users|
    users.resources :managers
    users.resources :projects, :member => { :report => :get, :invite_reviewer => :post } do |projects|
      projects.resources :document_sources, :member => { :upload => :post, :import => :post }, :as => 'sources'
      projects.resources :documents
      projects.resources :managers
      projects.resources :review_stages, :as => 'stages', :member => { :report => :get } do |stages|
        stages.resources :reasons
        stages.resources :stage_reviewers, :as => 'reviewers' do |reviewers|
		  reviewers.resources :document_reviews, :as => 'reviews', :member => { :new_reason => :get, :add_reason => :put }
		end
      end
    end
  end
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

	map.login  'login',  :controller => 'session', :action => 'new'
	map.logout 'logout', :controller => 'session', :action => 'destroy'
	map.switch_project 'session/switch_project/:id', :controller => 'session', :action => 'switch_project'
	map.connect 'force/:id', :controller => 'session', :action => 'force', :requirements => { :method => :get }
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome", :action => 'index'
  map.open_id_complete 'session', :controller => 'session', :action => 'create', :requirements => { :method => :get }
  map.resource :session

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  # shortcuts via human-friendly nickcnames


  # map.connect ':fn_user', :controller => 'users', :action => 'show', :user => /[a-zA-Z][a-zA-Z-_]*/, :conditions => { :method => :get }
  # map.connect ':fn_user/:fn_project', :controller => 'projects', :action => 'show', :user => /[a-zA-Z][-_0-9a-zA-Z]*/, :project => /[a-zA-Z][-_0-9a-zA-Z]*/, :conditions => { :method => :get }
end
