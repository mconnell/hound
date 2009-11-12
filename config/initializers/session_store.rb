# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hound_session',
  :secret      => 'fc0d7479c214d04722e6292bd0aae7cf4752da2b076582558867fd2d23a8b020ef83f18bc384460b7b9d64c71e5142c373fba70b744d99fea0b4f0512759a896'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
