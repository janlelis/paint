require File.dirname(__FILE__) + '/../lib/paint'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end
