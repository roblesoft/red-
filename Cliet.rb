require 'socket'

class Nodo
    def initialize host_name, port_host
        @cliente_socket = TCPSocket.open host_name, port_host
        @result = ' '
        puts "Started node......."
        run
    end

    def run_client
        begin 
			loop do 
                response = @cliente_socket.read 10 
				puts response
            end
            @cliente_socket.close
        rescue => e
            puts e.message
            @cliente_socket.close
        ensure
            @cliente_socket.close
        end
    end

    def run
        client = Thread.new do 
            run_client
        end
        client.join
    end
end

server = Nodo.new 'localhost', 5434
