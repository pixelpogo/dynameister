require "dynameister/data_types/value"
require "dynameister/data_types/date_time"
require "dynameister/data_types/float"
require "dynameister/data_types/integer"
require "dynameister/data_types/time"

module Dynameister

  module DataTypes

    extend ActiveSupport::Concern

    DATA_TYPE_CASTER = {
      datetime: Dynameister::DataTypes::DateTime.instance,
      float: Dynameister::DataTypes::Float.instance,
      integer: Dynameister::DataTypes::Integer.instance,
      time: Dynameister::DataTypes::Time.instance
    }.freeze

    AWS_DATA_TYPE_MAP = {
      time:     :string,
      datetime: :string,
      integer:  :number,
      float:    :number,
      string:   :string,
      number:   :number,
      binary:   :binary
    }.freeze

    DEFAULT_AWS_DATA_TYPE = :string

    module ClassMethods

      def type_caster(type:)
        DATA_TYPE_CASTER[type] || Dynameister::DataTypes::Value.instance
      end

    end

  end

end
