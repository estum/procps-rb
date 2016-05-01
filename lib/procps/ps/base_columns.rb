require 'procps/column'
require 'procps/column_types/command'
require 'procps/column_types/memsize'

module Procps
  class PS
    Address    = -> (base = 10, null: "-".freeze) { -> (v) { v.is_a?(String) ? v == null ? nil : v.to_i(base) : v } }
    Address_10 = Address[]
    Address_16 = Address[16]

    define_column :cmd, "CMD", Command
    define_column :comm, "COMMAND"
    define_column :command, "COMMAND", Command
    define_column :gid, &:to_i
    define_column :group
    define_column :ni, &:to_i
    define_column :nlwp, &:to_i
    define_column :nwchan, "WCHAN", Address_16
    define_column :pcpu, "%CPU", &:to_f
    define_column :pgid, &:to_i
    define_column :pgrp, "PGRP", &:to_i
    define_column :pid, &:to_i
    define_column :pmem, "%MEM", &:to_f
    define_column :ppid, &:to_i
    define_column :rgid, &:to_i
    define_column :rgroup
    define_column :rss, "RSS", Memsize
    define_column :rtprio, "RTPRIO", Address_10
    define_column :ruid, &:to_i
    define_column :ruser
    define_column :s
    define_column :sess, &:to_i
    define_column :sgid, &:to_i
    define_column :sgroup
    define_column :sid, &:to_i
    define_column :size, &:to_i
    define_column :start, "STARTED"
    define_column :start_time
    define_column :stat
    define_column :tgid, &:to_i
    define_column :sz, &:to_i
    define_column :thcount, "THCNT", &:to_i
    define_column :tid, &:to_i
    define_column :time
    define_column :tname, "TTY"
    define_column :tt
    define_column :user
    define_column :uid, &:to_i
    define_column :userns, &:to_i

    alias_column :'%cpu',     :pcpu
    alias_column :'%mem',     :pmem
    alias_column :nice,       :ni
    alias_column :args,       :command
    alias_column :cputime,    :time
    alias_column :rssize,     :rss
    alias_column :rsz,        :rss
    alias_column :state,      :s
    alias_column :tty,        :tt
    alias_column :uname,      :user
  end
end
