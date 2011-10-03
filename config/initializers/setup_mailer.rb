if Rails.env.production?
  ActionMailer::Base.smtp_settings = {
    :address => APP_CONFIG[:smtp_address],
    :port => APP_CONFIG[:smtp_port],
    :domain => APP_CONFIG[:smtp_domain],
    :authentication => APP_CONFIG[:smtp_authentication],
    :user_name => APP_CONFIG[:smtp_username],
    :password => APP_CONFIG[:smtp_password],
    :enable_starttls_auto => APP_CONFIG[:smtp_tls]
  }
end