require 'socket'
require 'json'
require 'tk'
require 'posixpsutil'

class Nodo
    def initialize host_name, port_host
        @cliente_socket = TCPSocket.open host_name, port_host
		@cpu = 'AMD E9'
		@memory = PosixPsutil::Memory.virtual_memory.total / 1e+9
		@user = PosixPsutil::System.users[1].name
		puts @memory
        puts "Started node......."
		run_client
    end

    def run_client
        begin 
			loop do
				#response = JSON.parse(@cliente_socket.gets)
				information = Hash[name: @user, memory: @memory, cpu: @cpu].to_json
				@cliente_socket.puts information
				if gets.to_s.chomp == 'q'
					break
				end

			end
        rescue => e
            puts e.message
            @cliente_socket.close
        ensure
            @cliente_socket.close
        end

    end
end

Nodo.new 'localhost', 5434
