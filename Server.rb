require 'tk'
require 'socket'
require 'json'

class Nodo
    def initialize port_server
        @server_socket = TCPServer.open port_server
        @result = ' '
		@connection_details = Array.new
		@root = TkRoot.new
		@pasconections = 0
		@names_list = [:uriel, :andrea, :nacho, :carlos]
        puts "Started node......."
        run
    end

    def run_server
		myself = @self
		content = Tk::Tile::Frame.new(@root) { padding "3 3 12 12" }
		@names = @connection_details.map {|item| "#{item.keys[0]}" }
		@ips = @connection_details.map {|item| "#{item.values[0]}" }
		$names_list_variable = TkVariable.new @names
		$ips_list_variable = TkVariable.new @ips
		names_list = TkListbox.new(content) {listvariable $names_list_variable}
		ips_list = TkListbox.new(content) {listvariable $ips_list_variable}
		namelbl = Tk::Tile::Label.new(content) {text 'Nombre'}
		iplbl = Tk::Tile::Label.new(content) {text 'Ip'}
		close_conection = TkButton.new(content) { text "Cerrar conexion"; command(proc {myself.close_interface}) }
		content.grid column: 0, row: 0, sticky: 'nsew'
		namelbl.grid column: 1, row: 1, padx: 70
		close_conection.grid column: 2, row: 3, pady: 10
		names_list.grid column: 1, row: 2
		ips_list.grid column: 2, row: 2
		iplbl.grid column: 2, row: 1, padx: 70
		index = -1
        begin
			loop do 
				@client_connection = @server_socket.accept
				Thread.start(@client_connection) do |client|
					index += 1
					sock_domain, remote_port, remote_hostname, remote_id = client.peeraddr
					puts "connect to #{remote_id}"
					#listen_client_conexions client, index, remote_id
					@connection_details << Hash[@names_list[index] => remote_id]

					@names = @connection_details.map {|item| "#{item.keys[0]}" }
					@ips = @connection_details.map {|item| "#{item.values[0]}" }
					$names_list_variable.value = @names
					$ips_list_variable.value = @ips

					client.puts @connection_details 
					puts @connection_details
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
