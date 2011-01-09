module AuthViewsHelper
  def limit_access_to(*roles, &block)
    return "" if current_user.blank?
    user_roles = current_user_roles.map(&:last)
    if (roles.map(&:to_s) & user_roles.map(&:to_s)).size > 0
      block.call    
    end
  end
end