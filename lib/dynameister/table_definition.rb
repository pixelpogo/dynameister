module Dynameister

  class TableDefinition
    PROJECTION_TYPE = {
      all: "ALL",
      keys_only: "KEYS_ONLY",
      include: "INCLUDE"
    }

    attr_reader :table_name, :options

    def initialize(table_name, options = {})
      @table_name = table_name
      @options    = options
    end

    def to_h
      hashed.reject { |_key, value| value.empty? }
    end

    private

    def hashed
      {
        table_name:            @table_name,
        attribute_definitions: attribute_definitions,
        key_schema:            key_schema,
        provisioned_throughput: {
          read_capacity_units:  read_capacity,
          write_capacity_units: write_capacity,
        },
        local_secondary_indexes: local_secondary_indexes
      }
    end

    def key_schema
      elements_for :key_schema
    end

    def attribute_definitions
      elements_for :attribute_definitions
    end

    def elements_for(type)
      hash_key, range_key = @options.values_at(:hash_key, :range_key)
      method = "#{type}_element".to_sym

      [
        send(method, hash_key, :hash),
        (send(method, range_key, :range) if range_key)
      ].compact
    end

    def key_schema_element(desc, key_type)
      name = desc.keys.first

      {
        attribute_name: name.to_s,
        key_type:       key_type.to_s.upcase
      }
    end

    def attribute_definitions_element(desc, key_type)
      (name, type) = desc.to_a.first

      unless [:string, :number, :binary].include?(type)
        msg = "Invalid #{key_type} key type, expected :string, :number or :binary."
        raise ArgumentError, msg
      end

      {
        attribute_name: name.to_s,
        attribute_type: type.to_s[0].upcase
      }
    end

    def read_capacity
      @options[:read_capacity]
    end

    def write_capacity
      @options[:write_capacity]
    end

    def local_secondary_indexes
      @options[:local_indexes].map do |index|
        {
          index_name: index[:name],
          key_schema: key_schema,
          projection: {
            projection_type: projection_type_for(index),
            non_key_attributes: []
          }
        }
      end
    end

    def projection_type_for(index)
      PROJECTION_TYPE[index[:projection]]
    end
  end

end
