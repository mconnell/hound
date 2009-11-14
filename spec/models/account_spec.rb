require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  it "should generate a valid model from the Factory" do
    Factory.build(:account).should be_valid
  end

  describe "validations" do
    describe "subdomain attribute" do
      it "should be present for all accounts" do
        account = Factory.build(:account, :subdomain => nil)
        account.should_not be_valid
        account.should have_at_least(1).errors_on(:subdomain)
      end

      it "should be valid for a subdomain 'foo'" do
        Factory.build(:account, :subdomain => 'foo').should be_valid
      end

      it "should not be valid for a subdomain that begins or ends with a hyphen" do
        account_one = Factory.build(:account, :subdomain => '-a1-')
        account_one.should_not be_valid
        account_one.should have_at_least(1).errors_on(:subdomain)

        account_two = Factory.build(:account, :subdomain => '-dot')
        account_two.should_not be_valid
        account_two.should have_at_least(1).errors_on(:subdomain)

        account_three = Factory.build(:account, :subdomain => 'dot-')
        account_three.should_not be_valid
        account_three.should have_at_least(1).errors_on(:subdomain)
      end

      it "should be valid for a subdomain 'xe'" do
        Factory.build(:account, :subdomain => 'xe').should be_valid
      end

      it "should not be valid for a subdomain 'a-'" do
        account = Factory.build(:account, :subdomain => 'a-')
        account.should_not be_valid
        account.should have_at_least(1).errors_on(:subdomain)
      end

      it "should not be valid for a subdomain with a single character ('a', '1', '-')" do
        account_one = Factory.build(:account, :subdomain => 'a')
        account_one.should_not be_valid
        account_one.should have_at_least(1).errors_on(:subdomain)

        account_two = Factory.build(:account, :subdomain => '1')
        account_two.should_not be_valid
        account_two.should have_at_least(1).errors_on(:subdomain)

        account_three = Factory.build(:account, :subdomain => '-')
        account_three.should_not be_valid
        account_three.should have_at_least(1).errors_on(:subdomain)
      end

      it "should validate the uniqueness of subdomains" do
        Factory(:account, :subdomain => 'foobar')
        identical_account = Factory.build(:account, :subdomain => 'foobar')
        identical_account.should_not be_valid
        identical_account.should have_at_least(1).errors_on(:subdomain)
      end

      it "should not allow the subdomain 'www'" do
        account = Factory.build(:account, :subdomain => 'www')
        account.should_not be_valid
        account.should have_at_least(1).errors_on(:subdomain)
      end

      it "should not allow the subdomain 'support'" do
        account = Factory.build(:account, :subdomain => 'support')
        account.should_not be_valid
        account.should have_at_least(1).errors_on(:subdomain)
      end

      it "should not allow the subdomain 'mail'" do
        account = Factory.build(:account, :subdomain => 'mail')
        account.should_not be_valid
        account.should have_at_least(1).errors_on(:subdomain)
      end
    end
  end
end
