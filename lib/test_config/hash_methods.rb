module TestConfig
  module HashMethods
    def self.deep_symbolize(data)
      if data.is_a?(Hash)
        return data.inject({}) do |memo, (k, v)|
          memo.tap { |m| m[k.to_sym] = deep_symbolize(v) }
        end
      end

      if data.is_a?(Array)
        return data.inject([]) do |memo, v|
          memo << deep_symbolize(v); memo
        end
      end

      data
    end

    def self.deep_merge(orig_data, new_data)
      merger = proc do |key, v1, v2|
        Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2
      end

      orig_data.merge(new_data, &merger)
    end
  end
end
