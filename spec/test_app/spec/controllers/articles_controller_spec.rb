require 'spec_helper'

describe ArticlesController do

  describe "development mode" do

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

end
