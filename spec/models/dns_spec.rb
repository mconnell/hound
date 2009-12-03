require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Dns do
  describe ":dns Factory" do
    it "should successfully create a new instance from the factory" do
      lambda { Factory(:dns) }.should_not raise_error
    end

    it "should persist the new instance in the database" do
      lambda { Factory(:dns) }.should change(Dns, :count).by(1)
    end
  end

  describe "validations" do
    it "should require a domain" do
      dns = Factory.build(:dns, :domain => nil)
      dns.should_not be_valid
      dns.should have(1).error_on(:domain)
    end
  end
end
