Factory.define :user do |user|
  user.association :account
  user.sequence(:email) { |n| "foo#{n}@example.com" }
  user.password              'password'
  user.password_confirmation 'password'
end
