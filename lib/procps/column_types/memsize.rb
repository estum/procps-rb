require 'procps/column'

module Procps
  class Memsize < DelegateClass(Integer)
    def self.call(value)
      new(value)
    end

    SUFFIXES = %w(B K M G T)

    def initialize(value)
      super(value.to_i * 1024)
    end

    def human
      step   = 0
      output = __getobj__.to_f

      while output > 1024
        step += 1
        output = output / 1024
        break if step == SUFFIXES.size
      end

      fmt = output == output.to_i ? "%d%s" : "%.2f%s"
      format(fmt, output, SUFFIXES[step])
    end

    alias :inspect :human
  end
end
