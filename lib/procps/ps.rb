require 'set'
require 'procps/ps/command_builder'

module Procps
  # By default it loads only base columns.
  # To load extra columns require <tt>procps/ps/extra_columns</tt> after the gem is loaded.
  #
  # You can also define custom columns with the Procps::PS.define_column method.
  class PS
    DEFAULT_BIN_PATH = "/usr/bin/ps"
    DEFAULT_COLUMNS  = %i(pid rss pcpu)

    def self.columns
      @@columns ||= {}
    end

    # Define a column (see base columns in <tt>lib/procps/ps/base_columns.rb
    # </tt> and extra columns in <tt>lib/procps/ps/extra_columns.rb</tt>)
    def self.define_column(name, header = nil, cast = nil, &cast_block)
      header ||= name.to_s.upcase
      columns[name.downcase.to_sym] = Column.new(header, cast, &cast_block)
    end

    # Creates an alias to a column
    def self.alias_column(new_name, old_name)
      columns[new_name.to_sym] = old_name.to_sym
    end

    attr_accessor :bin_path, :options, :modifiers

    # Creates a Procps::PS object. Takes an argument with a bin path to ps command.
    def initialize(bin_path = nil)
      @bin_path  = bin_path || DEFAULT_BIN_PATH
      @options   = { o: [] }
      @modifiers = Set.new
    end

    # Select columns to list with ps command
    def select(*columns)
      columns.each do |col|
        unless @@columns.include?(col)
          raise ArgumentError, "unknown column :#{col}, please add it manually to Procps::PS.columns."
        end

        @options[:o] << col
      end
      self
    end

    # Filter processes list with conditions
    #
    # Available options:
    # * <tt>:command</tt>
    # * <tt>:group</tt>
    # * <tt>:user</tt>
    # * <tt>:pid</tt>
    # * <tt>:ppid</tt>
    # * <tt>:sid</tt>
    # * <tt>:tty</tt>
    # * <tt>:real_group</tt>
    # * <tt>:real_user</tt>
    def where(
        command: nil,
        group: nil,
        user: nil,
        pid: nil,
        ppid: nil,
        sid: nil,
        tty: nil,
        real_group: nil,
        real_user: nil
      )
      @options[:C]    = Array(command)    if command
      @options[:g]    = Array(group)      if group
      @options[:u]    = Array(user)       if user
      @options[:p]    = Array(pid)        if pid
      @options[:ppid] = Array(ppid)       if ppid
      @options[:s]    = Array(sid)        if sid
      @options[:t]    = Array(tty)        if tty
      @options[:G]    = Array(real_group) if real_group
      @options[:U]    = Array(real_user)  if real_user
      self
    end

    # Sum a CPU time for parent proccesses
    def sum
      @modifiers << "S"
      self
    end

    # Limit processes list size
    def limit(n)
      @limit = n
      self
    end

    # Limit processes list size & get result
    def take(n = 1)
      limit(n).to_a
    end

    # Takes a hash of options to set custom ps arguments.
    #
    # Example:
    #     Procps::PS.new.select(:pid, :rss).with_args(m: true).to_a
    def with_args(**args)
      @options.merge!(args)
      self
    end

    # Set sorting option. Doesn't supported by an original OSX ps (use with_args() method instead).
    #
    # Example:
    #     Procps::PS.new.select(:pid, :rss).sort("ppid", "-rss").to_a
    def sort(*orders)
      (@options[:sort] ||= []).concat(orders)
      self
    end

    # Reset a result
    def reset
      @result = nil
      self
    end

    # Executes a ps command & sets a result.
    def load(force = false)
      reset if force
      @result ||= exec_command
    end

    alias :to_a :load

    # List requested column objects with a typecast.
    def columns
      @columns ||= @options[:o].map(&@@columns)
    end

    private

    def to_command
      @command ||= begin
        @options[:o].concat(DEFAULT_COLUMNS) unless @options[:o].size > 0
        CommandBuilder.new(self).call
      end
    end

    def exec_command
      headers, *rows = IO.popen(to_command, "r") do |io|
        io.readlines
      end

      rows.replace(rows.take(@limit)) if @limit

      # headers = headers.split(/\s+/, columns.size)
      rows.map! do |row|
        parse_result_row(row)
      end
    end

    def parse_result_row(row)
      process = {}
      row.strip.split(/\s+/, columns.size).each_with_index do |col, i|
        process[@options[:o][i]] = columns[i].(col)
      end
      process
    end
  end
end