require 'procps/column'

module Procps
  class SchedulingPolicy < Column::Type
    attr_reader :value
    alias :to_sym :value

    POLICIES       = %i(SCHED_OTHER SCHED_FIFO SCHED_RR SCHED_BATCH SCHED_ISO SCHED_IDLE).freeze
    NORMALIZED_MAP = {"TS" => POLICIES[0], "FF" => POLICIES[1], "RR" => POLICIES[2],
                      "B" => POLICIES[3], "ISO" => POLICIES[4], "IDL" => POLICIES[5],
                      "?" => :unknown_value, "-" => :not_reported }.freeze

    private_constant :POLICIES
    private_constant :NORMALIZED_MAP

    protected def normalize
      @value = @original.is_a?(Integer) ? POLICIES[@original] : NORMALIZED_MAP[@original]
    end
  end
end
