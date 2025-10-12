extends Node
var tile_map : Node2D
var tile_map_hud : TileMapLayer

func probando_cosas() -> void:
	tile_map_hud.set_cell(Vector2(5,5),3,Vector2(0,0),0)
	tile_map_hud.set_cell(Vector2(1,5),3,Vector2(0,0),0)
	tile_map_hud.set_cell(Vector2(2,5),3,Vector2(0,0),0)

func moviendo_unidad(unidad : Node2D) -> void:
	var start = unidad.position
	var frontier = [] 
	frontier.append(start) #Donde empieza la ejecucion
	
	var reached = {}
	reached[start] = true
	
	#while frontier.size() > 0:
	#	var current = frontier.pop_front()
	#	print("Visitando:", current)
	#	
	#	for next in get_neighbors(current):
	#		if not reached.has(next):
	#			frontier.append(next)
	#			reached[next] = true

func get_neighbors(origen : Vector2) -> Array: #Devuelve la lista de vecinos de X tile hex
	var vecinos = []
	if int(origen.x + origen.y) % 2 == 0:
		print("Columna par")
		#[[+1, +1], [+1,  0], [ 0, -1], 
	 	#[-1,  0], [-1, +1], [ 0, +1]]
		vecinos.append(Vector2(origen.x + 1 , origen.y + 1))
		vecinos.append(Vector2(origen.x + 1, origen.y))
		vecinos.append(Vector2(origen.x , origen.y - 1))
		vecinos.append(Vector2(origen.x- 1 , origen.y))
		vecinos.append(Vector2(origen.x - 1, origen.y + 1))
		vecinos.append(Vector2(origen.x , origen.y + 1))
	else:
		print("columna impar")
		#[[+1,  0], [+1, -1], [ 0, -1], 
		# [-1, -1], [-1,  0], [ 0, +1]],
		vecinos.append(Vector2(origen.x + 1 , origen.y))
		vecinos.append(Vector2(origen.x + 1 , origen.y - 1))
		vecinos.append(Vector2(origen.x , origen.y - 1))
		vecinos.append(Vector2(origen.x - 1, origen.y - 1))
		vecinos.append(Vector2(origen.x - 1, origen.y))
		vecinos.append(Vector2(origen.x , origen.y + 1))
	print(vecinos)
	return vecinos
