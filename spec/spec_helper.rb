# frozen_string_literal: true
require "simplecov"
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter
  ]
)
SimpleCov.start do
  add_filter "spec"
  add_filter "vendor"
  minimum_coverage 100
end
$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "bundler/setup"
require "geoserver/publish"
require "webmock/rspec"

Dir[Pathname.new("./").join("spec", "support", "**", "*.rb")].sort.each { |file| require_relative file.gsub(/^spec\//, "") }

ROOT_PATH = Pathname.new(Dir.pwd)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
