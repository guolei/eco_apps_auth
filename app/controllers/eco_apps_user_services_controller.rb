class EcoAppsUserServicesController < ActionController::Base
  ignore_login 
  
  def verify
    if params[:token] == session[:verify_token] and params[:encrypt] == EcoApps::Util.encrypt(params[:uid], EcoApps::Const.security_token)
      set_current_user(params[:uid].to_i)
      session[:verify_token] = EcoApps::Util.random_salt(10)
      redirect_to URI.unescape(params[:target])
    else
      render :text => t(:illegal_request)
    end
  end
end


