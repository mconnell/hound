require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Category do
  it "should build a valid category from the :category Factory" do
    Factory.build(:category).should be_valid
  end
end
