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
      @appshots[appshot_name.to_s] = block
    end
  end

  def comment(arg)
    # do nothing.  it is a comment, after all.
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

  def setup_appshots()
    @appshots.each do |appshot|
      instance_eval(&appshot.last)
    end
  end

  def execute_callables
    # TODO: as it stands now, only the first set of callables will be called.  modify this to attach callables
    # to the appshot, then call all appshot callables
    first_call = @callables.shift
    first_call.call(@callables) unless first_call.nil?
  end

  def run_pass(options, args)
    if options["list-appshots"]
      puts list_appshots if options["list-appshots"]
    else
      setup_appshots
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

  #def method_missing(method_name, *args)
    #matches = Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/**/#{method_name.to_s}.rb")
    #if matches.empty?
      #super
    #else
      #load(matches.first)
      #action = Appshot.const_get("#{method_name.to_s.capitalize}").new
    #end
  #end
end
