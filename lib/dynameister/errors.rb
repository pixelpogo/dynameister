module Dynameister

  class IndexKeyDefinitionError < StandardError

    def initialize(key)
      @key = key
    end

    def message
      <<-EOS
        Not supported range key type #{@key} for local index.
        Supported types are String/Symbol for a default range key of
        type :number and Hash to define a range key of type :string,
        :number or :binary.
      EOS
    end

  end

end
