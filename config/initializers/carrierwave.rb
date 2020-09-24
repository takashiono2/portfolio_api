require 'carrierwave/storage/abstract'
require 'carrierwave/storage/file'
require 'carrierwave/storage/fog'

# 日本語のファイル名が「__」に置き換わるのを防止
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/

CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_provider = 'fog/aws'# 追加
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    region: ENV["AWS_REGION"]
  }
  # 公開・非公開の切り替え#公開ならtrue
  config.fog_public = true
  # キャッシュの保存期間
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
  config.fog_directory  = 'dojoportfolio'
  config.cache_storage = :fog
  config.asset_host = "https://dojoportfolio.s3-us-west-2.amazonaws.com"
  #config.asset_host = 'https://dojoportfolio.s3.amazonaws.com
  #https://dojoportfolio.s3-us-west-2.amazonaws.com/
  #config.enable_processing = false if (File.extname(filename) == '.pdf')
end

