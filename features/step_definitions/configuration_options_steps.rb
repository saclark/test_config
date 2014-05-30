Given(/^a "([^"]*)" file exists in the default directory$/) do |filename|
  File.file?("config/environments/#{filename}").should be_true
end

Given(/^a "([^"]*)" file exists in the "([^"]*)" directory$/) do |filename, directory|
  File.file?("#{directory}/#{filename}").should be_true
end

Given(/^a "([^"]*)" exists$/) do |directory|
  File.directory?(directory).should be_true
end

Given(/^I configure TestConfig with the following options$/) do |table|
  opts = {}

  table.hashes.each { |setting| opts[setting['option'].to_sym] = setting['value'] }

  TestConfig.configure!(opts)
end

When(/^I do not set custom configuration options$/) do
  TestConfig.configure!
end

When(/^I set "([^"]*)" to "([^"]*)"$/) do |option, value|
  TestConfig.configure!(option.to_sym => value)
end

Given(/^an? "([^"]*)" environment variable exists and is set to "([^"]*)"$/) do |env_var, value|
  ENV[env_var] = value
end

Then(/^the "([^"]*)" file should be loaded from the default directory$/) do |filename|
  case filename
  when 'custom_default.yml'
    TestConfig.default_test_value.should == 'from config/environments/custom_default.yml'
  when 'env.yml'
    TestConfig.env_test_value.should == 'from config/environments/env.yml'
  end
end

Then(/^the "([^"]*)" file should be loaded from the "([^"]*)" directory$/) do |filename, directory|
  location = "#{directory}/#{filename}"

  case location
  when 'config/environments/default.yml'
    TestConfig.default_test_value.should == 'from config/environments/default.yml'
  when 'config/environments/custom_default.yml'
    TestConfig.default_test_value.should == 'from config/environments/custom_default.yml'
  when 'config/custom_source_dir/default.yml'
    TestConfig.default_test_value.should == 'from config/custom_source_dir/default.yml'
  when 'config/custom_source_dir/custom_default.yml'
    TestConfig.default_test_value.should == 'from config/custom_source_dir/custom_default.yml'
  when 'config/environments/env.yml'
    TestConfig.env_test_value.should == 'from config/environments/env.yml'
  when 'config/custom_source_dir/env.yml'
    TestConfig.env_test_value.should == 'from config/custom_source_dir/env.yml'
  end
end
