module Extensions
  module MxRecordAssociation

    # returns an array of mx_records [preference, exchange] ordered by
    # the record preference ascending
    def live
      if (proxy_owner.present? && proxy_owner.domain.present? && proxy_owner.domain.ascii_name.present?)
        records = []
        live_mx_records_preference_value.each do |mx_record|
          records << {:preference => mx_record[0], :value => mx_record[1]}
        end
        records
      else
        []
      end
    end

    # update the mx_records in persistant storage
    # FIXME: This is quite dumb at the moment because it isn't changing existing records
    #        but instead nuking the shit out of them and recreating them.
    def refresh
      live_mx_record_ids = []
      live.each do |record|
        mx_record = create(record)
        live_mx_record_ids << mx_record.id
      end
      find(:all, :conditions => ['id NOT IN (?)', live_mx_record_ids]).each do |old_mx_record|
        old_mx_record.delete
      end
      self
    end

    private
    def live_mx_records_preference_value
      packet = Net::DNS::Resolver.start(proxy_owner.domain.ascii_name, Net::DNS::MX)
      records = []
      packet.each_mx do |preference, value|
        records << [preference, value]
      end
      records.sort! {|a,b| [a[0], a[1]] <=> [b[0], b[1]]}
    end

  end

end
