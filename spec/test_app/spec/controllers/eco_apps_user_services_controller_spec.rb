require 'spec_helper'

describe EcoAppsUserServicesController do
  describe "verify" do
    before do
      controller.session[:verify_token] = "27ca21c876c4601a207c"
    end
    
    it "should redirect to target for legal request" do
      controller.stub!(:set_current_user).and_return(true)
      get :verify, :token => "27ca21c876c4601a207c", :target => "/articles", :uid => 10, :encrypt=> "c12424733daf37ec18a6e1bfeb5fb18034c48977"
      response.should redirect_to("/articles")
    end
    
    it "should render warning text for illegal request" do
      get :verify, :token => "27ca21c876c3211a207c", :target => "/articles", :uid => 10, :encrypt=> "c12424733daf37ec18a6e1bfeb5fb18034c48977"
      response.body.should == "translation missing: en.illegal_request"
    end
    
    it "should render warning text for illegal request" do
      get :verify, :token => "27ca21c876c4601a207c", :target => "/articles", :uid => 9, :encrypt=> "c12424733daf37ec18a6e1bfeb5fb18034c48977"
      response.body.should == "translation missing: en.illegal_request"
    end
  end
end