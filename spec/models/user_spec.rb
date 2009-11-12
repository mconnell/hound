require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it "should generate a valid model from the Factory" do
    Factory.build(:user).should be_valid
  end

  describe "validations" do
    it "should only be valid if associated to an account" do
      user = Factory.build(:user, :account => nil)
      user.should_not be_valid
      user.should have(1).error_on(:account)
    end
  end
end
