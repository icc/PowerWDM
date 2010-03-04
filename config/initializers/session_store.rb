# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_powerdms_session',
  :secret      => 'ebf2cf2ea8a4a3b836999e73629a9bf46ae069637cb6f34ca274e645fcfaece1ac37445fdbf17cc5a7b1f5d6301187a513d2764bb62f37414ce2894aef116b8b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
