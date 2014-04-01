Plutus::Engine.routes.draw do
  root :to => "accounts#index"

  resources :accounts
  resources :entries
end
