module Dynameister

  class KeyDefinitionError < StandardError

    def initialize(key, key_type)
      super(
        <<-EOS
          Not supported #{key_type} key #{key}.
          Supported are String/Symbol for a #{key_type} key of default
          type and Hash to define a #{key_type} key of type :string,
          :number or :binary.
        EOS
      )
    end

  end

  class ReversedScanNotSupported < StandardError; end

end
