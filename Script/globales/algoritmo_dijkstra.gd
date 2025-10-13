extends Node
var tile_map : Node2D
var tile_map_hud : TileMapLayer
var tile_map_base : TileMapLayer
var movimientos_disponibles : Dictionary #Almacena el resultado del algoritmo Dijkstra para su posterior uso
var frontier: Array = [] #Almacena las fronteras que hay que explorar

func heap_push(value: Dictionary) -> void:
	# Inserta un valor en el heap y lo reordena hacia arriba
	frontier.append(value)
	var index := frontier.size() - 1
	while index > 0:
		var parent := (index - 1) / 2
		if frontier[index]["priority"] < frontier[parent]["priority"]:
			var temp = frontier[index]
			frontier[index] = frontier[parent]
			frontier[parent] = temp
			index = parent
		else:
			break
			
func heap_pop() -> Dictionary:
	# Extrae el elemento con menor prioridad
	if frontier.is_empty():
		return {}
	var root: Dictionary = frontier[0]
	frontier[0] = frontier[frontier.size() - 1]
	frontier.pop_back()
	var index := 0

	while true:
		var left := 2 * index + 1
		var right := 2 * index + 2
		var smallest := index

		if left < frontier.size() and frontier[left]["priority"] < frontier[smallest]["priority"]:
			smallest = left
		if right < frontier.size() and frontier[right]["priority"] < frontier[smallest]["priority"]:
			smallest = right

		if smallest != index:
			var temp = frontier[index]
			frontier[index] = frontier[smallest]
			frontier[smallest] = temp
			index = smallest
		else:
			break
	return root
	
func heap_is_empty() -> bool:
	return frontier.is_empty()
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
	frontier.clear()
	var start = unidad.coordenada_local_tilemap
	var cantidad_de_movimiento_maximo = unidad.puntos_movimiento
	heap_push({
		"pos": start,
		"priority": 0
	})
	var reached = {} #Almacena las casillas ya exploradas
	reached[start] = 0#Almacena la cantidad de puntos de movimiento que consume
	
	while not heap_is_empty(): #Mientras existan mas fronteras:
		var current_data: Dictionary = heap_pop()
		var current = current_data["pos"] #Selecciona la primera frontera y la elimina del array
		
		var distancia_actual = current_data["priority"]#Almacena la distancia que se recorrio desde start
		
		if reached.has(current) and distancia_actual != reached[current]:
			continue
		if distancia_actual > cantidad_de_movimiento_maximo: #Si alcanza el limite de movimiento
			continue#Omite esta ejecucion del while
		
		for next in get_neighbors(current):
			var nuevo_costo = distancia_actual + obtener_coste_movimiento_tile(next)
			if nuevo_costo <= cantidad_de_movimiento_maximo:
				if not reached.has(next) or nuevo_costo < reached[next]:
					reached[next] = nuevo_costo
					heap_push({
						"pos": next,
						"priority": nuevo_costo
					})
					#await get_tree().create_timer(1).timeout
					dibujando_tile_individual(next)
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
