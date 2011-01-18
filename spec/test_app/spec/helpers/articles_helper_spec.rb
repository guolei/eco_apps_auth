require 'spec_helper'

describe ArticlesHelper do
  describe "ViewsHelper" do
    describe "limit_access_to" do
      it "should return blank if current_user is blank" do
        helper.stub!(:current_user).and_return(nil)
        helper.limit_access_to(:admin, :teacher).should be_blank
      end
      
      it "should limit access to certain roles" do
        helper.stub!(:current_user_id).and_return(1)
        helper.stub!(:current_user_roles).and_return([[1, "admin"], [2, "teacher"]])
        helper.limit_access_to(:admin){"content"}.should == "content"
        helper.limit_access_to(2){"content"}.should == "content"
        helper.limit_access_to(:admin, :teacher){"content"}.should == "content"
        helper.limit_access_to(:root){"content"}.should == nil
      end
    end
  end
end
