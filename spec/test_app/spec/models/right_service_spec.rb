require 'spec_helper'

describe RightService do

  describe "controllers" do

    it "should return all controllers" do
      (RightService.controllers - ["articles", "admin/articles", "eco_apps_user_services"]).should be_blank
    end

  end

end
