Rails.application.config.s3 = {
  region: ENV['AWS_REGION'],
  access_key_id: ENV['AWS_ACCESS_KEY'],
  secret_access_key: ENV['AWS_SECRET_KEY'],
  endpoint: ENV['S3_ENDPOINT'],
  force_path_style: true,
}
