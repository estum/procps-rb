module Procps
  class Column
    attr_reader :header
    alias :to_s :header

    def initialize(header, cast = nil, &cast_block)
      @cast = block_given? ? cast_block : cast
      raise ArgumentError, "a value of the :cast option must respond to a #call method or be nil" unless @cast.nil? || @cast.respond_to?(:call)
      @header = header.to_s.freeze
      freeze
    end

    def call(value)
      @cast.nil? ? value : @cast.call(value)
    rescue => e
      warn e
      value
    end

    class Type
      attr_reader :original
      alias :to_s :original

      def initialize(value)
        @original = value
        normalize if self.class.method_defined?(:normalize)
      end

      def to_h
         Hash[instance_variables.map { |name| [name[1..-1].to_sym, instance_variable_get(name)] }]
      end

      def inspect
        "<#{self.class}: #{to_h.inspect}>"
      end

      def self.call(value)
        new(value)
      end
    end
  end
end
