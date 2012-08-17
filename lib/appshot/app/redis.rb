class Appshot
  class Redis

    def initialize(opts={})
      @save_before_snapshot = opts[:save_before_snapshot] || false
      @redis_binary         = opts[:database_command]     || "redis-cli"
    end

    def call(call_chain)
      next_action = call_chain.shift
      invoke_save if @save_before_snapshot
      next_action.call(call_chain) unless next_action.nil?
    end

    def invoke_save
      %x[ #{redis_binary} bgsave ]
    end
  end
end
