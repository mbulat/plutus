Plutus::Engine.routes.draw do
  root :to => "accounts#index"

  get 'reports/balance_sheet' => 'reports#balance_sheet'

  resources :accounts, only: [:show, :index]
  resources :entries, only: [:show, :index]
end
