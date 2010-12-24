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
        base.helper_method :current_user, :current_user_id
      end

      def current_user
        return @current_user if @current_user.present?
        return nil if current_user_id.blank?
        @current_user = IdpProfile.get_user(current_user_id)
      end

      def current_user_id
        session[:current_user_id]
      end

      def current_user_roles
        return [] if current_user_id.blank? or session[:current_user_roles].blank?
        YAML.load session[:current_user_roles]
      end

      protected

      def login_required
        redirect_to login_path if current_user_id.blank?
      end

      def check_access_right
        unless has_page_right?(params[:controller])
          render :text => "Access Denied", :status => 304
        end
      end

      def login_path
        url = full_path_of(EcoApps.current.login_path || "#{EcoApps.master_url}/signin")
        options = {:locale => I18n.locale, :target => EcoApps::Util.escape(page_after_login)}
        options[:verify] = true if EcoApps.current.verify
        URI.parse(url).add_query(options).to_s
      end

      private

      def has_page_right?(controller)
        path = [EcoApps.current.name, controller].join("/")
        roles_of_path = EcoAppsRoleRight.where(["path = ?", path]).select("distinct role_id").map(&:role_id)
        (current_user_roles.map(&:first) & roles_of_path).size > 0
      end

      def page_after_login
        full_path_of(EcoApps.current.callback_after_login) || request.url
      end
    end
  end
end

