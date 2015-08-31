require "dynameister/queries/parameters"

module Dynameister

  class Query

    AND_OPERATOR = " and "
    OR_OPERATOR  = " or "
    NOT_OPERATOR = "not "

    attr_reader :model, :operation, :dataset, :options

    def initialize(model, operation = :scan_table)
      @model      = model
      @operation  = operation
      @dataset    = Collection.new
      @operator   = AND_OPERATOR

      @options    = {}
    end

    def all
      response = run

      while continue?(response)
        options[:exclusive_start_key] = response.last_evaluated_key
        response = run(response)
      end

      response.entities.map do |item|
        model.new(item)
      end
    end

    def having(condition)
      key = key_for_condition(condition)
      serialized = serialize_condition(condition, key)
      if serialized
        build_options_query(serialized)
      end

      self
    end

    alias_method :in,      :having
    alias_method :and,     :having
    alias_method :eq,      :having
    alias_method :between, :having

    def build_options_query(serialized)
      options.merge!(serialized) do |_, initial, additional|
        if initial.is_a? String
          initial + @operator + additional
        elsif initial.is_a? Hash
          initial.merge(additional)
        end
      end
    end

    def or
      @operator = OR_OPERATOR
      self
    end

    def exclude
      @negation = NOT_OPERATOR
      self
    end

    alias_method :not, :exclude

    def limit(number)
      options[:limit] = number
      self
    end

    def count
      response = run

      while continue?(response)
        options[:exclusive_start_key] = response.last_evaluated_key
        response = run(response)
      end

      response.count
    end

    def index(name)
      options[:index_name] = name.to_s
      self
    end

    def le(condition)
      comparison(condition, "<=")
    end

    def lt(condition)
      comparison(condition, "<")
    end

    def ge(condition)
      comparison(condition, ">=")
    end

    def gt(condition)
      comparison(condition, ">")
    end

    private

    def serialize_condition(condition, expression, operator = "=")
      if condition.any?
        Queries::Parameters.new(model, expression, condition, operator, @negation).to_h
      end
    end

    def comparison(condition, operator)
      key = key_for_condition(condition)
      serialized = serialize_condition(condition, key, operator)
      if serialized
        build_options_query(serialized)
      end

      self
    end

    def run(previous_response = nil)
      response = model.client.public_send(operation, options.merge(table_name: model.table_name))
      dataset.deserialize_response(response, previous_response)
    end

    def continue?(previous_response)
      return false unless previous_response.last_evaluated_key

      if options[:limit]
        if options[:limit] > previous_response.count
          options[:limit] = options[:limit] - previous_response.count

          true
        else
          false
        end
      end

      true
    end

    def key_for_condition(condition)
      if (operation == :query_table) && (model.key_schema_keys.include? condition.keys.first)
        :key_condition_expression
      elsif condition.any?
        :filter_expression
      end
    end

  end

end
