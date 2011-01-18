class RightService < ActiveResource::Base
  self.site = EcoApps.master_app_url

  class << self
    def reset_rights
      self.post(:reset_rights, :app => EcoApps.current.name, :controllers => controllers)
    end

    def controllers
      Rails.application.routes.named_routes.map{|t| t.last.requirements[:controller]}.uniq - ["rails/info", "eco_apps_user_services"]
    end
  end
end
