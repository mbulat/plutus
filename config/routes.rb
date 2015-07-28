Plutus::Engine.routes.draw do
  root :to => 'reports#balance_sheet'

  get 'reports/balance_sheet' => 'reports#balance_sheet'

  resources :accounts, only: [:index]
  resources :entries, only: [:index]
end
