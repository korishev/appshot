require 'mysql2'
require 'methadone'

class Appshot
  class Mysql
    include Methadone::CLILogging

    def initialize(opts={})
      @host = opts[:hostname]
      @name = opts[:name] || "mysql"
      @port = opts[:port] || 3306
      @user = opts[:user] || "mysql"
      @password = opts[:password]
    end

    def call(call_chain)
      next_action = call_chain.shift
      @client = Mysql2::Client.new(username: @user, hostname: @host, password: @password, port: @port, database: @name)

      lock
      next_action.call(call_chain) unless next_action.nil?
      unlock
    end

    private

    def lock
      child_pid = fork do
        begin
          Timeout::timeout(20) do
            @client.query("FLUSH TABLES WITH READ LOCK")
          end
        rescue
          error "Could not get MySQL tables flushed and locked before timeout."
          @client.query("UNLOCK TABLES")
          @client.close
        end
      end
    end

    def unlock
      @client.query("UNLOCK TABLES")
    end

    def mkfifo
    end
  end
end
