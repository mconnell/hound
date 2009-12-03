module Extensions
  module NameserverAssociation
    # by default a habtm setup doesn't allow us to do @dns.nameservers.dns
    # however this little bit of magic allows us to manually implement it on the
    # association.
    def dns
      proxy_owner
    end

    # returns an array of the nameservers associated with the particular
    # domain name. If no domain name is available it will return an empty
    # array for consistency.
    def live
      if (proxy_owner.present? && proxy_owner.domain.present? && proxy_owner.domain.ascii_name.present?)
        nameservers = []
        live_nameserver_host_names.each do |host_name|
          nameservers << { :host_name => host_name }
        end
        nameservers
      else
        []
      end
    end

    # updates the existing nameservers in persistant storage
    def refresh
      live_ns_ids = []
      live.each do |record|
        nameserver = (Nameserver.find_by_host_name(record[:host_name]) || build(record))
        if nameserver.new_record?
          self << nameserver
        else
          self.include?(nameserver) ? nameserver.touch : (self << nameserver)
        end
        live_ns_ids << nameserver.id
      end
      find(:all, :conditions => ['id NOT IN (?)', live_ns_ids]).each do |old_nameserver|
        self.delete old_nameserver
      end
      self
    end

    private
    def live_nameserver_host_names
      packet = Net::DNS::Resolver.start(proxy_owner.domain.ascii_name, Net::DNS::NS)
      host_names = []
      packet.each_nameserver do |host_name|
        host_names << host_name
      end
      host_names.sort! {|a,b| a <=> b}
    end
  end
end
