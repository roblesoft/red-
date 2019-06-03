require 'tk'

root = TkRoot.new

content = Tk::Tile::Frame.new(root) { padding "3 3 12 12" }

$data = [{uriel: "198.160.1.90"},{andrea: "198.160.1.92"}, { nacho: "198.160.1.93"}, { Carlos: "198.160.1.94"}]

$names = $data.map {|item| "#{item.keys[0]}" }
$ips = $data.map {|item| "#{item.values[0]}" }

$names_list_variable = TkVariable.new $names
$ips_list_variable = TkVariable.new $ips

names_list = TkListbox.new(content) {listvariable $names_list_variable}
ips_list = TkListbox.new(content) {listvariable $ips_list_variable}
namelbl = Tk::Tile::Label.new(content) {text 'Nombre'}
iplbl = Tk::Tile::Label.new(content) {text 'Ip'}
close_conection = Tk::Tile::Button.new(content) {text "Cerrar conexion"}

content.grid column: 0, row: 0, sticky: 'nsew'
namelbl.grid column: 1, row: 1, padx: 70
close_conection.grid column: 2, row: 3, pady: 10
names_list.grid column: 1, row: 2
ips_list.grid column: 2, row: 2
iplbl.grid column: 2, row: 1, padx: 70

Tk.mainloop
