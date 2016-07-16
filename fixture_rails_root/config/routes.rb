Rails.application.routes.draw do
  mount Plutus::Engine => "/plutus", as: "plutus"
end
