module AuthViewsHelper
  def limit_access_to(*roles, &block)
    with_user do
      user_roles = current_user_roles.flatten
      if (roles.map(&:to_s) & user_roles.map(&:to_s)).size > 0
        block.call    
      end
    end
  end
  
  def base_layout(&block)
    "<!doctype html>".html_safe +
    content_tag(:html, :lang => "en", :class => "no-js") do
      content_tag(:head) do
        %{<meta charset="utf-8">}.html_safe +
        content_tag(:title){t(:html_title)} +
        stylesheetl_link_tag(full_path_of("stylesheets/base"), :assets) +
        stylesheetl_link_tag(full_path_of("stylesheets/style1"), :assets) +
        javascript_include_tag(%{https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js}) +
        javascript_include_tag(full_path_of("javascripts/rails"), :assets) +
        stylesheetl_link_tag(:all)
      end +
      content_tag(:body) do
        content_tag(:div, :id => "headerbg") +
        content_tag(:div, :id => "globalheader", :class => "clear_float") do
          content_tag(:h1, :id => "globallogo"){link_to("Eleutian", "#")} +
          content_tag(:div, :id => "globalnav", :class => "clear_float") do
            content_tag(:div, :class => "leftfloat") +
            content_tag(:div, :class => "rightfloat") do
              top_user_content
            end
          end
        end
        block.call
      end
    end
  end
  
  def top_menu_content
    return "" if Rails.env.test?
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
        <li>#{link_to(t(:logout), url_of(:user,:signout))}</li>
      }
    end
  end
  
  def with_user(&block)
    if respond_to?("current_user_id") and !current_user_id.blank?
      yield
    end
  end
end