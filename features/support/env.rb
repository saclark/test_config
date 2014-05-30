require 'coveralls'
Coveralls.wear_merged!

require 'rspec/expectations'
require 'test_config'

# After do
#   if File.file?('test_config_options.yml')
#     File.delete('test_config_options.yml')
#   end

#   ENV.delete('TEST_ENV')
#   TestConfig.configure!
# end
