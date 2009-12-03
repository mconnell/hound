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
      dns = Factory.build(:dns, :domain_id => nil)
      dns.should_not be_valid
      dns.should have(1).error_on(:domain_id)
    end
  end

  describe "association extensions" do
    describe "reverse traversal" do
      it "should allow reverse traversal of @dns.nameservers.dns" do
        @dns = Factory(:dns)
        @dns.nameservers.dns.should == @dns
      end
    end

    describe "for fetching live nameserver records" do
      def setup_dns_packet
         packet = Net::DNS::Packet.new("houndapp.com", Net::DNS::NS)
         packet.answer = [
           Net::DNS::RR.new("www.houndapp.com.  86400  IN  NS  foo.ns.houndapp.com."),
           Net::DNS::RR.new("www.houndapp.com.  86400  IN  NS  bar.ns.houndapp.com."),
           Net::DNS::RR.new("www.houndapp.com.  86400  IN  NS  baz.ns.houndapp.com.")
         ]
         packet
       end

       before(:each) do
         Net::DNS::Resolver.stub!(:start).and_return(setup_dns_packet)
         @domain = Factory(:domain, :name => 'houndapp.com')
       end

       it "should return the nameserver_records for a domain ordered by name" do
         @domain.dns.nameservers.live.should == [
           { :host => "bar.ns.houndapp.com."},
           { :host => "baz.ns.houndapp.com."},
           { :host => "foo.ns.houndapp.com."}
         ]
       end
    end

    describe "for refreshing the nameserver records in persistant storage" do
      def setup_dns_packet
         packet = Net::DNS::Packet.new("houndapp.com", Net::DNS::NS)
         packet.answer = [
           Net::DNS::RR.new("www.houndapp.com.  86400  IN  NS  foo.ns.houndapp.com."),
           Net::DNS::RR.new("www.houndapp.com.  86400  IN  NS  bar.ns.houndapp.com."),
           Net::DNS::RR.new("www.houndapp.com.  86400  IN  NS  baz.ns.houndapp.com.")
         ]
         packet
       end

       before(:each) do
         Net::DNS::Resolver.stub!(:start).and_return(setup_dns_packet)
         @domain = Factory(:domain, :name => 'houndapp.com')
         @nameserver_eep = Nameserver.find_or_create_by_host('eep.ns.houndapp.com.')
         @nameserver_foo = Nameserver.find_or_create_by_host('foo.ns.houndapp.com.')
         @nameserver_bar = Nameserver.find_or_create_by_host('bar.ns.houndapp.com.')
         @nameserver_baz = Nameserver.find_or_create_by_host('baz.ns.houndapp.com.')
         @domain.dns.nameservers << [@nameserver_eep, @nameserver_foo, @nameserver_bar, @nameserver_baz]
       end

       it "should return the nameserver_records for a domain ordered by name" do
         @domain.dns.nameservers.refresh.should == [
           @nameserver_foo,
           @nameserver_bar,
           @nameserver_baz
         ]
       end

       it "should have the live servers in persistant storage" do
         @domain.dns.nameservers.refresh
         nameservers = @domain.dns.nameservers
         nameservers.should include(@nameserver_foo)
         nameservers.should include(@nameserver_bar)
         nameservers.should include(@nameserver_baz)
       end

       it "should have no record of the existing nameserver record 'eep.ns.houndapp.com'" do
         @domain.dns.nameservers.refresh
         @domain.dns.nameservers.should_not include(@nameserver_eep)
       end

       describe "when there is no domain" do
         it "should return an empty array" do
           Factory(:dns).nameservers.live.should == []
         end
       end
    end

    describe "for fetching live a_records" do
      def setup_dns_packet
        packet = Net::DNS::Packet.new("houndapp.com")
        packet.answer = [
          Net::DNS::RR.new("houndapp.com. 500 IN A 12.34.56.78"),
          Net::DNS::RR.new("houndapp.com. 500 IN A 13.34.56.78"),
          Net::DNS::RR.new("houndapp.com. 500 IN A 90.34.56.78")
        ]
        packet
      end

      before(:each) do
        Net::DNS::Resolver.stub!(:start).and_return(setup_dns_packet)
      end

      it "should return the mx_records for a domain ordered by preference" do
        Factory(:domain, :name => 'houndapp.com').dns.a_records.live.should == [
          {:host => "houndapp.com.", :value => "12.34.56.78"},
          {:host => "houndapp.com.", :value => "13.34.56.78"},
          {:host => "houndapp.com.", :value => "90.34.56.78"}
        ]
      end

      describe "when there is no domain" do
        it "should return an empty array" do
          Factory(:dns).a_records.live.should == []
        end
      end
    end

    describe "for fetching live mx_records" do
      def setup_dns_packet
        packet = Net::DNS::Packet.new("houndapp.com", Net::DNS::MX)
        packet.answer = [
          Net::DNS::RR.new("houndapp.com. 2825 IN MX 20 mx2.server."),
          Net::DNS::RR.new("houndapp.com. 2825 IN MX 10 mx1.server."),
          Net::DNS::RR.new("houndapp.com. 2825 IN MX 30 mx3.server.")
        ]
        packet
      end

      before(:each) do
        Net::DNS::Resolver.stub!(:start).and_return(setup_dns_packet)
      end

      it "should return the mx_records for a domain ordered by preference" do
        Factory(:domain, :name => 'houndapp.com').dns.mx_records.live.should == [
          {:preference=>10, :value=>"mx1.server."},
          {:preference=>20, :value=>"mx2.server."},
          {:preference=>30, :value=>"mx3.server."}
        ]
      end

      describe "when there is no domain" do
        it "should return an empty array" do
          Factory(:dns).mx_records.live.should == []
        end
      end
    end
  end

  describe "refresh" do
    before(:each) do
      allow_message_expectations_on_nil

      @dns = Factory(:dns)
      @dns.stub!(:nameservers)
      @dns.nameservers.stub!(:refresh)
      @dns.a_records.stub!(:refresh)
      @dns.mx_records.stub!(:refresh)
    end

    it "should call namerservers.refresh" do
      @dns.nameservers.should_receive(:refresh)
      @dns.refresh
    end

    it "should call a_records.refresh" do
      @dns.a_records.should_receive(:refresh)
      @dns.refresh
    end

    it "should call mx_records.refresh" do
      @dns.mx_records.should_receive(:refresh)
      @dns.refresh
    end
  end
end
