class EcoAppsRight < ActiveRecord::Base
  acts_as_readonly EcoApps.master_app, :table_name => "rights"
end