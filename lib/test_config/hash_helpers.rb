module TestConfig
  module HashHelpers
    def self.deep_symbolize(obj)
      return obj.reduce({}) do |memo, (k, v)|
        memo.tap { |m| m[k.to_sym] = deep_symbolize(v) }
      end if obj.is_a? Hash

      return obj.reduce([]) do |memo, v|
        memo << deep_symbolize(v); memo
      end if obj.is_a? Array

      obj
    end

    def self.deep_merge(target, data)
      merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
      target.merge(data, &merger)
    end
  end
end
