require 'shellwords'

module Procps
  class PS
    # Builds complete +ps+ shell command before execution.
    class CommandBuilder
      def initialize(ps)
        @ps = ps
      end

      def call
        [@ps.bin_path, *modifiers, *options].compact
      end

      def modifiers
        @modifiers ||= @ps.modifiers.size > 0 ? @ps.modifiers.to_a * "" : nil
      end

      def options
        @options ||= begin
          @ps.options.flat_map do |opt, value|
            case value
            when false then nil
            when true  then normalize_option_key(opt)
                       else [normalize_option_key(opt), normalize_option_value(value)]
            end
          end
        end
      end

      private

      def normalize_option_key(opt)
        opt.size == 1 ? "-#{opt}" : "--#{opt}"
      end

      def normalize_option_value(value)
        case value
        when Array then value.join(",")
                   else value.to_s
        end
      end
    end
  end
end
