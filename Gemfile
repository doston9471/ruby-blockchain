source "https://rubygems.org"

ruby File.read(".ruby-version").strip
# For the web app
gem "dotenv"
gem "json"
gem "sinatra"

# For development and testing
group :development, :test do
  gem "rack-test"
  gem "rspec"
  gem "rubocop-rails-omakase", require: false
  gem "simplecov", require: false
end
