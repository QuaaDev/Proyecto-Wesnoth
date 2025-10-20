extends Node
var mouse_sobre_unidad : Node2D
var unidad_a_mover : Node2D
@onready var tile_map: Node2D = $TileMap
@onready var label_unidad_moviendose: Label = $CanvasLayer/hud_derecho/VBoxContainer/nombre_unidad_moviendose
@onready var hud_derecho: ColorRect = $CanvasLayer/hud_derecho
@onready var label_equipo_unidad: Label = $CanvasLayer/hud_derecho/VBoxContainer/equipo_unidad_moviendose
@onready var turno_actual_y_equipo: Label = $CanvasLayer/hud_derecho/VBoxContainer/turno_actual_y_equipo
@onready var label_puntos_movimiento: Label = $CanvasLayer/hud_derecho/VBoxContainer/puntos_movimiento

var mouse_sobre_hud : bool = false

@export var empieza_x_equipo : int = 1
@export var cantidad_total_equipos : int = 0
var equipo_actual : int
var turno_actual : int = 0
var ubicaciones_ocupadas = {} #Diccionario que almacena las ubicaciones ocupadas junto a sus unidades
var casillas_a_atacar = {} #Diccionario que almacena las ubicaciones que se pueden atacar junto a su unidad
func _ready() -> void:
	for i in get_children():
		if i.name.contains("Unidad"):
			ubicaciones_ocupadas[i.coordenada_local_tilemap] = i
	#print(ubicaciones_ocupadas)
	hud_derecho.mouse_entered.connect(mouse_en_hud)
	hud_derecho.mouse_exited.connect(mouse_sale_del_hud)
	hud_derecho.get_node("proximo_turno").pressed.connect(boton_pasar_turno)
	
	#Prepara los grupos de unidades con su respectivo turno
	get_tree().call_group(str(empieza_x_equipo), "empezo_mi_turno")
	equipo_actual = empieza_x_equipo
	turno_actual_y_equipo.text = "turno actual 0, equipo actual: " + str(equipo_actual)
	
func _input(event):
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT: #Si se apreta el mouse izq
				if event.pressed:
					if !mouse_sobre_hud: #Si el mouse esta sobre el hud evita interactuar con unidades y grid
						if mouse_sobre_unidad != null and unidad_a_mover == null:
							#If el mouse esta sobre una unidad AND no hay unidad para mover:
							if mouse_sobre_unidad.es_mi_turno:
								for i in AlgoritmoDijkstra.get_neighbors(mouse_sobre_unidad.coordenada_local_tilemap):
									if ubicaciones_ocupadas.has(i):#Si X casilla vecina tiene una unidad:
										if ubicaciones_ocupadas[i].equipo != mouse_sobre_unidad.equipo: #Y si son de diferente equipo
											casillas_a_atacar[i] = ubicaciones_ocupadas[i]
											print(casillas_a_atacar)
								if mouse_sobre_unidad.puntos_movimiento <= 0:
									#If sus puntos de movimiento actual es igual menor 0
									print("No tengo mas puntos de movimiento loco")
								else:
									#Se selecciona la unidad a interactuar
									unidad_a_mover = mouse_sobre_unidad
									unidad_a_mover.siendo_movido()
									print("Almaceno unidad")
									rellenar_labels(unidad_a_mover)
									AlgoritmoDijkstra.moviendo_unidad(unidad_a_mover,ubicaciones_ocupadas)
							else:
								print("No es mi turno pibe...")
						elif mouse_sobre_unidad != unidad_a_mover and unidad_a_mover != null and verificar_si_coordenadas_estan_libres():
							#If La unidad a mover es diferente a la unidad que esta debajo del mouse AND unidad a mover tiene algun valor AND las coordenadas estan libres:
							#Se selecciona la casilla a moverse
							if  AlgoritmoDijkstra.movimientos_disponibles.has(tile_map.coordenada_global_del_mouse_a_tilemap()):
								#If el tile al que intento mover ESTA DENTRO del diccionario de movimientos:
								print("muevo unidad a espacio vacio")
								mover_unidad(unidad_a_mover)
							else:
								print("Cancelo movimiento por intentar moverme fuera del rango")
							limpiar_unidad_seleccionada()
						elif mouse_sobre_unidad != unidad_a_mover and unidad_a_mover != null and !verificar_si_coordenadas_estan_libres():
							#If La unidad a mover es diferente a la unidad que esta debajo del mouse AND unidad a mover tiene algun valor AND las coordenadas estan ocupadas:
							if verificar_si_son_aliados():
								#Si son aliados, no ataca
								print("Son aliadas las unidades, no puedes mover aqui")
							else:
								if  AlgoritmoDijkstra.movimientos_disponibles.has(tile_map.coordenada_global_del_mouse_a_tilemap()):#Verifica si es un movimiento valido
									print("Te ataco!")
									ubicaciones_ocupadas[mouse_sobre_unidad.get_coordenada_local_tilemap()].morir()
									ubicaciones_ocupadas.erase(mouse_sobre_unidad) #Elimina la unidad que esta sobre el mouse
									mover_unidad(unidad_a_mover)
								else:
									print("Cancelo movimiento por intentar moverme fuera del rango(version ataque)")
								limpiar_unidad_seleccionada()
						elif mouse_sobre_unidad != null and mouse_sobre_unidad == unidad_a_mover:
							#If el mouse esta arriba de una unidad AND la unidad es la propia unidad que se mueve:
							print("Cancelo movimiento")
							limpiar_unidad_seleccionada()
						else:
							#Error
							print("Click Izquierdo condicion no reconocida, valores: ")
							
func mover_unidad(unidad : Node2D):
	#AlgoritmoDijkstra.movimientos_disponibles
	var coordenadas_mouse = tile_map.coordenada_global_del_mouse_a_tilemap()
	ubicaciones_ocupadas.erase(unidad.get_coordenada_local_tilemap()) #Borra su anterior posicion ocupada del diccionario
	unidad.coordenada_local_tilemap = coordenadas_mouse #Actualiza la informacion q tiene la unidad
	ubicaciones_ocupadas[unidad.coordenada_local_tilemap] = unidad #Actualiza la informacion del diccionario
	#-----coste de movimiento a la unidad------
	#obtiene el coste de movimiento de la ubicacion objetivo y luego resta los movimientos a unidad
	unidad.restar_puntos_movimiento(AlgoritmoDijkstra.movimientos_disponibles[tile_map.coordenada_global_del_mouse_a_tilemap()])#Resta los puntos de movimiento
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
		tween.tween_property(unidad,"position",new_position, .5)
	#Objeto a aplicar / propiedad a editar / ubicacion objetivo / velocidad de la animacion
	#print(camino_a_seguir)
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
		#print("Posicion ocupada por " + ubicaciones_ocupadas[coordenadas_mouse].name)
		#print("verificar_si_coordenadas_estan_libres()")
		return false
	else:
		#print("Devuelvo true")
		return true
	
func obtener_unidad_bajo_mouse(unidad : Node2D) -> void: #Almacena referencia a la unidad bajo el mouse
	mouse_sobre_unidad = unidad
	#print("entro")
	
func limpiar_unidad_bajo_mouse() -> void:
	mouse_sobre_unidad = null
	#print("salgo")
func rellenar_labels(unidad : Node2D) ->void:
	label_puntos_movimiento.text = str(unidad.puntos_movimiento) + "/"+str(unidad.puntos_movimiento_maximo)
	label_unidad_moviendose.text = "nombre: " + unidad_a_mover.name
	label_equipo_unidad.text = "equipo: " + str(unidad.equipo)
	
func limpiar_labels() -> void:
	label_unidad_moviendose.text = "null"
	label_equipo_unidad.text = "null"
	label_puntos_movimiento.text = "null"
	
func limpiar_unidad_seleccionada() -> void:
	casillas_a_atacar.clear()#Limpia los posibles ataques almacenados
	unidad_a_mover.ya_no_me_mueven() #<-- solo actualiza el color 
	limpiar_labels() #<--- actualiza labels
	tile_map.limpiar_tiles_movimiento(AlgoritmoDijkstra.movimientos_disponibles)#<-- limpia los tilemaps de movimiento
	unidad_a_mover = null#<---actualiza el estado del script
#------------------señañes-----------------------
func mouse_en_hud() -> void:
	mouse_sobre_hud = true
	#print("El mouse entra al hud")
func mouse_sale_del_hud() -> void:
	mouse_sobre_hud = false
	#print("El mouse sale del hud")
func boton_pasar_turno() -> void:
	get_tree().call_group(str(equipo_actual), "termino_mi_turno") #Termina el turno del equipo anterior
	equipo_actual += 1 #Avanza al siguiente equipo
	if equipo_actual > cantidad_total_equipos:#Si es mayor significa que ya jugaron todos los equipos
		print("terminando turno")
		turno_actual += 1
		equipo_actual = empieza_x_equipo #Reinicia el ciclo de equipos
	get_tree().call_group(str(equipo_actual), "empezo_mi_turno")#Empieza el turno del equipo
	turno_actual_y_equipo.text = "turno actual: "+str(turno_actual) + " equipo actual " + str(equipo_actual) 
	#for i in range(1,cantidad_total_equipos+1):
	#	print("------------")
	#	for node in get_tree().get_nodes_in_group(str(i)):
	#		print(node.name, node.equipo, node.es_mi_turno)
	#	get_tree().call_group(str(i), "termino_mi_turno")
#------------------señañes-----------------------
