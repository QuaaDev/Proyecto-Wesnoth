extends Node
var tile_map : Node2D
var tile_map_hud : TileMapLayer
var tile_map_base : TileMapLayer
var movimientos_disponibles : Dictionary #Almacena el resultado del algoritmo Dijkstra para su posterior uso
var movimientos_disponibles_incluyendo_ocupados : Dictionary#Almacena las posiciones descartadas por tener una unidad sobre ellas.
#patata 11/02/2026 no se prq escribi eso pero me dio risa lul
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
		#print("Error data no encontrada obtener_coste_movimiento_tile")
		return 1

func moviendo_unidad(unidad : Node2D, ubicaciones_ocupadas : Dictionary, 
dibujar_movimientos : bool) -> void:
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
		
		if distancia_actual >= cantidad_de_movimiento_maximo: #Si alcanza el limite de movimiento
			continue#Omite esta ejecucion del while
		
		for next in get_neighbors(current):#Obtiene todos los vecinos de la ubicacion actual
			var nuevo_costo = distancia_actual + obtener_coste_movimiento_tile(next)
			if (not reached.has(next) or nuevo_costo < reached[next]) and !(ubicaciones_ocupadas.has(next)):
				#(Si el nodo ya fue explorado, lo omite) AND (Si la ubicacion ya fue ocupada, la omite)
				reached[next] = nuevo_costo
				frontier.append(next)#Agrega la ubicacion como nueva frontera, para que luego se expanda en base a este
			elif (not reached.has(next) or nuevo_costo < reached[next]) and(not movimientos_disponibles_incluyendo_ocupados.has(next)): #Excepcion para la IA, almacenara las posiciones ocupadas por unidades
				#(Si el nodo ya fue explorado, lo omite) AND (si ese nodo ya fue almacenado como ocupado, lo omite)
				movimientos_disponibles_incluyendo_ocupados[next] = nuevo_costo
	if dibujar_movimientos:
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
		vecinos.append(Vector2(origen.x , origen.y - 1))#N
		vecinos.append(Vector2(origen.x + 1 , origen.y - 1))#NE
		vecinos.append(Vector2(origen.x + 1 , origen.y)) #SE
		vecinos.append(Vector2(origen.x , origen.y + 1))#S
		vecinos.append(Vector2(origen.x - 1, origen.y))#SO
		vecinos.append(Vector2(origen.x - 1, origen.y - 1))#NO
	else:
		#print("columna impar")
		#[[+1, +1], [+1,  0], [ 0, -1], 
	 	#[-1,  0], [-1, +1], [ 0, +1]]
		vecinos.append(Vector2(origen.x , origen.y - 1))#N
		vecinos.append(Vector2(origen.x + 1, origen.y)) #NE
		vecinos.append(Vector2(origen.x + 1 , origen.y + 1)) #SE
		vecinos.append(Vector2(origen.x , origen.y + 1))#S
		vecinos.append(Vector2(origen.x - 1, origen.y + 1))#SO
		vecinos.append(Vector2(origen.x- 1 , origen.y))#NO
	#print(vecinos)
	return vecinos

func obtener_vecino_mas_barato(coordenada_origen : Vector2, opcion_mas_barata_arg : int) -> Array:
	#La variable opcion_mas_barata se llama desde el exterior para mantenerla independiente y evitar bucles infinitos
	#Busca el vecino mas barato segun el coste de movimiento. Devuelve un array con coordenada mas barata y el coste de ese movimiento.
	var opcion_mas_barata = opcion_mas_barata_arg #Duplica el valor del argumento
	var coordenada_mas_barata_actual : Vector2
	var contador_seguridad := 0
	var opciones = get_neighbors(coordenada_origen)#Consulta los vecinos del tile origen
	for i in opciones:#Explora todos los posibles vecinos
		if movimientos_disponibles.has(i):#Verifica si el vecino esta dentro de los movimientos validos
			if movimientos_disponibles[i] < opcion_mas_barata:
				#Si la opcion actual consume menos movimientos que la anterior significa que es mas optima
				opcion_mas_barata = movimientos_disponibles[i] #Almacena el nuevo valor mas barato 
				coordenada_mas_barata_actual = i #Almacena temporalmente la coordenada mas barata actual
		else:
			contador_seguridad += 1
		if contador_seguridad >= 6:#Si el contador de seguridad llega a 6 significa que ningun vecino del origen es valido, por lo tanto el bucle es infinito.
			push_error("Error Rojo, Bucle infinito detectado funcion algoritmo_dijkstra.obtenervecinomasbarato, deteniendo loop")
			break
	var retorno = [coordenada_mas_barata_actual,opcion_mas_barata]
	#Envia dos return en uno
	return retorno

func limpiar_movimientos() -> void:
	movimientos_disponibles.clear()
	movimientos_disponibles_incluyendo_ocupados.clear()
#region A*
#Este algoritmo prioriza el camino mas corto entre origen y objetivo.
func algoritmo_a_estrella(origen : Vector2, destino : Vector2, ubicaciones_ocupadas : Dictionary, 
dibujar_movimientos : bool) -> void:
	limpiar_movimientos() #Limpia la anterior lista de movimientos
	var start = origen
	var frontier = [] #Almacena las fronteras que hay que explorar
	frontier.append(start) #Donde empieza la ejecucion
	var reached = {} #Almacena las casillas ya exploradas
	reached[start] = 0#Almacena la cantidad de puntos de movimiento que consume
	while frontier.size() > 0: #Mientras existan mas fronteras:
		var current = frontier.pop_front() #Selecciona la primera frontera y la elimina del array
		var distancia_actual = reached[current]#Almacena la distancia que se recorrio desde start
		for next in get_neighbors(current):#Obtiene todos los vecinos de la ubicacion actual
			var nuevo_costo = distancia_actual + obtener_coste_movimiento_tile(next)
			if (not reached.has(next) or nuevo_costo < reached[next]) and !(ubicaciones_ocupadas.has(next)):
				#(Si el nodo ya fue explorado, lo omite) AND (Si la ubicacion ya fue ocupada, la omite)
				reached[next] = nuevo_costo
				frontier.append(next)#Agrega la ubicacion como nueva frontera, para que luego se expanda en base a este
	if dibujar_movimientos:
		dibujando_tile_map(reached)
	movimientos_disponibles = reached.duplicate() #Almacena los movimientos disponibles

func oddq_to_cube(hex: Vector2i) -> Vector3i: #Convierte las coordenadas odd-q a Cube
	var x = hex.x
	var z = hex.y - (hex.x - (hex.x & 1)) / 2
	var y = -x - z
	#print(Vector3i(x, y, z),"x,y,z")
	return Vector3i(x, y, z)

func heuristica(a: Vector2i, b: Vector2i) -> int: #Devuelve la cantidad de hexagonos que hay entre el origen y el objetivo
	var ac = oddq_to_cube(a)
	var bc = oddq_to_cube(b)
	
	return (abs(ac.x - bc.x) +
			abs(ac.y - bc.y) +
			abs(ac.z - bc.z)) / 2

#endregion
