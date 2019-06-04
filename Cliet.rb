require 'socket'
require 'json'
require 'tk'
require 'posixpsutil'

class Nodo
    def initialize host_name, port_host
        @cliente_socket = TCPSocket.open host_name, port_host
		@cpu = 'intel i3'
		@ram_free = (100 - PosixPsutil::Memory.virtual_memory.percent).round 2
		@ram = (PosixPsutil::Memory.virtual_memory.total / 1e+9).round 2
		@cpu_percent = (100 - PosixPsutil::CPU.cpu_percent).round 2
		@memory = (PosixPsutil::Disks.disk_usage("/").free / 1e+9).round 2
		@user = "carlos"
		@rank = 0
        puts "Started node......."
		run_client
	end
	
	def update_data
		loop do 
			@ram_free = (100 - PosixPsutil::Memory.virtual_memory.percent).round 2
			@cpu_percent = (100 - PosixPsutil::CPU.cpu_percent).round 2
			if @cpu == 'intel i7'
				@multiplo = 15
				@rank = 100 * @multiplo
			elsif @cpu == 'intel i5' || @cpu == 'AMD A9'
				@multiplo = 10
				@rank = 80 * @multiplo
			elsif @cpu == 'intel i3' 
				@multiplo = 8
				@rank = 50 * @multiplo
			end
			if @ram >= 11.0
				@multiplo += 10
				@rank += 100 * @multiplo
			elsif @ram >= 7.0
				@multiplo += 7
				@rank += 90 * @multiplo
			elsif @ram >= 4.0
				@multiplo += 4
				@rank += 30 * @multiplo
			end
			if @ram_free >= 80.0
				@rank += 50 * @multiplo
			elsif @ram_free >= 70.0
				@rank += 40 * @multiplo
			elsif @ram_free >= 60.0
				@rank += 30 * @multiplo
			elsif @ram_free >= 40
				@rank += 20 * @multiplo
			end
			if @cpu_percent >= 80.0
				@rank += 50 * @multiplo
			elsif @cpu_percent >= 70.0
				@rank += 40 * @multiplo
			elsif @cpu_percent >= 60.0
				@rank += 30 * @multiplo
			elsif @cpu_percent >= 40
				@rank += 20 * @multiplo
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
					@multiplo = 15
					@rank = 100 * @multiplo
				elsif @cpu == 'intel i5' || @cpu == 'AMD A9'
					@multiplo = 10
					@rank = 80 * @multiplo
				elsif @cpu == 'intel i3' 
					@multiplo = 8
					@rank = 50 * @multiplo
				end
				if @ram >= 11.0
					@multiplo += 10
					@rank += 100 * @multiplo
				elsif @ram >= 7.0
					@multiplo += 7
					@rank += 90 * @multiplo
				elsif @ram >= 4.0
					@multiplo += 4
					@rank += 30 * @multiplo
				end
				if @ram_free >= 80.0
					@rank += 50 * @multiplo
				elsif @ram_free >= 70.0
					@rank += 40 * @multiplo
				elsif @ram_free >= 60.0
					@rank += 30 * @multiplo
				elsif @ram_free >= 40
					@rank += 20 * @multiplo
				end
				if @cpu_percent >= 80.0
					@rank += 50 * @multiplo
				elsif @cpu_percent >= 70.0
					@rank += 40 * @multiplo
				elsif @cpu_percent >= 60.0
					@rank += 30 * @multiplo
				elsif @cpu_percent >= 40
					@rank += 20 * @multiplo
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
				Thread.start do 
					loop do 
						if gets.to_s.chomp == 's'
							request = 'Ejecutando comando'
							request = Hash[n: request].to_json
							@cliente_socket.puts request
						end
					end
				end
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

Nodo.new 'localhost', 5434
#Nodo.new '192.168.15.3', 5434
