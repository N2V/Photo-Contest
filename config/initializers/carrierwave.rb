CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => APP_CONFIG[:s3_access_key_id],
    :aws_secret_access_key  => APP_CONFIG[:s3_secret_access_key],
    :region                 => 'eu-west-1'  
  }
  config.fog_directory  = APP_CONFIG[:s3_bucket]
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end