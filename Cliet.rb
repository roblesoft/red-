require 'socket'
require 'json'
require 'tk'
require 'posixpsutil'

class Nodo
    def initialize host_name, port_host
        @cliente_socket = TCPSocket.open host_name, port_host
		@cpu = 'AMD A9'
		@ram_free = (100 - PosixPsutil::Memory.virtual_memory.percent).round 2
		@ram = (PosixPsutil::Memory.virtual_memory.total / 1e+9).round 2
		@cpu_percent = (100 - PosixPsutil::CPU.cpu_percent).round 2
		@memory = (PosixPsutil::Disks.disk_usage("/").free / 1e+9).round 2
		@user = "Roblesoft"
		@rank = 0
        puts "Started node......."
		run_client
	end
	
	def update_data
		loop do 
			@ram_free = (100 - PosixPsutil::Memory.virtual_memory.percent).round 2
			@cpu_percent = (100 - PosixPsutil::CPU.cpu_percent).round 2
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
			information = Hash[name: @user,
								ram_free: @ram_free,
								cpu: @cpu, 
								rank: @rank,
								ram: @ram,
								memory: @memory,
								cpu_percent: @cpu_percent
							].to_json
			@cliente_socket.puts information
			sleep 1
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

				information = Hash[name: @user,
								   ram_free: @ram_free,
								   cpu: @cpu, 
								   rank: @rank,
								   ram: @ram,
								   memory: @memory,
								   cpu_percent: @cpu_percent
								].to_json
				@cliente_socket.puts information
				update_data
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

Nodo.new '192.168.1.73', 5434
