require_relative "errors"

module Dynameister

  Key = Struct.new(:name, :type) do

    def self.create_hash_key(hash_key)
      create_key(hash_key, :hash)
    end

    def self.create_range_key(range_key)
      create_key(range_key, :range)
    end

    def self.create_key(key_information, key_type)
      default_key_data_type = key_type == :hash ? :string : :number

      case key_information
      when String, Symbol then Key.new(key_information.to_sym, default_key_data_type)
      when Hash           then Key.new(key_information.keys.first,
                                       key_information.values.first)
      else raise IndexKeyDefinitionError.new(key_information)
      end
    end

    private_class_method :create_key

  end

end
