source "https://rubygems.org"

ruby File.read(".ruby-version").strip
# For the web app
gem "sinatra"
gem "json"
gem "dotenv"

# For development and testing
group :development, :test do
  gem "rspec"
  gem "rack-test"
  gem "simplecov", require: false
end
