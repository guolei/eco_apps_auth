require 'spec_helper'

describe EcoApps::Profile do
  before do 
    @profile = Factory(:profile, :login => "test")
  end
  
  describe "EcoAppsProfile" do
    it "should read data from profiles" do
      EcoApps::Profile.find_by_login("test").should_not be_blank
    end
    
    it "should delegate methods to profile_by_service" do
      class MockUserService       
        def roles
          "roles"
        end
        
        def update_profiles(attrs)
          true
        end
        
        def update_profile(key, value)
          false
        end
      end
      
      UserService.stub!(:find).and_return(MockUserService.new)
      
      @profile.roles.should == "roles"
      @profile.update_profiles(:login=>"test").should be_true
      @profile.update_profile(:login, "test").should be_false
    end
    
    it "should recognize user_class" do
      EcoApps::Profile.user_class.should == User
    end
  end
end
