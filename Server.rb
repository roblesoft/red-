require 'tk'
require 'socket'
require 'json'

class Nodo
    def initialize port_server
        @server_socket = TCPServer.open port_server
        @result = ' '
		@connection_details = Array.new
		@connection_info = Hash.new
		@connected_clients = Hash.new
		@connection_info[:server] = @server_socket
		@connection_info[:clients] = @connected_clients
		@root = TkRoot.new
		@self = self
		@names = []
		@ips = []
		@cpus = []
		@ranks = []
        puts "Started node......."
        run
    end

    def run_server
		myself = @self
		content = Tk::Tile::Frame.new(@root) { padding "3 3 12 12" }
		@names = @connection_details.map {|item| item['name'] }
		@ips = @connection_details.map {|item| item['ip'] }
		@rams = @connection_details.map {|item| item['ram']} 
		@cpus = @connection_details.map {|item| item['cpu']}
		@ranks = @connection_details.map {|item| item['cpu']}


		$names_list_variable = TkVariable.new @names
		$ips_list_variable = TkVariable.new @ips
		$rams_list_variable = TkVariable.new @rams
		$cpus_list_variable = TkVariable.new @cpus
		$ranks_list_variable = TkVariable.new @rank

		names_list = TkListbox.new(content) {listvariable $names_list_variable}
		ips_list = TkListbox.new(content) {listvariable $ips_list_variable}
		ram_list = TkListbox.new(content) {listvariable $rams_list_variable}
		cpu_list = TkListbox.new(content) {listvariable $cpus_list_variable}
		rank_list = TkListbox.new(content) {listvariable $ranks_list_variable}

		namelbl = Tk::Tile::Label.new(content) {text 'Nombre'}
		iplbl = Tk::Tile::Label.new(content) {text 'Ip'}
		ramlbl = Tk::Tile::Label.new(content) {text 'Ram'}
		cpulbl = Tk::Tile::Label.new(content) {text 'Cpu'}
		ranklbl = Tk::Tile::Label.new(content) {text 'Ranking'}
		close_conection = TkButton.new(content) { text "Cerrar conexion"; command(proc {myself.close_interface}) }

		content.grid column: 0, row: 0, sticky: 'nsew'
		namelbl.grid column: 1, row: 1
		ramlbl.grid column: 3, row: 1
		cpulbl.grid column: 4, row: 1
		ranklbl.grid column: 5, row: 1
		close_conection.grid column: 5, row: 3, pady: 10
		names_list.grid column: 1, row: 2
		ips_list.grid column: 2, row: 2
		cpu_list.grid column: 4, row: 2
		ram_list.grid column: 3, row: 2
		rank_list.grid column: 5, row: 2
		iplbl.grid column: 2, row: 1

		def update_data name, ips, cpus, rams

			$names_list_variable.value = name
			$ips_list_variable.value = ips
			$cpus_list_variable.value = cpus
			$rams_list_variable.value = rams

		end

		
        begin
			loop do 
				@client_connection = @server_socket.accept
				Thread.start(@client_connection) do |client|
					sock_domain, remote_port, remote_hostname, remote_id = client.peeraddr
					puts "connect to #{remote_id}"
					response = JSON.parse(client.gets)
					puts response
					@connection_details << response

					@names = @connection_details.map {|item| item['name'] }
					@ips = @connection_details.map {|item| remote_id }
					@rams = @connection_details.map {|item| item['memory']} 
					@cpus = @connection_details.map {|item| item['cpu']}

					update_data @names, @ips, @cpus, @rams

				end
			end.join
        rescue => e
            puts e.message
            @client_connection.close
        ensure
            @client_connection.close
        end
    end

	def close_interface
		puts "close conexion"
		@cliente_connection.close
		@root.destroy()
	end

	def user_interface
		Tk.mainloop
	end

    def run
        server = Thread.new do
            run_server
        end
		gui = Thread.new do 
			user_interface
		end
        server.join
		gui.join
    end
end

Nodo.new 5434
