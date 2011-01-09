class EcoAppsProfile < ActiveRecord::Base
  acts_as_readonly EcoApps.master_app, :table_name => "profiles"
  
  %w{roles update_profiles update_profile}.each do |column|
    delegate column, :to => :profile_by_service, :allow_nil => true
  end

  def profile_by_service
    @profile_by_service ||= UserService.find(self.id)
  end
  
  cattr_accessor :user_class
  class << self
    def inherited(base)
      self.user_class = base
      super
    end
    
    def user_class
      @@user_class || self
    end
  end
end