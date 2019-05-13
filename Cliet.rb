require 'socket'
require 'json'
require 'tk'

class Nodo
    def initialize host_name, port_host
        @cliente_socket = TCPSocket.open host_name, port_host
        @data = []
		@self = self
        puts "Started node......."
		run
    end

    def run_client
        begin 
			loop do
				#response = JSON.parse(@cliente_socket.gets)
				response = @cliente_socket.gets
				puts response
				@data << response
			end
        rescue => e
            puts e.message
            @cliente_socket.close
        ensure
            @cliente_socket.close
        end

    end

	def close_interface
		puts "close conexion"
		@cliente_socket.close
		@root.destroy()
	end


    def run
        client = Thread.new do 
            run_client
        end
		client.join
    end

end

Nodo.new 'localhost', 5434
