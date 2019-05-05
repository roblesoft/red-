require 'socket'
require 'json'

class Nodo
    def initialize port_server
        @server_socket = TCPServer.open port_server
        @result = ' '
		@connection_details = Array.new

		@pasconections = 0
		@names = [:uriel, :andrea, :nacho, :carlos]
        puts "Started node......."
        run
    end

    def run_server
		index = -1
        begin
			loop do 
				@client_connection = @server_socket.accept
				Thread.start(@client_connection) do |client|
					index += 1
					sock_domain, remote_port, remote_hostname, remote_id = client.peeraddr
					puts "connect to #{remote_id}"
					#listen_client_conexions client, index, remote_id
					@connection_details << Hash[@names[index] => remote_id].to_json
					client.puts @connection_details 
				end
			end.join
        rescue => e
            puts e.message
            @client_connection.close
        ensure
            @client_connection.close
        end
    end

	def listen_client_conexions(client, index, remote_id)
		loop do 
			client.puts Hash[@names[index] => remote_id].to_json
		end
	end

    def run
        server = Thread.new do
            run_server
        end
        server.join
    end
end

Nodo.new 5434
