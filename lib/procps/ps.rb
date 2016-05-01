require 'procps/ps/columns'
require 'procps/ps/command_builder'

module Procps
  class PS
    DEFAULT_BIN_PATH = "/usr/bin/ps"
    DEFAULT_COLUMNS  = %i(pid rss pcpu)

    attr_accessor :bin_path, :options, :modifiers

    def initialize(bin_path = nil)
      @bin_path  = bin_path || DEFAULT_BIN_PATH
      @options   = { o: [] }
      @modifiers = Set.new
    end

    def sum
      @modifiers << "S"
      self
    end

    def select(*columns)
      @options[:o].concat(columns)
      self
    end

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

    def limit(n)
      @limit = n
      self
    end

    def take(n = 1)
      limit(n).to_a
    end

    def with_args(**args)
      @options.merge!(args)
      self
    end

    def sort(*orders)
      (@options[:sort] ||= []).concat(orders)
      self
    end

    def reset
      @result = nil
      self
    end

    def load
      @result ||= exec_command
    end

    alias :to_a :load

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
      p to_command

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
