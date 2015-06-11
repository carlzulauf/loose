require "bundler"
Bundler.require(:default)
require 'tilt/erb'

ROOT_DIR = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift File.join(ROOT_DIR, "lib")

require 'web_server'
require 'socket_server'

SocketThread = Thread.new { SocketServer.run }

run WebServer.new
