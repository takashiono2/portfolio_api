source 'https://rubygems.org'
ruby '2.6.3'

gem 'rails',        '~> 5.1.6'
gem 'rails-i18n'
gem 'bcrypt'
gem 'faker'
gem 'bootstrap-sass'
gem 'puma',         '~> 4.3'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder',     '~> 2.5'
gem 'font-awesome-sass', '~> 5.4.1'
gem 'rounding'
gem 'webdrivers'
gem 'chart-js-rails', '~> 0.1.4'
gem 'carrierwave'
gem 'mini_magick' #画像に対して処理を行う場合
gem 'line-bot-api'
gem 'dotenv-rails'
gem 'jwt'

group :development, :test do
  gem 'sqlite3','~> 1.3', ' < 1.4.0'#, group: [:development, :test]
  #sqlite1.4がreleaseされたが, rails的には1.3.xにしか対応していない。指定がないと1.4がbundle installされエラーとなる
  #gem 'sqlite3'#, groups: %w(test development), require: false
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'dotenv-rails'
end

group :production do
  gem 'pg', '~> 0.18.4', group: :production
  #バージョン指定しないと最新pgがアップデートされheroku対応しなくなる。自分のものは、ver0.12.3
  gem 'rails_12factor'
end

# Windows環境ではtzinfo-dataというgemを含める必要があります
# Mac環境でもこのままでOKです
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'roo'#csv用ファイルがいろいろひらける
gem 'pry-rails'
gem 'fog-aws'
gem 'aws-sdk'