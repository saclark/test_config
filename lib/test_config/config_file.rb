module TestConfig
  class ConfigFile
    attr_accessor :file, :data

    def initialize(file)
      @file = file
      @data = HashMethods.deep_symbolize(self.to_h)
    end

    def to_s
      begin
        File.read(@file)
      rescue SystemCallError
        raise "Could not locate configuration file: #{@file}."
      end
    end

    def evaluate
      ERB.new(self.to_s).result
    end

    def to_h
      YAML.load(self.evaluate) || {}
    end
  end
end
