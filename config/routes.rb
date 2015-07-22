Plutus::Engine.routes.draw do
  root :to => "accounts#index"

  resources :accounts, only: [:show, :index]
  resources :entries, only: [:show, :index]
end
