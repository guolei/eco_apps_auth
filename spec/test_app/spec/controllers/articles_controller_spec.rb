require 'spec_helper'

describe ArticlesController do

  before do
    @profile = Factory(:profile, :login => "user")
  end

  describe "login_required" do

    before do
      ArticlesController.before_filter :login_required
      
    end

    it "should be redirect to login page" do
      get :index
      response.should be_redirect
    end

    it "should respond sucess when current_user is not blank" do
      user = Factory(:profile)
      request.session[:current_user_id] = user.id
      get :index
      response.should be_success
    end
  end

  describe "check_access_right" do
    it "should be access forbidden" do
      request.session[:current_user_id] = 1
      request.session[:current_user_roles] = YAML.dump([[1,"admin"]])
      Factory(:role_right, :role_id => 1, :right_id => 2, :path => "test_app/articles")
      controller.send(:has_page_right?, "articles").should be_true
      controller.send(:has_page_right?, "admin/articles").should be_false
    end
  end

  describe "login_path" do
    before do
      EcoApps::Util.stub!(:random_salt).and_return("fd7347a53d09c75d299a")
    end
    
    it "should be just locale and target for normal request" do
      controller.send(:login_path).should == "/user/login?locale=en&target=http%253A%252F%252Ftest.host"
    end
    
    it "should include verify and token in development mode" do
      Rails.env.stub!(:development?).and_return(true)
      controller.send(:login_path).should == "/user/login?locale=en&target=http%253A%252F%252Ftest.host&token=fd7347a53d09c75d299a&verify_url=http%253A%252F%252Ftest.host%252Fverify_user"
    end
    
    it "should include verify and token if share session is false" do
      EcoApps.current.stub!(:share_session).and_return(false)
      controller.send(:login_path).should == "/user/login?locale=en&target=http%253A%252F%252Ftest.host&token=fd7347a53d09c75d299a&verify_url=http%253A%252F%252Ftest.host%252Fverify_user"
    end
  end
  
  describe "current_usesr" do
    it "should find object of user_class" do     
      request.session[:current_user_id] = @profile.id
      controller.current_user.user_method.should be_true     
    end 
  end
  
  describe "set_current_user" do
    it "should set current_user_id and current_user_roles" do
      role = Factory(:role, :name=>"admin")
      @profile.stub!(:roles).and_return([role])
      EcoApps::Profile.stub!(:find_by_id).and_return(@profile)
      controller.send(:set_current_user, @profile.id)
      controller.current_user.login.should == "user"
      controller.current_user_roles.should == [[role.id, "admin"]]
    end
  end
end
