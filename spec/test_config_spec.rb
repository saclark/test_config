require 'spec_helper'

describe TestConfig do
  before :each do
    module TestConfig
      @_configuration = ConfigData.new({
        :existing_truthy => 'key value',
        :existing_falsey => false,
        :data_hash => {
          :array_data => ['first item', 'second item']
        }
      })
    end
  end

  after :each do
    module TestConfig
      @_configuration = {}
    end

    ENV.delete('TEST_ENV')
    ENV.delete('MY_TEST_ENV')
  end

  describe '#data' do
    it 'should return a hash of all configuration data' do
      TestConfig.data.should == {
        :existing_truthy => 'key value',
        :existing_falsey => false,
        :data_hash => {
          :array_data => ['first item', 'second item']
        }
      }
    end
  end

  describe '#configure!' do
    it 'should load files according to defaults when no options passed' do
      ENV['TEST_ENV'] = 'env.yml,env2.yml'
      TestConfig.configure!

      TestConfig.data.should == {
        :config_environments_default => 'from config/environments/default.yml',
        :config_environments_env => 'from config/environments/env.yml',
        :config_environments_env2 => 'from config/environments/env2.yml',
        :common_key => 'value from config/environments/env2.yml'
      }
    end

    it 'should load files according to custom options' do
      ENV['MY_TEST_ENV'] = 'env.yml,env2.yml'
      TestConfig.configure!(
        :source_directory => 'config/custom_source_dir',
        :base_config      => 'custom_default.yml',
        :env_variable     => 'MY_TEST_ENV'
      )

      TestConfig.data.should == {
        :config_custom_source_dir_custom_default => 'from config/custom_source_dir/custom_default.yml',
        :config_custom_source_dir_env => 'from config/custom_source_dir/env.yml',
        :config_custom_source_dir_env2 => 'from config/custom_source_dir/env2.yml',
        :common_key => 'value from config/custom_source_dir/env2.yml'
      }
    end

    it 'should not load anything if base_config and env_variable set to nil' do
      TestConfig.configure!(
        :base_config  => nil,
        :env_variable => nil
      )

      TestConfig.data.should == {}
    end
  end

  describe '#load!' do
    it "should merge a given file's data into @_configuration" do
      TestConfig.load!('config/environments/load_me.yml')
      TestConfig.data.should == {
        :existing_truthy => 'key value',
        :existing_falsey => false,
        :data_hash => {
          :array_data => ['first item', 'second item']
        },
        :config_environments_load_me => 'from config/environments/load_me.yml',
      }
    end
  end

  describe '#read' do
    it 'should return a symbolized hash of file data' do
      TestConfig.read('config/environments/custom_default.yml').should == {
        :config_environments_custom_default => 'from config/environments/custom_default.yml',
        :common_key => 'value from config/environments/custom_default.yml'
      }
    end

    it 'should evaluate files containing erb' do
      TestConfig.read('config/environments/has_erb.yml').should == {
        :value_from_erb => 'value from erb in config/environments/custom_default.yml'
      }
    end

    it 'should return an empty hash if the file is empty' do
      TestConfig.read('config/environments/empty.yml').should == {}
    end

    it 'should raise an error if the file does not exist' do
      expect { TestConfig.read('this_does_not_exist.yml') }.to raise_error
    end
  end

  describe '#has_key?' do
    it 'should return true for existing keys' do
      TestConfig.has_key?(:existing_truthy).should == true
    end

    it 'should return false for nonexistent keys' do
      TestConfig.has_key?(:nonexistent_key).should == false
    end
  end

  describe '#method_missing' do
    context 'existing key with truthy value' do
      it 'should return the key value when no default is given' do
        TestConfig.existing_truthy.should == 'key value'
      end

      it 'should return the key value when a default is given' do
        TestConfig.existing_truthy(:or => 'default value').should == 'key value'
      end
    end

    context 'existing key with falsey value' do
      it 'should return the key value when no default is given' do
        TestConfig.existing_falsey.should == false
      end

      it 'should return the key value when a default is given' do
        TestConfig.existing_falsey(:or => 'default value').should == false
      end
    end

    context 'nonexistent key' do
      it 'should return the default value when a truthy default value is given' do
        TestConfig.nonexistent_key(:or => 'default value').should == 'default value'
      end

      it 'should return the default value when a falsey default value is given' do
        TestConfig.nonexistent_key(:or => false).should == false
      end

      it "should return the default value assigned to the ':or' key" do
        TestConfig.nonexistent_key(:blah => 'blah', :or => 'default value').should == 'default value'
      end

      it "should throw a 'NoMethodError' when no default is given" do
        expect { TestConfig.nonexistent_key }.to raise_error(NoMethodError)
      end

      it "should throw a 'NoMethodError' when the first parameter is not a hash" do
        expect { TestConfig.nonexistent_key('blah', :or => 'default value') }.to raise_error(NoMethodError)
      end

      it "should throw a 'NoMethodError' when the first parameter is not a hash with the key ':or'" do
        expect { TestConfig.nonexistent_key(:blah => 'blah') }.to raise_error(NoMethodError)
      end
    end

    context 'nested complex data' do
      it 'should be accessible' do
        TestConfig.data_hash.should == {
          :array_data => ['first item', 'second item']
        }
      end
    end
  end
end
