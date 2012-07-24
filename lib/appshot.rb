require "appshot/version"
require "appshot/volume"

class Appshot
  def initialize(config)
    @appshots = {}
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
  def comment(arg)
    # do nothing.  it is a comment, after all.
  end

  def appshot(appshot_name, &block)
    if block_given?
      @appshots[appshot_name.to_s] = block
    end
  end

  def appshots
    @appshots
  end

  def execute_appshots()
    @appshots.each do |appshot|
      instance_eval(&appshot.last)
    end
  end

  def run_pass(options, args)
    puts list_appshots if options["list-appshots"]
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

  def method_missing(method_name, *args)
    matches = Dir.glob("**/#{method_name.to_s}.rb")
    if matches.empty?
      super
    else
      load(matches.first)
      action = Appshot.const_get("#{method_name.to_s.capitalize}").new
    end
  end
end
