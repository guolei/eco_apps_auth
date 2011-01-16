[:right, :role].each do |obj|
  Factory.define obj do |t|
  end
end

Factory.define :profile, :class=> "EcoApps::Profile" do |obj|
end

Factory.define :role_right, :class=> "EcoApps::RoleRight" do |obj|
end