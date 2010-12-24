require 'spec_helper'

describe ArticlesController do

  describe "login_required" do

    before do
      ArticlesController.before_filter :login_required
    end

    it "should be redirect to login page" do
      get :index
      response.should be_redirect
    end

    it "should respond sucess when current_user is not blank" do
      user = User.create
      request.session[:current_user_id] = user.id
      get :index
      response.should be_success
    end
  end

  describe "check_access_right" do
    it "should be access forbidden" do
      request.session[:current_user_id] = 1
      request.session[:current_user_roles] = YAML.dump([1,"admin"])
      Factory(:eco_apps_role_right, :role_id => 1, :right_id => 2, :path => "test_app/articles")
      controller.send(:has_page_right?, "articles").should be_true
      controller.send(:has_page_right?, "admin/articles").should be_false
    end
  end

  describe "login_path" do
    it "should be login_path if login_path is set" do
      controller.send(:login_path).should == "/user/login?locale=en&target=http%253A%252F%252Ftest.host"
    end
  end
end
