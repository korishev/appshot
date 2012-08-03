require "appshot/version"
require "appshot/volume"
require "appshot/app"
require "appshot/filesystem"
require "awesome_print"

class Appshot
  def initialize(config)
    @appshots = {}
		@callables = []
    instance_eval(config)
  end

  def empty?
    true
  end

  def appshot_count
    @appshots.size
  end

  def appshot_names
    @appshots ? @appshots.keys : []
  end

  ##############
  # DSL Keywords
  ##############
  def appshot(appshot_name, &block)
    if block_given?
      @callables = []
      @appshots[appshot_name.to_s] = instance_eval(&block)
    end
  end

  def comment(arg)
    @callables
  end

  def xfs(args={})
    @callables << Appshot::DM.new(args)
  end

  def ext4(args={})
    @callables << Appshot::DM.new(args)
  end

  def ebs_snapshot(args={})
    @callables << Appshot::EBS_Snapshot.new(args)
  end

	def mysql(args={})
		@callables << Appshot::Mysql.new(args)
	end

	def ebs_prune(args={})
    @callables << Appshot::EBS_Prune.new(args)
	end

	###############
	# Internals
	###############

  def appshots
    @appshots
  end

  def execute_callables
    @appshots.each do |appshot, callable|
      first_call = callable.shift
      first_call.call(callable) unless first_call.nil?
    end
  end

  def run_pass(options, args)
    if options["list-appshots"]
      puts list_appshots if options["list-appshots"]
    else
      execute_callables unless options["trial-run"]
    end
  end

  def list_appshots
    case @appshots.count
    when 0
      "There are no appshots configured"
    when 1
      "There is one appshot configured: #{@appshots.keys.first.to_s}"
    else
      "There are #{@appshots.count} appshots configured: #{@appshots.keys.join(', ')}"
    end
  end
end
