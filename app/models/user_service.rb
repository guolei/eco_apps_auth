class UserService < ActiveResource::Base
  self.site = EcoApps.master_app_url
  
  def update_profiles(options = {})
    options.each{|key,value| send(key.to_s + "=", value)}
    save
  end

  def update_profile(key, value)
    update_profiles({key => value})
  end

  class << self
    def auth(username, password)
      user = self.get(:auth, :user=> username, :password=>password)
      user["error"].blank? ? self.new(user) : false
    end

    def check(attr, value)
      self.get(:check, :attr => attr, :value => value, :locale => I18n.locale)["info"]
    end

    def search(login_or_mail)
      user = self.get(:find_user, :login_or_mail => login_or_mail)
      user["error"].blank? ? self.new(user) : nil
    end
  end
end