require 'pathname'

class Appshot
  class DM
    def initialize(opts={})
      @mount_point = Pathname.new(opts[:mount_point] || "")
      validate_mount_point(@mount_point)
    end

    def call(call_chain=[])
      next_action = call_chain.shift

      freeze
      next_action.call(call_chain) unless next_action.nil?
      unfreeze
    end

    private

    def validate_mount_point(mount_point)
      raise "Your mount point: '#{mount_point}' is not a mount point!" unless @mount_point.mountpoint?
      raise "We cannot currently unfreeze the root filesystem, leaving your system unusable. Aborting." if @mount_point.to_s == "/"
    end

    def mount_point
      @mount_point.to_s
    end

    def freeze_command
      %x{ /sbin/fsfreeze -f #{mount_point} }
    end

    def unfreeze_command
      %x{ /sbin/fsfreeze -u #{mount_point} }
    end

    def freeze
      begin
        freeze_command
      rescue
        puts "There was a problem freezing your mount point: #{mount_point}"
      end
    end

    def unfreeze
      unfreeze_command
    end

    def check_mount_point
      mounts = %x{ df }
    end
  end
end
