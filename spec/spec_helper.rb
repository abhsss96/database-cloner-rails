require "bundler/setup"
require "tmpdir"
require "fileutils"
require "active_record"
require "active_support/core_ext/string/inflections"
require "active_support/core_ext/object/blank"
require "database-cloner-rails"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
