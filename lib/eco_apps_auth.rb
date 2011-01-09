require 'rails'
require 'action_controller'
require 'eco_apps'

require 'authenticate'

module EcoAppsAuth
  class Engine < Rails::Engine

    initializer "include_hacks" do
      ActionController::Base.send(:include, EcoAppsAuth::Authenticate)
      ActionView::Base.send(:include, AuthViewsHelper)
    end

  end
end