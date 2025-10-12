extends Node
var tile_map : Node2D
var tile_map_hud : TileMapLayer

func probando_cosas() -> void:
	tile_map_hud.set_cell(Vector2(5,5),3,Vector2(0,0),0)
	tile_map_hud.set_cell(Vector2(1,5),3,Vector2(0,0),0)
	tile_map_hud.set_cell(Vector2(2,5),3,Vector2(0,0),0)

func moviendo_unidad(unidad : Node2D) -> void:
	var start = unidad.coordenada_local_tilemap
	var cantidad_de_movimiento_maximo = unidad.puntos_movimiento
	var frontier = [] 
	frontier.append(start) #Donde empieza la ejecucion
	
	var reached = {}
	reached[start] = 0
	
	while frontier.size() > 0:
		var current = frontier.pop_front()
		print("Visitando:", current)
		
		var distancia_actual = reached[current]
		
		if distancia_actual >= cantidad_de_movimiento_maximo:
			continue
		
		for next in get_neighbors(current):
			if not reached.has(next):
				reached[next] = distancia_actual + 1
				frontier.append(next)

func get_neighbors(origen : Vector2) -> Array: #Devuelve la lista de vecinos de X tile hex
	var vecinos = []
	if int(origen.x + origen.y) % 2 == 0:
		#print("Columna par")
		#[[+1, +1], [+1,  0], [ 0, -1], 
	 	#[-1,  0], [-1, +1], [ 0, +1]]
		vecinos.append(Vector2(origen.x + 1 , origen.y + 1))
		vecinos.append(Vector2(origen.x + 1, origen.y))
		vecinos.append(Vector2(origen.x , origen.y - 1))
		vecinos.append(Vector2(origen.x- 1 , origen.y))
		vecinos.append(Vector2(origen.x - 1, origen.y + 1))
		vecinos.append(Vector2(origen.x , origen.y + 1))
	else:
		#print("columna impar")
		#[[+1,  0], [+1, -1], [ 0, -1], 
		# [-1, -1], [-1,  0], [ 0, +1]],
		vecinos.append(Vector2(origen.x + 1 , origen.y))
		vecinos.append(Vector2(origen.x + 1 , origen.y - 1))
		vecinos.append(Vector2(origen.x , origen.y - 1))
		vecinos.append(Vector2(origen.x - 1, origen.y - 1))
		vecinos.append(Vector2(origen.x - 1, origen.y))
		vecinos.append(Vector2(origen.x , origen.y + 1))
	#print(vecinos)
	return vecinos
