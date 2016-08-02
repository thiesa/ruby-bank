source 'https://rubygems.org'
ruby '2.3.1'

gem 'rails',        '~> 5.0.0'
gem 'pg',           '~> 0.18.4'
gem 'puma',         '~> 3.6'
gem 'sass-rails',   '~> 5.0', '>= 5.0.6'
gem 'uglifier',     '~> 3.0', '>= 3.0.1'
gem 'coffee-rails', '~> 4.2', '>= 4.2.1'
gem 'jquery-rails', '~> 4.1', '>= 4.1.1'
gem 'jbuilder',     '~> 2.6'
gem 'rolify',       '~> 5.1.0'
# rails generate simple_form:install --trace
gem 'simple_form',  '~> 3.2.1'
# gem 'skylight'
# If you want to specify the authentication token as an environment variable,
# you should set the `SKYLIGHT_AUTHENTICATION` variable to:
# https://www.skylight.io/
#   Ce4s8OxA6D2U5EkZ9aVw-j8L66YAFMr5faPXu0pejk4
gem 'bourbon',            '~> 5.0.0.beta.6' #'~> 4.2', '>= 4.2.7'
gem 'bitters',            '~> 1.3', '>= 1.3.2'
gem 'refills',            '~> 0.1.0'
gem 'money-rails',        '~> 1.6', '>= 1.6.2'
gem 'bootstrap-sass',      '~> 3.3', '>= 3.3.7'
gem 'cancancan',          '~> 1.15'
gem 'devise',             '~> 4.2.0'
gem 'font-awesome-rails', '~> 4.6', '>= 4.6.3.1'
gem 'bcrypt',             '~> 3.1', '>= 3.1.11'
gem 'country_select',     github: 'stefanpenner/country_select'

# https://github.com/theodi/multichain-client
# gem 'multichain', '~> 0.1.4'
# gem 'redis', '~> 3.3', '>= 3.3.1'
# gem 'exception_notification', '~> 4.2', '>= 4.2.1'
# gem 'plutus',             '~> 0.12.2' # https://github.com/mbulat/plutus rails g plutus --trace
# gem 'thin', '~> 1.7'
gem 'therubyracer', platforms: :ruby

group :production do
  gem 'rails_12factor', '~> 0.0.3'
end

group :development, :test do
  gem 'faker',              '~> 1.6', '>= 1.6.6'
  gem 'pry-rails',          '~> 0.3.4'
  gem 'binding_of_caller',  '~> 0.7.2'
  gem 'better_errors',      '~> 2.1.1'
  gem 'awesome_print',      require: 'ap'
end

group :test do
  gem 'ephemeral_response',      '~> 0.4.0'
  gem 'database_cleaner',        '~> 1.5.3'
  gem 'factory_girl_rails',      '~> 4.7.0'
  gem 'simplecov',               '~> 0.12.0', require: false
  gem 'shoulda-matchers',        '~> 3.1', '>= 3.1.1'
  gem 'rspec_candy',             '~> 0.4.0'
  gem 'rspec-rails',             '~> 3.5', '>= 3.5.1'
  # gem 'rspec-activemodel-mocks', '~> 1.0', '>= 1.0.3'
end

group :development do
  gem 'web-console',           '~> 3.3', '>= 3.3.1'
  gem 'listen',                '~> 3.1', '>= 3.1.5'
  gem 'spring',                '~> 1.7', '>= 1.7.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
