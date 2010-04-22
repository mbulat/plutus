ActionController::Routing::Routes.draw do |map|
  map.resources :transactions, :only => [:index, :show]
  map.resources :accounts, :only => [:index, :show]
end
