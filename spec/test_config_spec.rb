require 'spec_helper'

describe TestConfig do
  before do
    ENV['TEST_ENV'] = 'env.yml'
    TestConfig.configure!
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

    context 'nested data' do
      it 'should allow access to nested data' do
        TestConfig.data_hash[:array_data][1].should == 'second item'
      end
    end

    context 'environment specific data provided' do
      it 'should return data unique to the env file' do
        TestConfig.added_by_env_yaml.should == 'added by env.yml'
      end

      it 'should return data overwritten by the env file' do
        TestConfig.overwritten_data.should == 'overwritten by env.yml'
      end
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

  # describe '#load_file' do
  #   pending
  # end

  # describe '#configure!' do
  #   pending
  # end

  # describe 'HashHelpers::deep_symbolize' do
  #   pending
  # end

  # describe 'HashHelpers::deep_merge' do
  #   pending
  # end
end
