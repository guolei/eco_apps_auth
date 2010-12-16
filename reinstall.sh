#/bin/bash 

env="development"
if [ $# -gt 0 ]; then
	env=$1
fi

sudo gem uninstall eco_apps_auth -I
gem build eco_apps_auth.gemspec
sudo gem install --no-rdoc --no-ri eco_apps_auth-0.2.0.gem
