require 'socket'
require 'json'
require 'tk'
require 'posixpsutil'
require_relative 'colorize'

class Client
    def initialize host_name, port_host
        @cliente_socket = TCPSocket.open host_name, port_host
		@cpu = 'RYZEN 3'
		@ram_free = (100 - PosixPsutil::Memory.virtual_memory.percent).round 2
		@ram = (PosixPsutil::Memory.virtual_memory.total / 1e+9).round 2
		@cpu_percent = (100 - PosixPsutil::CPU.cpu_percent).round 2
		@memory = (PosixPsutil::Disks.disk_usage("/").free / 1e+9).round 2
		@user = "carlos"
		@rank = 0
        puts "Started Client node".dark_cyan.bold
		run_client
	end
	
	def update_data
		loop do 
			@ram_free = (100 - PosixPsutil::Memory.virtual_memory.percent).round 2
			@cpu_percent = (100 - PosixPsutil::CPU.cpu_percent).round 2
			@rank = 0
			if @ram_free >= 85.0
				@rank += 80 * @multiplo
			elsif @ram_free >= 80.0
				@rank += 75 * @multiplo
			elsif @ram_free >= 75.0
				@rank += 70 * @multiplo
			elsif @ram_free >= 70.0
				@rank += 65 * @multiplo
			elsif @ram_free >= 65.0
				@rank += 60 * @multiplo
			elsif @ram_free >= 60.0
				@rank += 55 * @multiplo
			elsif @ram_free >= 55.0
				@rank += 50 * @multiplo
			elsif @ram_free >= 50.0
				@rank += 45 * @multiplo
			elsif @ram_free >= 45.0
				@rank += 40 * @multiplo
			elsif @ram_free >= 40.0
				@rank += 35 * @multiplo
			elsif @ram_free >= 35.0
				@rank += 30 * @multiplo
			elsif @ram_free >= 30.0
				@rank += 25 * @multiplo
			elsif @ram_free >= 25.0
				@rank += 20 * @multiplo
			elsif @ram_free >= 20.0
				@rank += 15 * @multiplo
			elsif @ram_free >= 15.0
				@rank += 10 * @multiplo
			elsif @ram_free >=10.0
				@rank += 5 * @multiplo
			end
			if @cpu_percent >= 80.0
				@rank += 70 * @multiplo
			elsif @cpu_percent >= 70.0
				@rank += 60 * @multiplo
			elsif @cpu_percent >= 60.0
				@rank += 60 * @multiplo
			elsif @cpu_percent >= 50.0
				@rank += 50 * @multiplo
			elsif @cpu_percent >= 40.0
				@rank += 40 * @multiplo
			elsif @cpu_percent >= 30.0
				@rank += 30 * @multiplo
			elsif @cpu_percent >= 20.0
				@rank += 20 * @multiplo
			elsif @cpu_percent >= 20.0
				@rank += 10 * @multiplo
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
				elsif @cpu == 'intel i5' || @cpu == 'AMD A9'
					@multiplo = 10
				elsif @cpu == 'intel i3' || @cpu == 'RYZEN 3'
					@multiplo = 8
				end
				if @ram >= 11.0
					@multiplo += 15
				elsif @ram >= 7.0
					@multiplo += 10
				elsif @ram >= 3.0
					@multiplo += 8
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

#Client.new 'localhost', 5434
#Nodo.new '192.168.15.3', 5434
