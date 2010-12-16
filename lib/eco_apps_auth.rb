require 'rails'
require 'action_controller'
require 'eco_apps'

require 'authenticate'

module EcoAppsAuth
  class Engine < Rails::Engine

    initializer "init_store_table" do
      ActionController::Base.send(:include, EcoAppsAuth::Authenticate)
    end

  end
end