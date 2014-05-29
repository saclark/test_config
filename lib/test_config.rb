require 'yaml'
require 'erb'
require_relative 'test_config/version'
require_relative 'test_config/hash_helpers'

module TestConfig
  attr_reader :_test_config

  @_test_config = {}

  def self.configure!(options = {})
    opts = {
      :default_file => 'default.yml',
      :source_direcotry => 'config/environments',
      :env_variable => 'TEST_ENV'
    }.merge(options)

    default_data = {}
    env_data = {}

    if opts[:default_file]
      default_data = load_file(opts[:default_file], opts[:source_direcotry])
    end

    if opts[:env_variable] && ENV[opts[:env_variable]]
      env_data = load_file(ENV[opts[:env_variable]], opts[:source_direcotry])
    end

    @_test_config = TestConfig::HashHelpers.deep_merge(default_data, env_data)
  end

  def self.method_missing(name, default = nil, *args, &block)
    if @_test_config.has_key?(name.to_sym)
      return @_test_config[name.to_sym]
    elsif default && default.is_a?(Hash) && default.has_key?(:or)
      return default[:or]
    else
      fail(NoMethodError, "Unknown configuration root: #{name}", caller)
    end
  end

  def self.has_key?(key_name)
    @_test_config.has_key?(key_name)
  end

  private

  def self.load_file(file, default_dir = '.')
    file_path = "#{default_dir}/#{file}"
    file_data = {}

    begin
      file_data = YAML.load(ERB.new(File.read(file_path)).result) || {}
    rescue SystemCallError
      raise "Could not locate configuration file: #{file_path}."
    end

    TestConfig::HashHelpers.deep_symbolize(file_data)
  end

  if File.file?('test_config_options.yml')
    config_opts = load_file('test_config_options.yml', '.')
    configure!(config_opts)
  else
    configure!
  end
end
