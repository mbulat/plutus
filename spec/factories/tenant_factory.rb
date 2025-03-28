module Plutus
  class Tenant < ActiveRecord::Base
  end
end

FactoryBot.define do
  factory :tenant, :class => Plutus::Tenant do
    sequence :name do |n|
      "Tenant #{n}"
    end
  end
end
