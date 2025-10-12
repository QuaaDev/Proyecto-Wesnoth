extends Node
var tile_map : Node2D
var tile_map_hud : TileMapLayer

func dibujando_tile_map(ubicaciones : Dictionary) -> void:
	for i in ubicaciones:
		tile_map_hud.set_cell(i,3,Vector2(0,0),0)
		
func dibujando_tile_individual(ubicacion : Vector2) -> void:
	tile_map_hud.set_cell(ubicacion,3,Vector2(0,0),0)
	
func moviendo_unidad(unidad : Node2D) -> void:
	var start = unidad.coordenada_local_tilemap
	var cantidad_de_movimiento_maximo = unidad.puntos_movimiento
	var frontier = [] #Almacena las fronteras que hay que explorar
	frontier.append(start) #Donde empieza la ejecucion
	
	var reached = {} #Almacena las casillas ya exploradas
	reached[start] = 0#Almacena la cantidad de puntos de movimiento que consume
	
	while frontier.size() > 0: #Mientras existan mas fronteras:
		var current = frontier.pop_front() #Selecciona la primera frontera y la elimina del array
		print("Visitando:", current, reached[current])
		
		var distancia_actual = reached[current]#Almacena la distancia que se recorrio desde start
		
		if distancia_actual >= cantidad_de_movimiento_maximo: #Si alcanza el limite de movimiento
			continue#Omite esta ejecucion del while
		
		for next in get_neighbors(current):#Obtiene todos los vecinos de la ubicacion actual
			if not reached.has(next):#Si el nodo ya fue explorado, lo omite
				reached[next] = distancia_actual + 1#Almacena la ubicacion como ya explorada y aumenta los puntos de movimiento utilizados
				frontier.append(next)#Agrega la ubicacion como nueva frontera, para que luego se expanda en base a este
				#await get_tree().create_timer(1.0).timeout
		dibujando_tile_map(reached)
		
func get_neighbors(origen : Vector2) -> Array: #Devuelve la lista de vecinos de X tile hex
	var vecinos = []
	#even = par , odd = impar
	if int(origen.x) % 2 == 0: #Si la columna es par
		print("Columna par")
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
		print("columna impar")
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
