Factory.define :account do |account|
  account.sequence(:subdomain) { |n| "sub#{n}" }
end
