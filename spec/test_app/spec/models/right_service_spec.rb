require 'spec_helper'

describe RightService do

  describe "controllers" do

    it "should return all controllers" do
      ApplicationController.stub!(:subclasses).and_return([ArticlesController, Admin::ArticlesController])
      RightService.controllers.sort.should == ["articles", "admin/articles"].sort
    end

  end

end
