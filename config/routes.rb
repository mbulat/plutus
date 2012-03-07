Plutus::Engine.routes.draw do
  root :to => "accounts#index"

  resources :accounts
  resources :transactions
end
