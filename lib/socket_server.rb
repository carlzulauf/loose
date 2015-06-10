class SocketServer
  attr_reader :options, :clients

  def initialize(options = {})
    @options = options
    @clients = []
  end

  def websocket_options
    {
      host: options.fetch(:host) { "0.0.0.0" },
      port: options.fetch(:port) { 4445 }
    }
  end

  def run
    EM.run do
      EM::WebSocket.run(websocket_options) do |ws|
        clients << Client.new(self, ws).register
      end
    end
    self
  end

  def self.run(options = {})
    @@current = self.new(options)
    current.run
  end

  def self.current
    @@current
  end

  class Client
    def initialize(server, socket)
      @server = server
      @socket = socket
    end

    def register
      @socket.onopen    &log_callback(:onopen)
      @socket.onclose   &log_callback(:onclose)
      @socket.onmessage &log_callback(:onmessage)
    end

    def log_callback(event)
      lambda do |*args|
        puts
        pp event: event, args: args
        puts
      end
    end
  end
end
