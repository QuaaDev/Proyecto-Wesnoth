extends Node
var mouse_sobre_unidad : Node2D
var unidad_a_mover : Node2D
@onready var tile_map: Node2D = $TileMap
@onready var label_unidad_moviendose: Label = $VBoxContainer/nombre_unidad_moviendose

var ubicaciones_ocupadas = {} #Diccionario que almacena las ubicaciones ocupadas junto a sus unidades

func _ready() -> void:
	for i in get_children():
		if i.name.contains("Unidad"):
			ubicaciones_ocupadas[i.coordenada_local_tilemap] = i
	print(ubicaciones_ocupadas)

func _input(event):
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT: #Si se apreta el mouse izq
				if event.pressed:
					if mouse_sobre_unidad != null and unidad_a_mover == null:
						#If el mouse esta sobre una unidad AND no hay unidad para mover:
						#Se selecciona la unidad a interactuar
						unidad_a_mover = mouse_sobre_unidad
						unidad_a_mover.siendo_movido()
						print("Almaceno unidad")
						label_unidad_moviendose.text = unidad_a_mover.name
						AlgoritmoDijkstra.moviendo_unidad(unidad_a_mover)
					elif mouse_sobre_unidad != unidad_a_mover and unidad_a_mover != null and verificar_si_coordenadas_estan_libres():
						#If La unidad a mover es diferente a la unidad que esta debajo del mouse AND unidad a mover tiene algun valor AND las coordenadas estan libres:
						#Se selecciona la casilla a moverse
						if  AlgoritmoDijkstra.movimientos_disponibles.has(tile_map.coordenada_global_del_mouse_a_tilemap()):
							#If el tile al que intento mover ESTA DENTRO del diccionario de movimientos:
							print("muevo unidad a espacio vacio")
							unidad_a_mover.ya_no_me_mueven()
							mover_unidad(unidad_a_mover)
							label_unidad_moviendose.text = "null"
							unidad_a_mover = null #<--- ultimo en ejecutar
						else:
							print("Cancelo movimiento por intentar moverme fuera del rango")
							unidad_a_mover.ya_no_me_mueven()
							label_unidad_moviendose.text = "null"
							unidad_a_mover = null
						tile_map.limpiar_tiles_movimiento(AlgoritmoDijkstra.movimientos_disponibles)
					elif mouse_sobre_unidad != unidad_a_mover and unidad_a_mover != null and !verificar_si_coordenadas_estan_libres():
						#If La unidad a mover es diferente a la unidad que esta debajo del mouse AND unidad a mover tiene algun valor AND las coordenadas estan ocupadas:
						if verificar_si_son_aliados():
							#Si son aliados, no ataca
							print("Son aliadas las unidades, no puedes mover aqui")
						else:
							if  AlgoritmoDijkstra.movimientos_disponibles.has(tile_map.coordenada_global_del_mouse_a_tilemap()):#Verifica si es un movimiento valido
								#Si son enemigos, lo ataca >:)
								print("Te ataco!")
								ubicaciones_ocupadas[mouse_sobre_unidad.get_coordenada_local_tilemap()].morir()
								ubicaciones_ocupadas.erase(mouse_sobre_unidad) #Elimina la unidad que esta sobre el mouse
								mover_unidad(unidad_a_mover)
								print("debug")
								unidad_a_mover.ya_no_me_mueven()
								label_unidad_moviendose.text = "null"
								unidad_a_mover = null#<--- ultimo en ejecutar
							else:
								print("Cancelo movimiento por intentar moverme fuera del rango(version ataque)")
								unidad_a_mover.ya_no_me_mueven()
								label_unidad_moviendose.text = "null"
								unidad_a_mover = null
							tile_map.limpiar_tiles_movimiento(AlgoritmoDijkstra.movimientos_disponibles)
						pass
					elif mouse_sobre_unidad != null and mouse_sobre_unidad == unidad_a_mover:
						#If el mouse esta arriba de una unidad AND la unidad es la propia unidad que se mueve:
						#Se cancela el movimiento
						print("Cancelo movimiento")
						unidad_a_mover.ya_no_me_mueven()
						label_unidad_moviendose.text = "null"
						unidad_a_mover = null
						tile_map.limpiar_tiles_movimiento(AlgoritmoDijkstra.movimientos_disponibles)
					else:
						#Error
						print("Click Izquierdo condicion no reconocida, valores: ")
						
func mover_unidad(unidad : Node2D):
	#AlgoritmoDijkstra.movimientos_disponibles
	var coordenadas_mouse = tile_map.coordenada_global_del_mouse_a_tilemap()
	ubicaciones_ocupadas.erase(unidad.get_coordenada_local_tilemap()) #Borra su anterior posicion ocupada del diccionario
	unidad.coordenada_local_tilemap = coordenadas_mouse #Actualiza la informacion q tiene la unidad
	ubicaciones_ocupadas[unidad.coordenada_local_tilemap] = unidad #Actualiza la informacion del diccionario
	#--------------obtener las coordenadas para el camino--------
	var coordenada_mas_barata_actual : Vector2
	var opcion_mas_barata := 100 
	var camino_a_seguir = [] #Almacena las coordenadas en orden del camino de destino -> origen
	var interruptor_while := true
	var coordenada_origen = coordenadas_mouse #El origen es desde la posicion que se calcula los tiles vecinos
	camino_a_seguir.append(coordenada_origen)#Agrega el destino final al array
	while interruptor_while: #Mientras el interruptor sea verdadero
		var contador_seguridad := 0
		var opciones = AlgoritmoDijkstra.get_neighbors(coordenada_origen)#Consulta los vecinos del tile origen
		for i in opciones:#Explora todos los posibles vecinos
			if AlgoritmoDijkstra.movimientos_disponibles.has(i):#Verifica si el vecino esta dentro de los movimientos validos
				if AlgoritmoDijkstra.movimientos_disponibles[i] < opcion_mas_barata:
					#Si la opcion actual consume menos movimientos que la anterior significa que es mas optima
					opcion_mas_barata = AlgoritmoDijkstra.movimientos_disponibles[i] #Almacena el nuevo valor mas barato 
					coordenada_mas_barata_actual = i #Almacena temporalmente la coordenada mas barata actual
			else:
				contador_seguridad += 1
				#print(i , "Opcion no esta dentro de movimientos validos")
				pass
		#print(AlgoritmoDijkstra.movimientos_disponibles[coordenada_mas_barata_actual], coordenada_mas_barata_actual)
		if contador_seguridad >= 6:#Si el contador de seguridad llega a 6 significa que ningun vecino del origen es valido, por lo tanto el bucle es infinito.
			print("Error Rojo, Bucle infinito detectado funcion administrador_mundo.mover_unidad(), deteniendo loop")
			break
		camino_a_seguir.append(coordenada_mas_barata_actual)#Luego de explorar todas las opciones, almacena la que fue mas barato
		coordenada_origen = coordenada_mas_barata_actual#Actualiza la coordenada origen para la siguiente ejecucion
		if opcion_mas_barata <= 0:#Si el valor es 0 o menos, significa que se llego al final del recorrido
			interruptor_while = false#Apaga el while
	#--------actualiza la posicion de la unidad----------
	#unidad.position = nueva_posicion_unidad #Mueve a la unidad
	camino_a_seguir.reverse() #Invierte el orden del array
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	for i in camino_a_seguir:
		var new_position = tile_map.map_to_local(i)
		tween.tween_property(unidad,"position",new_position, .7)
	#Objeto a aplicar / propiedad a editar / ubicacion objetivo / velocidad de la animacion
	print(camino_a_seguir)
	#print(ubicaciones_ocupadas)
func verificar_si_son_aliados() -> bool:
	#Si son aliados devuelve true
	if mouse_sobre_unidad.equipo == unidad_a_mover.equipo:
		return true
	else: 
		return false
	
func verificar_si_coordenadas_estan_libres() -> bool:
	var coordenadas_mouse = tile_map.coordenada_global_del_mouse_a_tilemap() #Coordenada del tilemap
	if ubicaciones_ocupadas.has(coordenadas_mouse): #Verifica si la ubicacion esta dentro del diccionario
		print("Posicion ocupada por " + ubicaciones_ocupadas[coordenadas_mouse].name)
		return false
	else:
		print("Devuelvo true")
		return true
	
func obtener_unidad_bajo_mouse(unidad : Node2D) -> void: #Almacena referencia a la unidad bajo el mouse
	mouse_sobre_unidad = unidad
	#print("entro")
	
func limpiar_unidad_bajo_mouse() -> void:
	mouse_sobre_unidad = null
	#print("salgo")
