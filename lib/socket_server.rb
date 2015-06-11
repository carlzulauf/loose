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
    # start EventMachine event loop
    EM.run do
      # start web socket server that emits web socket clients to proc
      EM::WebSocket.run(websocket_options) do |ws|
        Client.new(self, ws).register
      end
    end
    self
  end

  def self.run(options = {})
    self.new(options).run
  end

  class Client

    def initialize(server, socket)
      @server = server
      @socket = socket
    end

    def register
      @socket.onopen { @server.clients << self }
      @socket.onclose { @server.clients.delete(self) }

      # take every incoming message and broadcast to all clients
      @socket.onmessage do |message|
        @server.clients.each { |c| c.send_message(message) }
      end
      self
    end

    def send_message(message)
      @socket.send message
    end

  end
end
