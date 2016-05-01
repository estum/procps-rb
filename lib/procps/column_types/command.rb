require 'procps/column'

module Procps
  # The column type for a +command+ column.
  class Command < Column::Type
    attr_reader :name, :arguments, :title
    alias :to_s :name
    alias :args :arguments

    def inspect
      original
    end

    protected def normalize
      if @original =~ /(?<=^\[)(?<name>.+?)(?=\]$)/
        @name = name
      elsif @original =~ /^(?<name>[A-Za-z0-9_\-]+): (?<title>.+)$/
        @name  = name
        @title = title
      else
        @name, *@arguments = Shellwords.split(@original)
      end
    end
  end
end
