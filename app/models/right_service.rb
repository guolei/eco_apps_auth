class RightService < ActiveResource::Base
  self.site = EcoApps.master_app

  class << self
    def reset_rights
      
    end

    def controllers
      Rails.application.routes.named_routes.map{|t| t.last.requirements[:controller]}.uniq - ["rails/info"]
    end
  end
end
