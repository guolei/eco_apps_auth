class RightService < ActiveResource::Base
  self.site = EcoApps.master_app_url

  class << self
    def reset_rights
      self.post(:reset_rights, :app => EcoApps.current.name, :controllers => controllers)
    end

    def controllers
      controllers_path(ApplicationController.subclasses) - ["eco_apps_user_services"]
    end
    
    private
    def controllers_path(controllers)
      controllers.map{|c| c.subclasses.blank? ? c.controller_path : controllers_path(c.subclasses)}.flatten
    end
  end
end
