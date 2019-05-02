require 'socket'
require 'json'
require 'Objspace'

class Nodo
    def initialize port_server
        @server_socket = TCPServer.open port_server
        @result = ' '
		@connection_details = Array.new
        puts "Started node......."
        run
    end

    def run_server
        begin
			loop do 
				@client_connection = @server_socket.accept
				Thread.start(@client_connection) do |client|
					sock_domain, remote_port, remote_hostname, remote_id = client.peeraddr
					puts "connect to #{remote_id}"
					@connection_details << Hash[:"#{remote_hostname.to_sym}" => remote_id]
					puts @connection_details
					client.write @connection_details.first, 10
				end
			end.join
        rescue => e
            puts e.message
            @client_connection.close
        ensure
            @client_connection.close
        end
    end

    def run
        server = Thread.new do
            run_server
        end
        server.join
    end
end

server = Nodo.new 5434
