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

  describe "association extensions" do
    describe "domain_category_extension" do
      describe "@domain.categories.add association method" do
        describe "when adding a category to a domain that it already has" do
          before(:each) do
            @domain = Factory(:domain)
            @category = Factory(:category, :name => 'foo')
            @domain.categories += [@category]
          end

          it "should return ['foo']" do
            @domain.categories.add('foo').should == ['foo']
          end

          it "should still only have one category with that name" do
            @domain.categories.add('foo')
            @domain.categories.size.should == 1
          end
        end

        describe "when adding a category that exists generally" do
          before(:each) do
            @domain = Factory(:domain)
            @domain.categories = []
            @domain.save
            @category = Factory(:category, :name => 'foo')
          end

          it "should return ['foo']" do
            @domain.categories.add('foo').should == ['foo']
          end

          it "should add the 'foo' category to the domain" do
            @domain.categories.add('foo')
            @domain.categories.should include(@category)
          end
        end
        describe "when the category doesn't exist" do
          before(:each) do
            @domain = Factory(:domain)
          end

          it "should create a new category" do
            @domain.categories.size.should == 0
            @domain.categories.add('foobar')
            @domain.categories.size.should == 1
          end

          it "should include the newly created category in the associaiton" do
            @domain.categories.add('foo')
            @domain.categories.last.name.should == 'foo'
          end

          it "should return ['bar']" do
            @domain.categories.add('bar').should == ['bar']
          end
        end

        describe "when the category name contains a slash (category path)" do
          describe "and none of the categories exist" do
            before(:each) do
              @domain = Factory(:domain)
            end

            it "should create the new categories" do
              @domain.categories.add('foo/bar')
              @domain.categories.find_by_name('foo').should be_true
              @domain.categories.find_by_name('bar').should be_true
            end

            it "should create sports as a parent category" do
              @domain.categories.add('sports/tennis')
              @domain.categories.find_by_name('sports').parent.should be_nil
            end

            it "should create ice hockey as a child category of sports" do
              @domain.categories.add('sports/ice hockey')
              @domain.categories.find_by_name('ice hockey').parent.name.should == 'sports'
            end
          end
        end
      end
    end
  end

  describe "public instance methods" do
    describe "to_param" do
      it "should return a domains name" do
        domain = Factory(:domain, :name => 'example.com')
        domain.to_param.should == 'example.com'
      end
    end

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
