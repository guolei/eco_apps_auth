require 'rails'
require 'action_controller'
require 'eco_apps'

require 'authenticate'
require 'const'

module EcoAppsAuth
  class Engine < Rails::Engine

    initializer "include_hacks" do
      ActionController::Base.send(:include, EcoAppsAuth::Authenticate)
      ActionView::Base.send(:include, ::AuthViewsHelper)
    end
    
    initializer "reset_rights", :after=> :disable_dependency_loading do
      RightService.reset_rights if Rails.env.production?
    end
    
    config.after_initialize do  
      if Rails.env.production?
        ActionController::Base.before_filter :login_required
        ActionController::Base.before_filter :check_access_right
      elsif Rails.env.development?
        ActionController::Base.before_filter :login_required
      end
    end
  
  end
end