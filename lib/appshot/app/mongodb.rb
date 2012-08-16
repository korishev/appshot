class Appshot
  class MongoDB

    def initialize(opts={})
      @host         = opts[:hostname]     || "localhost"
      @port         = opts[:port]         || 27017
      @mongo_binary = opts[:mongo_binary] || "mongo"
    end

    def call(call_chain)
      next_action = call_chain.shift
      lock
      next_action.call(call_chain) unless next_action.nil?
      unlock
    end

    def lock
      %x[#{@mongo_binary} --host #{@host}:#{@port} --eval "db.runCommand({ fsync:1, lock:1 })" admin ]
    end

    def unlock
      %x[#{@mongo_binary} --host #{@host}:#{@port} --eval "db.$cmd.sys.unlock.findOne()" admin ]
    end
  end
end
