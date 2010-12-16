#Reset application's right nodes
RightService.reset_rights

ActionController::Base.before_filter :login_required
ActionController::Base.before_filter :check_access_right