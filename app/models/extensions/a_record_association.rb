module Extensions
  # This is an ActiveRecord association extension specifically for the Dns model to
  # assist with the management of A Records.
  module ARecordAssociation
    # return collection of A records
    def live
      if (proxy_owner.present? && proxy_owner.domain.present? && proxy_owner.domain.ascii_name.present?)
        a_records = []
        live_a_records_host_value.each do |record|
          record = record.to_a
          a_records << {:host => record[0], :value => record[-1]}
        end
        a_records
      else
        []
      end
    end

    # update the a_records in persistant storage
    # FIXME: This is quite dumb at the moment because it isn't changing existing records
    #        but instead nuking the shit out of them and recreating them.
    def refresh
      live_a_record_ids = []
      live.each do |record|
        a_record = create(record)
        live_a_record_ids << a_record.id
      end
      find(:all, :conditions => ['id NOT IN (?)', live_a_record_ids]).each do |old_a_record|
        old_a_record.delete
      end
      self
    end

    private
    def live_a_records_host_value
      packet = Net::DNS::Resolver.start(proxy_owner.domain.ascii_name)
      records = []
      packet.answer.each do |record|
        record = record.to_a
        records << [record[0], record[-1]]
      end
      records
    end
  end
end
