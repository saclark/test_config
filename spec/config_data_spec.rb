require 'spec_helper'

describe TestConfig::ConfigData do
  before :each do
    @config_data = TestConfig::ConfigData.new('existing_truthy' => 'key value')
  end

  describe '#initialize' do
    it 'takes 0 or 1 parameters and returns a TestConfig::ConfigData object' do
      TestConfig::ConfigData.new.should be_an_instance_of TestConfig::ConfigData
      TestConfig::ConfigData.new({}).should be_an_instance_of TestConfig::ConfigData
    end
  end

  describe '#data' do
    it 'should return symbolized configuration data' do
      @config_data.data.should == { :existing_truthy => 'key value' }
    end
  end

  describe '#clear!' do
    it 'should clear all configuration data' do
      @config_data.clear!
      @config_data.data.should == {}
    end
  end

  describe '#load!' do
    it 'should take a file and mutate @data by merging in the files contents' do
      @config_data.load!('config/environments/load_me.yml')
      @config_data.data.should == {
        :existing_truthy => 'key value',
        :config_environments_load_me => 'from config/environments/load_me.yml'
      }
    end

    it "should take a list of files and mutate @data by merging in the files' contents" do
      @config_data.load!('config/environments/load_me.yml', 'config/environments/env.yml')
      @config_data.data.should == {
        :existing_truthy => 'key value',
        :config_environments_load_me => 'from config/environments/load_me.yml',
        :config_environments_env => 'from config/environments/env.yml',
        :common_key => 'value from config/environments/env.yml'
      }
    end
  end

  describe '#load' do
    it 'should take a file and return a new hash containing @data merged with the file contents' do
      @config_data.load('config/environments/load_me.yml').should == {
        :existing_truthy => 'key value',
        :config_environments_load_me => 'from config/environments/load_me.yml'
      }
    end

    it "should take a list of files and return a new hash containing @data merged with the files' contents" do
      @config_data.load!('config/environments/load_me.yml', 'config/environments/env.yml')
      @config_data.data.should == {
        :existing_truthy => 'key value',
        :config_environments_load_me => 'from config/environments/load_me.yml',
        :config_environments_env => 'from config/environments/env.yml',
        :common_key => 'value from config/environments/env.yml'
      }
    end
  end
end
