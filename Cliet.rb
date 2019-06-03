require 'socket'
require 'json'
require 'tk'
require 'posixpsutil'

class Nodo
    def initialize host_name, port_host
        @cliente_socket = TCPSocket.open host_name, port_host
		@cpu = 'AMD A9'
		@memory = 100 - PosixPsutil::Memory.virtual_memory.percent
		@user = "uriel"
		@rank = 0
        puts "Started node......."
		run_client
	end
	
	def update_data
		loop do 
			@memory = 100 - PosixPsutil::Memory.virtual_memory.percent
			if @cpu == 'intel i7'
				@rank = 100
			elsif @cpu == 'intel i5' || @cpu == 'AMD A9'
				@rank = 80
			elsif @cpu == 'intel i3' 
				@rank = 50
			end
			if @memory >= 80.0
				@rank += 100
			elsif @memory >= 70
				@rank += 90
			elsif @memory >= 50
				@rank += 30
			end
			information = Hash[name: @user, memory: @memory, cpu: @cpu, rank: @rank].to_json
			@cliente_socket.puts information
			sleep 1000
		end
	end

    def run_client
        begin 
			loop do
				if @cpu == 'intel i7'
					@rank = 100
				elsif @cpu == 'intel i5' || @cpu == 'AMD A9'
					@rank = 80
				elsif @cpu == 'intel i3' 
					@rank = 50
				end
				if @memory >= 80.0
					@rank += 100
				elsif @memory >= 70
					@rank += 90
				elsif @memory >= 50
					@rank += 30
				end

				information = Hash[name: @user, memory: @memory, cpu: @cpu, rank: @rank].to_json
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
