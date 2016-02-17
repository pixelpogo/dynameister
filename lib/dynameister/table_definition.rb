module Dynameister

  class TableDefinition

    PROJECTION_TYPE = {
      all: "ALL",
      keys_only: "KEYS_ONLY",
      include: "INCLUDE"
    }.freeze

    MAX_INDEXES = 5

    attr_reader :table_name, :options

    def initialize(table_name, options = {})
      @table_name = table_name
      @options    = options

      validate_number_of_indexes!
    end

    def to_h
      hashed.reject { |_key, value| value.empty? }
    end

    private

    def hashed
      {
        table_name:               table_name,
        attribute_definitions:    attribute_definitions,
        key_schema:               key_schema,
        provisioned_throughput: {
          read_capacity_units:    read_capacity,
          write_capacity_units:   write_capacity
        },
        local_secondary_indexes:  local_secondary_indexes,
        global_secondary_indexes: global_secondary_indexes
      }
    end

    def key_schema
      elements_for :key_schema
    end

    def attribute_definitions
      elements_for(:attribute_definitions) + other_attribute_definitions
    end

    def other_attribute_definitions
      other_range_key_attribute_definitons + other_hash_key_attribute_definitions
    end

    def other_range_key_attribute_definitons
      range_keys_for_indexes.inject([]) do |memo, element|
        memo << attribute_definitions_element(element)
      end
    end

    def other_hash_key_attribute_definitions
      hash_keys_for_global_indexes.inject([]) do |memo, element|
        memo << attribute_definitions_element(element)
      end
    end

    def elements_for(type)
      hash_key, range_key = options.values_at(:hash_key, :range_key)

      case type
      when :attribute_definitions
        [
          attribute_definitions_element(hash_key),
          (attribute_definitions_element(range_key) if range_key)
        ].compact
      when :key_schema
        [
          key_schema_element(hash_key, :hash),
          (key_schema_element(range_key, :range) if range_key)
        ].compact
      else
        []
      end
    end

    def key_schema_element(key, key_type)
      {
        attribute_name: key.name.to_s,
        key_type:       key_type.to_s.upcase
      }
    end

    def attribute_definitions_element(key)
      unless [:string, :number, :binary].include?(key.type)
        msg = "Invalid #{key.type} key type, expected :string, :number or :binary."
        raise ArgumentError, msg
      end

      {
        attribute_name: key.name.to_s,
        attribute_type: key.type.to_s[0].upcase
      }
    end

    def read_capacity
      options[:read_capacity]
    end

    def write_capacity
      options[:write_capacity]
    end

    def local_secondary_indexes
      options[:local_indexes].map do |index|
        {
          index_name: index.name,
          key_schema: [
            hash_key,
            range_key_for_index(index)
          ],
          projection: {
            projection_type: projection_type_for(index),
            non_key_attributes: projection_non_key_attributes_for(index)
          }
        }
      end
    end

    def global_secondary_indexes
      options[:global_indexes].map do |index|
        {
          index_name: index.name,
          key_schema: [
            hash_key_for_index(index),
            range_key_for_index(index)
          ],
          projection: {
            projection_type: projection_type_for(index),
            non_key_attributes: projection_non_key_attributes_for(index)
          },
          provisioned_throughput: {
            read_capacity_units: index.throughput.first,
            write_capacity_units: index.throughput.last
          }
        }
      end
    end

    def projection_type_for(index)
      projection = index.projection.is_a?(Array) ? :include : index.projection

      PROJECTION_TYPE[projection]
    end

    def projection_non_key_attributes_for(index)
      return nil unless projection_type_for(index) == PROJECTION_TYPE[:include]

      index.projection.map(&:to_s)
    end

    def range_key_for_index(index)
      {
        attribute_name: index.range_key.name.to_s,
        key_type:       'RANGE'
      }
    end

    def validate_number_of_indexes!
      if [options[:local_indexes].length, options[:global_indexes].length].max > MAX_INDEXES
        raise ArgumentError, "A maximum of 5 global or local Secondary Indexes are supported"
      end
    end

    def hash_key
      key_schema.first
    end

    def hash_key_for_index(index)
      {
        attribute_name: index.hash_key.name.to_s,
        key_type: 'HASH'
      }
    end

    # We have to make sure to only return unique range keys here,
    # so that they are not added multiple times to the attribute definitions
    def range_keys_for_indexes
      all_keys = options[:local_indexes].map(&:range_key) +
                   options[:global_indexes].map(&:range_key)

      all_keys.reject do |range_key|
        range_key == options[:range_key]
      end.uniq
    end

    def hash_keys_for_global_indexes
      options[:global_indexes].map(&:hash_key).reject do |hash_key|
        hash_key == options[:hash_key]
      end
    end

  end

end
