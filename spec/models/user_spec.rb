require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it "should generate a valid model from the Factory" do
    Factory.build(:user).should be_valid
  end
end
