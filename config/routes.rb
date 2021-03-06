ActionController::Routing::Routes.draw do |map|
  
  map.forgot_password 'forgotpassword', :controller => "welcome", :action => "forgot_password"
  map.reset_password  'reset/:token', :controller => "welcome", :action => "reset_password"
  
  map.configure 'configure', :controller => "employees", :action => "configure"
  map.cheatsheet 'cheatsheet', :controller => "employees", :action => "cheatsheet"
  
  map.extension_manager 'extension_manager', :controller => "groups", :action => "extension_manager"
  map.group_editor 'group_editor', :controller => "groups", :action => "editor"
  map.logout 'logout', :controller => "welcome", :action => "logout"
  map.call 'employees/call/:source/:destination', :controller => "employees", :action => "call"
  map.calls 'calls', :controller => "calls", :action => "index"
  map.voicemails 'voicemails', :controller => "voicemails", :action =>  "index"
  
  map.resources :groups

  map.resources :employees

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

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
