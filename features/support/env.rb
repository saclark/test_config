require 'rspec/expectations'
require 'test_config'

Before do
  ENV.delete('TEST_ENV')
  TestConfig.configure!
end
