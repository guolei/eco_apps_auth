module AuthViewsHelper
  def limit_access_to(*roles, &block)
    with_user do
      user_roles = current_user_roles.flatten
      if (roles.map(&:to_s) & user_roles.map(&:to_s)).size > 0
        block.call    
      end
    end
  end
  
  def common_layout
  end
  
  def top_menu_content
    return "" if Rails.env == "test"
    with_user do
      key = IdpLinkGroup.navlinks_cache_key_for(current_user)
      c = read_fragment(key)
      return c unless c.blank?
      c = SettingService.find(current_user_id, :params=>{:locale => I18n.locale}).links
      write_fragment(key, c)
      c
    end
  end

  def top_user_content
    with_user do
      %{
        <li><b>#{current_user.login}</b></li>
        <li>#{link_to(t(:start_page), url_of(:user, :portal))}</li>
        <li>#{link_to(t(:my_settings), url_of(:user, :setting))}</li>
        <li>#{link_to(t(:logout), logout_path)}</li>
      }
    end
  end
  
  def with_user(&block)
    if respond_to?("current_user_id") and !current_user_id.blank?
      yield
    end
  end
end