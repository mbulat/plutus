module Plutus
  class ApplicationController < ActionController::Base
    unloadable if respond_to?(:unloadable)
  end
end
