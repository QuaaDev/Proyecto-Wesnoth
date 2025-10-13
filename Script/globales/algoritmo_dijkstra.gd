extends Node
var tile_map : Node2D
var tile_map_hud : TileMapLayer
var tile_map_base : TileMapLayer
var movimientos_disponibles : Dictionary #Stores the result of the Dijkstra algorithm for later use

func dibujando_tile_map(ubicaciones : Dictionary) -> void:
	for i in ubicaciones:
		tile_map_hud.set_cell(i,3,Vector2(0,0),0)
		
func dibujando_tile_individual(ubicacion : Vector2) -> void:
	tile_map_hud.set_cell(ubicacion,3,Vector2(0,0),0)
	
func obtener_coste_movimiento_tile(coordenadas : Vector2) -> int: #Gets the movement cost of each tile
	var data = tile_map_base.get_cell_tile_data(coordenadas)
	if data:
		return data.get_custom_data("resistencia_movimiento")
	else:
		print("Error data not found  obtener_coste_movimiento_tile")
		return 1

func moviendo_unidad(unidad : Node2D) -> void:
	limpiar_movimientos() #Clear the previous move list
	var start = unidad.coordenada_local_tilemap
	var cantidad_de_movimiento_maximo = unidad.puntos_movimiento
	var frontier = [] #Store the frontiers to be explored
	frontier.append(start) #Where the execution begins
	var reached = {} #Stores already explored squares
	reached[start] = 0##Stores the amount of movement points it consumes
	while frontier.size() > 0: #As long as there are more borders:
		var current = frontier.pop_front() #Selects the first border and removes it from the array
		
		var distancia_actual = reached[current]#Stores the distance traveled since start
		
		if distancia_actual >= cantidad_de_movimiento_maximo: #If it reach the movement limit
			continue#Skip this while execution
		
		for next in get_neighbors(current):#Get all neighbors of the current location
			var nuevo_costo = distancia_actual + obtener_coste_movimiento_tile(next)
			if not reached.has(next) or nuevo_costo < reached[next]:#If the node has already been explored OR the current movement value is less than the one already stored:
				reached[next] = nuevo_costo
				frontier.append(next)#Add the location as a new border, so that it will then expand based on this
	dibujando_tile_map(reached)
	movimientos_disponibles = reached.duplicate() #Stores available moves
		
func get_neighbors(origen : Vector2) -> Array: #Devuelve la lista de vecinos de X tile hex
	#Modelo odd-q
	var vecinos = []
	#even = par , odd = impar
	if int(origen.x) % 2 == 0: #Si la columna es par
		#print("Columna par")
		#-------------------
		#[[+1,  0], [+1, -1], [ 0, -1], 
		# [-1, -1], [-1,  0], [ 0, +1]],
		vecinos.append(Vector2(origen.x + 1 , origen.y))
		vecinos.append(Vector2(origen.x + 1 , origen.y - 1))
		vecinos.append(Vector2(origen.x , origen.y - 1))
		vecinos.append(Vector2(origen.x - 1, origen.y - 1))
		vecinos.append(Vector2(origen.x - 1, origen.y))
		vecinos.append(Vector2(origen.x , origen.y + 1))
	else:
		#print("columna impar")
		#[[+1, +1], [+1,  0], [ 0, -1], 
	 	#[-1,  0], [-1, +1], [ 0, +1]]
		vecinos.append(Vector2(origen.x + 1 , origen.y + 1))
		vecinos.append(Vector2(origen.x + 1, origen.y))
		vecinos.append(Vector2(origen.x , origen.y - 1))
		vecinos.append(Vector2(origen.x- 1 , origen.y))
		vecinos.append(Vector2(origen.x - 1, origen.y + 1))
		vecinos.append(Vector2(origen.x , origen.y + 1))
	#print(vecinos)
	return vecinos

func limpiar_movimientos() -> void:
	movimientos_disponibles.clear()
