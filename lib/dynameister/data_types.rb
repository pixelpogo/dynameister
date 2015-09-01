require "dynameister/data_types/value"
require "dynameister/data_types/date_time"

module Dynameister
  module DataTypes
    extend ActiveSupport::Concern

    DATA_TYPE_CASTER = {
      datetime: Dynameister::DataTypes::DateTime.new
    }

    module ClassMethods

      def type_caster(type: type)
        DATA_TYPE_CASTER[type] || Dynameister::DataTypes::Value.new
      end

    end

  end

end
