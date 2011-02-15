class RightService < ActiveResource::Base
  self.site = EcoApps.master_app_url

  class << self
    def reset_rights
      self.post(:reset_rights, :app => EcoApps.current.name, :controllers => controllers)
    end

    def controllers
      ApplicationController.subclasses.map(&:controller_path) - ["eco_apps_user_services"]
    end
  end
end
