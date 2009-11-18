require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Domain do
  describe ":domain Factory" do
    it "should successfully create a new instance from the factory" do
      lambda { Factory(:domain) }.should_not raise_error
    end

    it "should persist the new instance in the database" do
      lambda { Factory(:domain) }.should change(Domain, :count).by(1)
    end
  end

  describe "validations" do
    describe "of the name attribute" do
      it "should validate the presence of a name" do
        Factory.build(:domain, :name => nil).should_not be_valid
      end

      it "should validate that the domain name is unique for this account" do
        Factory(:domain, :name => 'foo.com').should be_valid
        Factory.build(:domain, :name => 'foo.com').should_not be_valid
      end

      it "should be between 4 and 255 characters in length" do
        Factory.build(:domain, :name => '1.x').should_not be_valid
        Factory.build(:domain, :name => '1.xy').should be_valid

        Factory.build(:domain, :name => "#{'x'*63}.#{'x'*63}.#{'x'*63}.#{'x'*60}.yz").should be_valid
        Factory.build(:domain, :name => "#{'x'*63}.#{'x'*63}.#{'x'*63}.#{'x'*60}.yza").should_not be_valid
      end

      it "should not have any portion of the domain greater than 63 characters" do
        Factory.build(:domain, :name => "#{'x'*63}.com").should be_valid
        Factory.build(:domain, :name => "#{'x'*64}.com").should_not be_valid
      end
    end
  end

  describe "public instance methods" do
    describe "idn?" do
      it "should return true when the domain is an international domain name" do
        domain = Factory.build(:domain, :name => 'öl.pl')
        domain.send(:generate_ascii_name)
        domain.idn?.should == true
      end

      it "should return false when the domain is a regular joe bloggs domain" do
        domain = Factory(:domain, :name => 'domainsapp.com')
        domain.send(:generate_ascii_name)
        domain.idn?.should == false
      end
    end
  end

  describe "private instance methods" do
    describe "generate_ascii_name" do
      it "should handle a common domain name" do
        domain = Domain.new(:name => 'foobar.com')
        domain.send(:generate_ascii_name)
        domain.ascii_name.should == "foobar.com"
      end

      it "should handle a domain with sub domains and hyphens" do
        domain = Domain.new(:name => 'sub.domained-with-hyphens-in-it.com')
        domain.send(:generate_ascii_name)
        domain.ascii_name.should == "sub.domained-with-hyphens-in-it.com"
      end

      it "should handle international domain names" do
        domain = Domain.new(:name => 'öl.pl')
        domain.send(:generate_ascii_name)
        domain.ascii_name.should == "xn--l-0ga.pl"
      end
    end
  end

end
