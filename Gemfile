# frozen_string_literal: true
source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gemspec

group :development, :test do
  gem "bixby", require: false
  gem "simplecov", require: false
end

group :test do
  gem "webmock"
end
