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

      protected

      def login_required
        redirect_to login_path if current_user_id.blank?
      end

      def check_access_right
        unless has_page_right?(params[:controller])
          render :status => 403
        end
      end

      def login_path
        full_path_of(EcoApps.current.login_path || "#{EcoApps.master_url}/signin")
      end

      private
      def has_page_right?(controller)
       
      end


    end
  end
end

