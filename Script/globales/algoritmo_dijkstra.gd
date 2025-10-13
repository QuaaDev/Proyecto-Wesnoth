extends Node
var tile_map : Node2D
var tile_map_hud : TileMapLayer
var tile_map_base : TileMapLayer
var movimientos_disponibles : Dictionary #Almacena el resultado del algoritmo Dijkstra para su posterior uso

func dibujando_tile_map(ubicaciones : Dictionary) -> void:
	for i in ubicaciones:
		tile_map_hud.set_cell(i,3,Vector2(0,0),0)
		
func dibujando_tile_individual(ubicacion : Vector2) -> void:
	tile_map_hud.set_cell(ubicacion,3,Vector2(0,0),0)
	
func obtener_coste_movimiento_tile(coordenadas : Vector2) -> int: #Obtiene el coste de movimiento de cada tile
	var data = tile_map_base.get_cell_tile_data(coordenadas)
	if data:
		return data.get_custom_data("resistencia_movimiento")
	else:
		print("Error data no encontrada obtener_coste_movimiento_tile")
		return 1

func moviendo_unidad(unidad : Node2D) -> void:
	limpiar_movimientos() #Limpia la anterior lista de movimientos
	var start = unidad.coordenada_local_tilemap
	var cantidad_de_movimiento_maximo = unidad.puntos_movimiento
	var frontier = [] #Almacena las fronteras que hay que explorar
	frontier.append(start) #Donde empieza la ejecucion
	
	var reached = {} #Almacena las casillas ya exploradas
	reached[start] = 0#Almacena la cantidad de puntos de movimiento que consume
	
	while frontier.size() > 0: #Mientras existan mas fronteras:
		var current = frontier.pop_front() #Selecciona la primera frontera y la elimina del array
		
		var distancia_actual = reached[current]#Almacena la distancia que se recorrio desde start
		
		if distancia_actual > cantidad_de_movimiento_maximo: #Si alcanza el limite de movimiento
			continue#Omite esta ejecucion del while
		
		for next in get_neighbors(current):#Obtiene todos los vecinos de la ubicacion actual
			if not reached.has(next):#Si el nodo ya fue explorado, lo omite
				reached[next] = distancia_actual + obtener_coste_movimiento_tile(next) #Obtiene el coste de movimiento del siguiente tile y aumenta la cantidad de movimientos usados
				frontier.append(next)#Agrega la ubicacion como nueva frontera, para que luego se expanda en base a este
	dibujando_tile_map(reached)
	movimientos_disponibles = reached.duplicate() #Almacena los movimientos disponibles
		
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
