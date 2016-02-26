module Dynameister

  class KeyDefinitionError < StandardError

    def initialize(key)
      super(
        <<-EOS
          Not supported data type for key with name #{key}.
          Supported are String/Symbol for #{key} of default
          type and Hash to define a key of type :string,
          :number or :binary.
        EOS
      )
    end

  end

  class ReversedScanNotSupported < StandardError; end

end
