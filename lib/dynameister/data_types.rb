require "dynameister/data_types/value"
require "dynameister/data_types/date_time"
require "dynameister/data_types/float"
require "dynameister/data_types/integer"
require "dynameister/data_types/time"

module Dynameister

  module DataTypes

    extend ActiveSupport::Concern

    DATA_TYPE_CASTER = {
      datetime: Dynameister::DataTypes::DateTime.new,
      float: Dynameister::DataTypes::Float.new,
      integer: Dynameister::DataTypes::Integer.new,
      time: Dynameister::DataTypes::Time.new
    }

    module ClassMethods

      def type_caster(type: data_type)
        DATA_TYPE_CASTER[type] || Dynameister::DataTypes::Value.new
      end

    end

  end

end
