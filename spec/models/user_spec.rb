require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  it "should generate a valid model from the Factory" do
    Factory.build(:user).should be_valid
  end

  describe "#update_password" do
    before(:each) do
      Account.current = Factory(:account)
    end

    it "should check the record is valid to raise any unexpected errors" do
      user = Factory(:user, :password => 'original', :password_confirmation => 'original')
      user.should_receive(:valid?).twice
      user.update_password('foo', 'foo')
    end

    it "should set the record to be invalid if password is blank" do
      user = Factory(:user, :password => 'original', :password_confirmation => 'original')
      user.errors.should_receive(:add).with(:password, "must not be blank")
      user.update_password(nil, 'foobar')
    end

    it "should set the record to be invalid if password_confirmation is blank" do
      user = Factory(:user, :password => 'original', :password_confirmation => 'original')
      user.errors.should_receive(:add).with(:password_confirmation, "must not be blank")
      user.errors.should_receive(:add).with(:password_confirmation, :too_short, {:count=>4, :default=>nil})
      user.update_password('foobar', nil)
    end
  end

end
