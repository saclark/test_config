require 'yaml'
require 'erb'
require_relative 'test_config/version'
require_relative 'test_config/hash_methods'
require_relative 'test_config/config_file'
require_relative 'test_config/config_data'

module TestConfig
  @_configuration = ConfigData.new

  def self.data
    @_configuration.data
  end

  def self.configure!(options = {})
    opts = {
      :base_config      => 'default.yml',
      :source_directory => 'config/environments',
      :env_variable     => 'TEST_ENV'
    }.merge(options)

    @_configuration.clear!

    if opts[:base_config]
      @_configuration.load!("#{opts[:source_directory]}/#{opts[:base_config]}")
    end

    if opts[:env_variable] && ENV[opts[:env_variable]]
      ENV[opts[:env_variable]].split(/, */).each do |file|
        @_configuration.load!("#{opts[:source_directory]}/#{file}")
      end
    end
  end

  def self.load!(file_path)
    @_configuration.load!(file_path)
  end

  def self.read(file_path)
    ConfigFile.new(file_path).data
  end

  def self.has_key?(key)
    data.has_key?(key)
  end

  def self.method_missing(name, default = nil, *args, &block)
    if has_key?(name.to_sym)
      return data[name.to_sym]
    elsif default && default.is_a?(Hash) && default.has_key?(:or)
      return default[:or]
    else
      fail(NoMethodError, "Unknown configuration root: #{name}", caller)
    end
  end

  if File.file?('test_config_options.yml')
    configure!(read('test_config_options.yml'))
  else
    configure!
  end
end
