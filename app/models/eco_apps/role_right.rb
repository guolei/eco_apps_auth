module EcoApps
  class RoleRight < ActiveRecord::Base
    acts_as_readonly EcoApps.master_app, :table_name => "role_rights"
  end
end