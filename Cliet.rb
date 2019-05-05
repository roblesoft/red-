require 'socket'
require 'json'
require 'tk'

class Nodo
    def initialize host_name, port_host
        @cliente_socket = TCPSocket.open host_name, port_host
        @data = []
		@unconect = Queue.new
		@root = TkRoot.new
		@self = self
        puts "Started node......."
		run
    end

    def run_client
        begin 
			while @unconect.empty?
				response = JSON.parse(@cliente_socket.gets)
				puts response
				@data << response
			end
			puts "close conexion"
            @cliente_socket.close
        rescue => e
            puts e.message
            @cliente_socket.close
        ensure
            @cliente_socket.close
        end

    end

	def close_interface
		@unconect << false
		puts @unconect.empty?
		@root.destroy()
	end

	def user_interface
		myself = @self
		content = Tk::Tile::Frame.new(@root) { padding "3 3 12 12" }
		$names = @data.map {|item| "#{item.keys[0]}" }
		$ips = @data.map {|item| "#{item.values[0]}" }
		$names_list_variable = TkVariable.new $names
		$ips_list_variable = TkVariable.new $ips
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
		Tk.mainloop
	end

    def run
        client = Thread.new do 
            run_client
        end
		gui = Thread.new do 
			user_interface
		end
		gui.join
    end

end

Nodo.new 'localhost', 5434
