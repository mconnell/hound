require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  it "should generate a valid model from the Factory" do
    Factory.build(:account).should be_valid
  end

  describe "validations" do
    describe "subdomain attribute" do
      it "should be present for all accounts" do
        Factory.build(:account, :subdomain => nil).should_not be_valid
      end

      it "should be valid for a subdomain 'foo'" do
        Factory.build(:account, :subdomain => 'foo').should be_valid
      end

      it "should not be valid for a subdomain that begins or ends with a hyphen" do
        Factory.build(:account, :subdomain => '-a1-').should_not be_valid
        Factory.build(:account, :subdomain => '-dot').should_not be_valid
        Factory.build(:account, :subdomain => 'dot-').should_not be_valid
      end

      it "should be valid for a subdomain 'xe'" do
        Factory.build(:account, :subdomain => 'xe').should be_valid
      end

      it "should not be valid for a subdomain 'a-'" do
        Factory.build(:account, :subdomain => 'a-').should_not be_valid
      end

      it "should not be valid for a subdomain with a single character ('a', '1', '-')" do
        Factory.build(:account, :subdomain => 'a').should_not be_valid
        Factory.build(:account, :subdomain => '1').should_not be_valid
        Factory.build(:account, :subdomain => '-').should_not be_valid
      end
    end
  end
end
