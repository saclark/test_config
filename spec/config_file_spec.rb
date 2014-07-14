require 'spec_helper'

describe TestConfig::ConfigFile do
  before :each do
    @config_file = TestConfig::ConfigFile.new('config/environments/default.yml')
  end

  describe '#file' do
    it 'should return the input string passed to the contructor' do
      @config_file.file.should == 'config/environments/default.yml'
    end
  end

  describe '#data' do
    it 'should return the file data as a hash with keys symbolized' do
      @config_file.data.should == {
        :config_environments_default => 'from config/environments/default.yml',
        :common_key => 'value from config/environments/default.yml'
      }
    end
  end

  describe '#to_s' do
    it 'should return the file contents as a string' do
      @config_file.to_s.should == "config_environments_default: 'from config/environments/default.yml'\ncommon_key: 'value from config/environments/default.yml'\n"
    end

    it 'should raise an erorr if the file is not found' do
      expect { TestConfig::ConfigFile.new('blah').to_s }.to raise_error(RuntimeError)
    end
  end

  describe '#evaluate' do
    it 'should return the file contents as a string with erb evaluated' do
      file_with_erb = TestConfig::ConfigFile.new('config/environments/has_erb.yml')
      file_with_erb.evaluate.should include("value_from_erb: value from erb in config/environments/custom_default.yml")
    end
  end

  describe '#to_h' do
    it 'should return an empty hash if the file is empty' do
      TestConfig::ConfigFile.new('config/environments/empty.yml').to_h.should == {}
    end

    it 'should return a hash of file contents with keys not symbolized' do
      @config_file.to_h.should == {
        'config_environments_default' => 'from config/environments/default.yml',
        'common_key' => 'value from config/environments/default.yml'
      }
    end
  end
end
