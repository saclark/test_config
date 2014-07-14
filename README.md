# TestConfig

[![Build Status](https://travis-ci.org/saclark/test_config.svg?branch=master)](https://travis-ci.org/saclark/test_config) [![Coverage Status](https://coveralls.io/repos/saclark/test_config/badge.png)](https://coveralls.io/r/saclark/test_config)

TestConfig provides flexible cross-environment configuration management for your test suites by allowing you to store configuration data in YAML files and accessing that data through methods on the TestConfig module matching the desired key.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'test_config'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install test_config

Then be sure to `require 'test_config'` in your project.

## Usage
By default, TestConfig looks in a `config/environments` directory to load a `default.yml` file containing configuration data. It also loads and _merges in_ any additional configuration data from files listed in a `TEST_ENV` environment variable, if present.

Each of these names and locations are options that can be [configured](#configuration-options).

### Example
Let's say you are testing a web application and you want to keep certain test data in configuration files that you can access from your tests, thus allowing your tests to run more seamlessly in different environments. If we are using TestConfig's default settings, we would first create a file named `default.yml` with the following data and place it in `config/environments`:

```yaml
base_url: http://www.dev.example.com
username: testuser
password: Pa55w0rd
```

At this point, you can access this data in your tests by calling methods on the TestConfig module that match your keys*.

> \*__Note__: For this reason, you should name your keys according to the same syntactic rules as those for method names in Ruby. (although if you _really_ need to, you can use the `#send` method to get around this: `TestConfig.send('key-name-with-dashes')`.

```ruby
TestConfig.base_url # => "http://www.dev.example.com"
TestConfig.username # => "testuser"
TestConfig.password # => "Pa55w0rd"
```

If you aren't sure a key exists, you can check if it exists or even provide default values like so:

```ruby
TestConfig.has_key?('nonexistent_key') # => false
TestConfig.nonexistent_key(:or => "my default value") # => "my default value"
```

Now, in order to run tests on your local machine with an updated `base_url`, you can create another file (let's call it `local.yml`) in your `config/environments` directory with the following:

```yaml
base_url: http://localhost:1234
```

You'd then run tests against your local machine with a `TEST_ENV` environment variable set to `local.yml`. The data from that file will get merged in with the data from `default.yml`, giving you the same configuration data as before, but with the `base_url` updated for your local machine:

```ruby
TestConfig.base_url # => "http://localhost:1234"
TestConfig.username # => "testuser"
TestConfig.password # => "Pa55w0rd"
```

This works particularly well with Cucumber since you can set this environment variable in your `cucumber.yml` profiles for each environment:

```yaml
default: --format pretty
local: TEST_ENV=local.yml --format pretty
joes_machine: TEST_ENV=joes_machine.yml --format pretty
ci: TEST_ENV=ci.yml --format pretty
```

## Configuration Options
TestConfig is itself, configurable by calling the `configure!` method with any of the optional parameters found in the example below:

```ruby
TestConfig.configure!(
    :source_directory => 'my/custom/location',
    :base_config      => 'my_base_config.yml',
    :env_variable     => 'MY_TEST_ENV_VAR'
)
```

Alternatively, you can set these options by placing a `test_config_options.yml` file in the root of your project. It might look like this:

```yaml
source_directory: my/custom/location
base_config: my_base_config.yml
env_variable: MY_TEST_ENV_VAR
```

Here is a breakdown of each option:

#### `:source_directory`
- Tells TestConfig where to find your configuration files (starting from the root of your project).
- Set to `config/environments` by default.

#### `:base_config`
- Tells TestConfig which file to use for "base configuration" (i.e. configuration data common to all test environments). This should be the filename or filepath to a 
- Set to `default.yml` by default.
- Can be set to `nil` to prevent TestConfig from looking for a base configuration file.

#### `:env_variable`
- Tells TestConfig which environment variable (if present) to use for determining which additional configuration files to load. The environment variable should contain a comma separated list of filenames/filepaths from the `:source_directory` to be loaded and _merged in_ with previously loaded data (data from a previously loaded file whose key matches one from a freshly loaded file will be overwritten).
- Set to `TEST_ENV` by default.
- Can be set to `nil` to prevent TestConfig from looking for additional configuration files.

## TODO
- Add support for automatically loading files according to hostname

## Contributing

1. Fork it ( https://github.com/saclark/test_config/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
