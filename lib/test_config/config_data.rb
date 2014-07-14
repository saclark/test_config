module TestConfig
  class ConfigData
    attr_accessor :data

    def initialize(data = {})
      @data = HashMethods.deep_symbolize(data)
    end

    def clear!
      @data = {}
    end

    def load!(*files)
      @data = self.load(*files)
    end

    def load(*files)
      files.inject(@data) do |data, file|
        HashMethods.deep_merge(data, ConfigFile.new(file).data)
      end
    end
  end
end
