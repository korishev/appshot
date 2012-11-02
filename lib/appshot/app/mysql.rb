require 'methadone'

class Appshot
  class Mysql
    include Methadone::CLILogging

    def initialize(opts={})
      @host = opts[:hostname] || "localhost"
      @name = opts[:name]     || "mysql"
      @port = opts[:port]     || 3306
      @user = opts[:username] || "mysql"
      @password = opts[:password]
    end

    def call(call_chain)
      require 'mysql2'
      next_action = call_chain.shift
      @client = Mysql2::Client.new(username: @user, hostname: @host, password: @password, port: @port, database: @name)

      error "Could not get connection to database, check your settings" unless @client

      lock
      next_action.call(call_chain) unless next_action.nil?
    ensure
      unlock(@client)
    end

    private

    def lock
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

    def unlock(client)
      if client.nil?
        puts "Cannot unlock, no connection to mysql."
      else
        client.query("UNLOCK TABLES")
      end
    end
  end
end
