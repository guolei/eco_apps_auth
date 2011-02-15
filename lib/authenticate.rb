module EcoAppsAuth
  module Authenticate #:nodoc:
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include,InstanceMethods)
    end

    module ClassMethods
      def ignore_login(options = {})
        skip_before_filter :login_required, options
        skip_before_filter :check_access_right, options
      end

      def require_login(options = {})
        before_filter :login_required, options
        before_filter :check_access_right, options
      end
    end

    module InstanceMethods
      def self.included(base)
        base.helper_method :current_user, :current_user_id, :current_user_roles
      end

      def current_user
        return @current_user if @current_user.present?
        return nil if current_user_id.blank?
        klass = EcoApps.current.user_class.try(:constantize) || EcoApps::Profile.user_class
        @current_user = klass.find_by_id(current_user_id)
      end

      def current_user_id
        session[:current_user_id]
      end

      def current_user_roles
        return [] if current_user_id.blank? or session[:current_user_roles].blank?
        YAML.load session[:current_user_roles]
      end

      protected
      
      def set_current_user(profile)
        profile = EcoApps::Profile.find_by_id(profile) if profile.instance_of?(Fixnum)
        session[:current_user_id] = profile.id
        session[:current_user_roles] = YAML.dump(profile.roles.map{|t| [t.id, t.name]})
      end

      def login_required
        redirect_to login_path if current_user_id.blank?
      end

      def check_access_right
        unless has_page_right?(params[:controller])
          render :text => "Access Denied", :status => 403
        end
      end

      def login_path
        url = full_path_of(EcoApps.current.login_path || "#{EcoApps.master_app}/signin")
        options = {:locale => I18n.locale, :target => EcoApps::Util.escape(page_after_login)}
        if Rails.env.development? or EcoApps.current.share_session == false
          session[:verify_token] = token = EcoApps::Util.random_salt(10)
          options.merge!({:verify_url => EcoApps::Util.escape(verify_user_url), :token => token})
        end
        URI.parse(url).add_query(options).to_s
      end

      private

      def has_page_right?(controller)
        path = [EcoApps.current.name, controller].join("/")
        roles_of_path = EcoApps::RoleRight.where(["path = ?", path]).select("distinct role_id").map(&:role_id)
        (current_user_roles.map(&:first) & roles_of_path).size > 0
      end

      def page_after_login
        full_path_of(EcoApps.current.callback_after_login) || request.url
      end
    end
  end
end

