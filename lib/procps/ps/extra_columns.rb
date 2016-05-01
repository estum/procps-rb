require "procps/column_types/scheduling_policy"

module Procps
  class PS
    define_column :blocked
    define_column :bsdstart, "START"
    define_column :bsdtime, "TIME"
    define_column :c, &:to_f
    define_column :caught
    define_column :cgroup
    define_column :cls, "CLS", SchedulingPolicy
    define_column :cp do |v|
      v.to_f / 100_0
    end
    define_column :eip
    define_column :esp
    define_column :egid, &:to_i
    define_column :egroup
    define_column :etime, "ELAPSED"
    define_column :etimes, "ELAPSED", &:to_i
    define_column :f, &:to_i
    define_column :fgid, &:to_i
    define_column :fgroup
    define_column :fname
    define_column :fuid, &:to_i
    define_column :fuser
    define_column :ignored
    define_column :ipcns, "IPCNS", Address_10
    define_column :label
    define_column :lstart, "STARTED"
    define_column :lsession
    define_column :lwp, &:to_i
    define_column :machine
    define_column :maj_flt
    define_column :min_flt
    define_column :mntns, "MNTNS", Address_10
    define_column :netns, "NETNS", Address_10
    define_column :ouid, "OWNER", &:to_i
    define_column :pending
    define_column :pidns, &:to_i
    define_column :policy, "POL", SchedulingPolicy
    define_column :pri, &:to_i
    define_column :psr, &:to_i
    define_column :sched, "SCH" do |v|
      SchedulingPolicy.(v.to_i)
    end
    define_column :seat
    define_column :suid, &:to_i
    define_column :suser
    define_column :supgid, &:to_i
    define_column :supgrp
    define_column :sgi_p, "SGI_P", Address[null: "*".freeze]
    define_column :slice
    define_column :spid, &:to_i
    define_column :stackp, "STACKP", Address_16
    define_column :svgid, &:to_i
    define_column :svuid, &:to_i
    define_column :tpgid, &:to_i
    define_column :ucmd, "CMD"
    define_column :unit
    define_column :utsns, &:to_i
    define_column :uunit
    define_column :vsz, Memsize

    alias_column :class,      :cls
    alias_column :flag,       :f
    alias_column :flags,      :f
    alias_column :sig,        :pending
    alias_column :sig_block,  :blocked
    alias_column :sigmask,    :blocked
    alias_column :sig_catch,  :caught
    alias_column :sigcatch,   :caught
    alias_column :sig_ignore, :ignored
    alias_column :sigignore,  :ignored
    alias_column :ucomm,      :comm
    alias_column :vsize,      :vsz
  end
end
